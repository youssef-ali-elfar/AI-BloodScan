# Backend Service

This is the backend service for the AI BloodScan application, built with Flask and PyTorch. It provides an API to analyze CBC blood test report images using Google Gemini for OCR/extraction and a local PyTorch MLP model for diagnosis prediction.

## Prerequisites

- Python 3.8 or higher
- **Important**: The following model files must be present in this directory for the backend to run:
  - `label_encoder.pkl`
  - `cbc_model_final_weights.pth`

## Installation

1.  **Install Dependencies**:
    Run the following command to install the required Python packages:

    ```bash
    pip install flask torch numpy requests scikit-learn
    ```
    *(Note: `scikit-learn` is likely required to load the `label_encoder.pkl`)*

## Running the Backend

1.  **Start the Server**:
    Navigate to this directory in your terminal and run:

    ```bash
    python backend.py
    ```

2.  **Server Address**:
    The server will start at `http://0.0.0.0:5000`.

## API Endpoints

### `POST /predict_from_image`

Analyzes an uploaded image of a CBC blood test report.

-   **Method**: `POST`
-   **Body**: `multipart/form-data`
    -   `image`: The image file to analyze.
-   **Response**: JSON object containing extracted values, specific CBC metrics, predicted class (diagnosis), and confidence score.
