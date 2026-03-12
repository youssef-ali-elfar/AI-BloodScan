import streamlit as st
import requests
from PIL import Image
import io
import pandas as pd

st.set_page_config(page_title="AI BloodScan - CBC Classifier", page_icon="🩸", layout="wide")

st.title("🩸 AI BloodScan: CBC Analysis System")
st.markdown("""
Upload a CBC report image to extract values and classify potential blood conditions using AI.
""")

# URL of the Flask backend
BACKEND_URL = "http://localhost:5000/predict_from_image"

uploaded_file = st.file_uploader("Choose a CBC report image...", type=["jpg", "jpeg", "png"])

if uploaded_file is not None:
    col1, col2 = st.columns(2)

    with col1:
        st.image(uploaded_file, caption='Uploaded CBC Report', use_container_width=True)

    with col2:
        if st.button("Analyze Report"):
            with st.spinner('Extracting data and running AI models...'):
                # Prepare the image for the request
                img_bytes = uploaded_file.getvalue()
                files = {"image": (uploaded_file.name, img_bytes, uploaded_file.type)}

                try:
                    response = requests.post(BACKEND_URL, files=files)

                    if response.status_code == 200:
                        result = response.json()

                        st.success("Analysis Complete!")

                        # Display Prediction
                        st.header(f"Prediction: {result['predicted_class']}")
                        st.subheader(f"Confidence: {result['confidence']:.2%}")

                        # Display Extracted Values
                        st.write("### Extracted Values")
                        cbc_data = result['cbc_values']
                        df = pd.DataFrame(list(cbc_data.items()), columns=['Parameter', 'Value'])
                        st.table(df)

                        if result['raw_json']:
                            with st.expander("View Raw JSON Data"):
                                st.json(result['raw_json'])
                    else:
                        st.error(f"Error from server: {response.status_code}")
                        st.write(response.text)

                except Exception as e:
                    st.error(f"Failed to connect to backend: {e}")
                    st.info("Make sure the Flask backend is running at http://localhost:5000")

st.divider()
st.markdown("Developed by AI BloodScan Team")
