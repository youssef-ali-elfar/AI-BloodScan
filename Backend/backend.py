import torch
import torch.nn as nn
import numpy as np
import pickle
from flask import Flask, request, jsonify
import requests
import base64
import json

# ==== إعداد الـ Flask app ====
app = Flask(__name__)

# ==== تحميل الـ LabelEncoder ====
with open("label_encoder.pkl", "rb") as f:
    le = pickle.load(f)

label_map = {i: label for i, label in enumerate(le.classes_)}

# ==== تعريف موديل MLP ====
class MLP(nn.Module):
    def __init__(self, input_dim=16, output_dim=15, dropout_rate=0.3):
        super().__init__()
        self.net = nn.Sequential(
            nn.Linear(input_dim, 256),
            nn.ReLU(),
            nn.BatchNorm1d(256),
            nn.Dropout(dropout_rate),
            nn.Linear(256, 128),
            nn.ReLU(),
            nn.BatchNorm1d(128),
            nn.Dropout(dropout_rate),
            nn.Linear(128, 64),
            nn.ReLU(),
            nn.BatchNorm1d(64),
            nn.Dropout(dropout_rate),
            nn.Linear(64, output_dim)
        )

    def forward(self, x):
        return self.net(x)

# ==== تحميل الـ weights ====
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model = MLP(input_dim=16, output_dim=len(label_map), dropout_rate=0.3).to(device)
model.load_state_dict(torch.load("cbc_model_final_weights.pth", map_location=device))
model.eval()

# ==== دالة Gemini extraction مع dict ثابت ====
def extract_cbc_values(image_bytes, api_key):
    print("🔹 Original image bytes length:", len(image_bytes))

    base64_image = base64.b64encode(image_bytes).decode("utf-8")
    print("🔹 Base64 image length:", len(base64_image))

    url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:generateContent"
    headers = {"x-goog-api-key": api_key, "Content-Type": "application/json"}

    # ==== prompt محدد يخرج dict واحد ثابت ====
    data = {
        "contents": [
            {
                "parts": [
                    {"inline_data": {"mime_type": "image/jpeg", "data": base64_image}},
                    {"text": """
أنت خبير تحاليل طبية. قم بتحليل صورة تقرير CBC المرفقة بدقة.
المطلوب استخراج القيم التالية: Gender, Age, HGB, RBC, WBC, PLT, LYMP, MONO, HCT, MCV, MCH, MCHC, RDW, PDW, MPV, PCT.
**أرجو إخراج JSON واحد فقط** كما يلي، بدون أي array أو keys إضافية:
{
  "Gender": "Male",
  "Age": "15",
  "HGB": "14.0",
  "RBC": "4.79",
  "WBC": "9.2",
  "PLT": "410",
  "LYMP": "3.13",
  "MONO": "0.35",
  "HCT": "40.3",
  "MCV": "84.1",
  "MCH": "29.2",
  "MCHC": "34.7",
  "RDW": "12.6",
  "PDW": null,
  "MPV": null,
  "PCT": null
}
                    """}
                ]
            }
        ]
    }

    try:
        response = requests.post(url, headers=headers, json=data)
        print("🔹 Gemini API status code:", response.status_code)
        print("🔹 Gemini raw response (first 500 chars):", response.text[:500])

        response.raise_for_status()
        extracted_text = response.json()["candidates"][0]["content"]["parts"][0]["text"]
        print("🔹 Extracted text from Gemini:", extracted_text[:500])

        if extracted_text.startswith("```json"):
            extracted_text = extracted_text[len("```json"):].strip()
        if extracted_text.endswith("```"):
            extracted_text = extracted_text[:-3].strip()
        print("🔹 Cleaned extracted text:", extracted_text[:500])

        try:
            parsed_json = json.loads(extracted_text)
            print("🔹 Parsed JSON type:", type(parsed_json))
        except Exception as e:
            print("❌ Could not parse JSON:", e)
            parsed_json = {}

        cbc_values = parsed_json
        print("🔹 Extracted CBC values:", cbc_values)
        return cbc_values, parsed_json

    except Exception as e:
        print("❌ Gemini extraction error:", e)
        feature_keys = ['Gender', 'Age', 'HGB', 'RBC', 'WBC', 'PLT', 'LYMP', 'MONO',
                        'HCT', 'MCV', 'MCH', 'MCHC', 'RDW', 'PDW', 'MPV', 'PCT']
        return {k: None for k in feature_keys}, {}

# ==== نقطة النهاية للتنبؤ من صورة CBC ====
@app.route('/predict_from_image', methods=['POST'])
def predict_from_image():
    api_key = "AIzaSyAda0XKbmrdOed6JUeFw1jsUqdlgsIMOvc"
    if 'image' not in request.files:
        return jsonify({"error": "No image file provided"}), 400

    image_file = request.files['image']

    try:
        print("🔹 Received image:", image_file.filename)

        image_bytes = image_file.read()
        cbc_values, raw_json = extract_cbc_values(image_bytes, api_key)

        # ==== تحويل القيم الرقمية للـ MLP ====
        feature_keys_numeric = ['HGB', 'RBC', 'WBC', 'PLT', 'LYMP', 'MONO',
                                'HCT', 'MCV', 'MCH', 'MCHC', 'RDW', 'PDW', 'MPV', 'PCT',
                                'Gender', 'Age']  # 16 features

        features_list = []
        for key in feature_keys_numeric:
            value = cbc_values.get(key)
            if key == 'Gender':
                features_list.append(0.0 if (value is None or str(value).lower().startswith('m')) else 1.0)
            elif key == 'Age':
                try:
                    features_list.append(float(''.join(filter(str.isdigit, str(value)))) if value is not None else 0.0)
                except:
                    features_list.append(0.0)
            else:
                try:
                    features_list.append(float(value) if value not in [None, "null"] else 0.0)
                except:
                    features_list.append(0.0)

        features_array = np.array(features_list, dtype=np.float32).reshape(1, -1)
        print("🔹 Features array for MLP:", features_array)

        features_tensor = torch.from_numpy(features_array).to(device)

        with torch.no_grad():
            outputs = model(features_tensor)
            probs = torch.softmax(outputs, dim=1)
            pred_class_idx = torch.argmax(probs, dim=1).item()
            confidence = float(torch.max(probs).item())
            pred_class = label_map[pred_class_idx]
            print(f"🔹 Prediction: {pred_class}, Confidence: {confidence}")

        # ==== تحويل كل القيم الرقمية في JSON للـ frontend ====
        cbc_values_numeric = {}
        for k, v in cbc_values.items():
            if v is None or v == "null":
                cbc_values_numeric[k] = 0.0
            elif k not in ["Gender", "Age"]:
                try:
                    cbc_values_numeric[k] = float(v)
                except:
                    cbc_values_numeric[k] = 0.0
            else:
                cbc_values_numeric[k] = v

        return jsonify({
            "raw_json": raw_json,
            "cbc_values": cbc_values_numeric,
            "predicted_class": pred_class,
            "confidence": confidence
        })

    except Exception as e:
        print("❌ Exception:", e)
        return jsonify({"error": str(e)}), 500

# ==== تشغيل السيرفر ====
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
