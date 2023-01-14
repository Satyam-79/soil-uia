# Soil Moisture Detection App

This repository contains the code for a deep learning-based application for determining soil moisture. The app uses a standard image from a mobile camera and a unique machine learning model, created with a locally generated dataset, to identify different soil types' moisture levels. The app can be customized for each user and trained to identify different soil types' moisture levels using a reference image of the soil. Using weather information and soil type, the app can forecast the soil moisture and determine when is the best time to irrigate.

## Technology Used
- Deep Neural Network-TensorFlow
- Image Processing-OpenCV
- Python
- FlaskApi

## Features
- Soil moisture detection using a standard image from a mobile camera 
- A unique machine learning model created with a locally generated dataset
- Customizable for different soil types and user-specific needs
- Soil moisture forecasting using weather information and soil type
- Determining the best time to irrigate

## How to Run
1. Clone the repository to your local machine
```
git clone https://github.com/Satyam-79/soil-uia.git
```
2. Navigate to the project directory
```
cd soil-uia
```
3. Create and activate a virtual environment
```
python -m venv env
source env/bin/activate
```
4. Install the required dependencies
```
pip install -r requirements.txt
```
5. Run the app
```
flask run
```
6. Open your browser and navigate to http://localhost:5000 to check the api is active.
7. use IP:PROT/upload to upload image using POST in multipart.
