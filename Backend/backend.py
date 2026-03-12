import torch
import torch.nn as nn
import numpy as np
import pickle
import joblib
import os
from flask import Flask, request, jsonify
import requests
import base64
import json
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# ==== إعداد الـ Flask app ====
app = Flask(__name__)

# ==== مسارات الملفات ====
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
ENCODER_PATH = os.path.join(BASE_DIR, "Preprocessing", "label_encoder.pkl")
SCALER_PATH = os.path.join(BASE_DIR, "Preprocessing", "standard_scaler.joblib")
MODEL_PATH = os.path.join(BASE_DIR, "ml_models", "MLP", "cbc_model_final_weights2.pth")

# ==== تحميل الـ LabelEncoder ====
with open(ENCODER_PATH, "rb") as f:
    le = pickle.load(f)

label_map = {i: label for i, label in enumerate(le.classes_)}

# ==== تحميل الـ Scaler ====
scaler = joblib.load(SCALER_PATH)

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
model.load_state_dict(torch.load(MODEL_PATH, map_location=device))
model.eval()

# ==== دالة Gemini extraction مع dict ثابت ====
def extract_cbc_values(image_bytes, api_key):
    if not api_key:
        print("❌ Gemini API Key is missing!")
        return {}, {}

    base64_image = base64.b64encode(image_bytes).decode("utf-8")

    # Use a stable Gemini model
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={api_key}"
    headers = {"Content-Type": "application/json"}

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
  "Age": "45",
  "HGB": "14.0",
  "RBC": "4.79",
  "WBC": "9200",
  "PLT": "410000",
  "LYMP": "31.3",
  "MONO": "3.5",
  "HCT": "40.3",
  "MCV": "84.1",
  "MCH": "29.2",
  "MCHC": "34.7",
  "RDW": "12.6",
  "PDW": "13.6",
  "MPV": "10.2",
  "PCT": "0.41"
}
                    """}
                ]
            }
        ]
    }

    try:
        response = requests.post(url, headers=headers, json=data)
        response.raise_for_status()
        extracted_text = response.json()["candidates"][0]["content"]["parts"][0]["text"]

        if extracted_text.startswith("```json"):
            extracted_text = extracted_text[len("```json"):].strip()
        if extracted_text.endswith("```"):
            extracted_text = extracted_text[:-3].strip()

        try:
            parsed_json = json.loads(extracted_text)
        except Exception as e:
            print("❌ Could not parse JSON:", e)
            parsed_json = {}

        return parsed_json, parsed_json

    except Exception as e:
        print("❌ Gemini extraction error:", e)
        return {}, {}

# ==== نقطة النهاية للتنبؤ من صورة CBC ====
@app.route('/predict_from_image', methods=['POST'])
def predict_from_image():
    api_key = os.getenv("GEMINI_API_KEY")
    if 'image' not in request.files:
        return jsonify({"error": "No image file provided"}), 400

    image_file = request.files['image']

    try:
        image_bytes = image_file.read()
        cbc_values, raw_json = extract_cbc_values(image_bytes, api_key)

        # ==== تحويل القيم الرقمية للـ MLP بالترتيب الصحيح ====
        # الترتيب في التدريب: ['Gender', 'Age', 'HGB', 'RBC', 'WBC', 'PLT', 'LYMP', 'MONO', 'HCT', 'MCV', 'MCH', 'MCHC', 'RDW', 'PDW', 'MPV', 'PCT']
        feature_keys_ordered = ['Gender', 'Age', 'HGB', 'RBC', 'WBC', 'PLT', 'LYMP', 'MONO',
                               'HCT', 'MCV', 'MCH', 'MCHC', 'RDW', 'PDW', 'MPV', 'PCT']

        features_list = []
        for key in feature_keys_ordered:
            value = cbc_values.get(key)
            if key == 'Gender':
                # التدريب استخدم 0 للذكور و 1 للإناث (أو العكس، حسب prepare_data.ipynb)
                # في الـ notebook: Gender كان 0 و 1. 0 لـ Male غالباً.
                features_list.append(0.0 if (value is None or str(value).lower().startswith('m')) else 1.0)
            elif key == 'Age':
                try:
                    # استخراج الأرقام فقط من العمر
                    age_val = ''.join(filter(str.isdigit, str(value))) if value is not None else "0"
                    features_list.append(float(age_val) if age_val else 0.0)
                except:
                    features_list.append(0.0)
            else:
                try:
                    features_list.append(float(value) if value not in [None, "null"] else 0.0)
                except:
                    features_list.append(0.0)

        features_array = np.array(features_list, dtype=np.float32).reshape(1, -1)

        # ==== تطبيق الـ Scaling ====
        features_scaled = scaler.transform(features_array)

        features_tensor = torch.from_numpy(features_scaled.astype(np.float32)).to(device)

        with torch.no_grad():
            outputs = model(features_tensor)
            probs = torch.softmax(outputs, dim=1)
            pred_class_idx = torch.argmax(probs, dim=1).item()
            confidence = float(torch.max(probs).item())
            pred_class = label_map[pred_class_idx]

        return jsonify({
            "raw_json": raw_json,
            "cbc_values": cbc_values,
            "predicted_class": pred_class,
            "confidence": confidence
        })

    except Exception as e:
        print("❌ Exception:", e)
        return jsonify({"error": str(e)}), 500

@app.route('/health', methods=['GET'])
def health():
    return jsonify({"status": "healthy"}), 200

# ==== تشغيل السيرفر ====
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
