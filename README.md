# 🩸 AI BloodScan
A full end-to-end AI system for classifying CBC (Complete Blood Count) lab reports using OCR + Preprocessing + Machine Learning models + Mobile App.
<img width="1024" height="1024" alt="Gemini_Generated_Image_u40xflu40xflu40x" src="https://github.com/user-attachments/assets/216add15-3750-4dbb-9957-0b4ba5d948b2" />

---

## 🚀 Project Overview
AI BloodScan allows users to upload a CBC report image from their mobile phone, then:

1. Extracts the values using OCR (Gemini/Groq)
2. Cleans + standardizes + normalizes the values
3. Runs ML models (MLP, TabNet, Hybrid CNN)
4. Returns Normal / Abnormal classification for each blood parameter
5. Displays results inside a Flutter mobile app UI

The goal is to help people understand CBC results quickly and make healthcare more accessible.

---

## 📱 Mobile App (Flutter)
- Upload CBC image
- Preview extracted values
- Classification (green/red)
- Export results
- Fully connected to FastAPI backend

Located in: `mobile_app/`

---

## 🧠 Machine Learning Models

### 1) **MLP Classifier**
- Simple, efficient, fast
- Baseline model

### 2) **TabNet — Final Model**
- Best accuracy
- Best stability
- Best interpretability
- Used as final deployed model

### 3) **Hybrid 1D-CNN (for comparison)**

Model files and training notebooks are in:
`ml_models/`

---

## 📊 Dataset
- Total: 7196 samples
- Numerical tabular data (after OCR)
- 15 classes (Normal + Multiple Abnormalities)
- Balanced using SMOTE and class weights

---

## 🧼 Preprocessing Pipeline
Located in: `preprocessing/`

Steps:
- OCR cleaning (regex + unit normalization)
- Feature mapping
- Outlier removal (medical-rule-based)
- Missing value handling
- Scaling & normalization

---

## 🧩 System Architecture

(Architecture image here)

---

## 🧪 Results
- Accuracy (clean data): **93–96%**
- Accuracy (OCR data): **78–85%**
- Model comparison in `results/`

---

## ⚙ Backend (FastAPI)
Located in: `backend_api/`

Features:
- Receives OCR data
- Runs ML models
- Returns classification JSON
- Lightweight & fast

Run:
uvicorn main:app --reload

yaml
Copy code

---

## 🧑‍🤝‍🧑 Team Members
- Ashraf Amr — Mobile + Integration
- Kareem Abd El Nasser — API + GUI + MLP
- Yousef Ali — MLP + Backend
- Ezz Eldin Yasser — Preprocessing
- Sandra Samer — CNN + TabNet
- Rosana Zarif — CNN + TabNet
- Avronia Magdy — Comparison + Documentation

---

## 📜 License
MIT License
