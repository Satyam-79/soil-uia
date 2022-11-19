import os
import shutil
from flask import Flask, request, jsonify
from machineModel.ml import prediction_fun
from joblib import load
from sklearn.ensemble import RandomForestRegressor


app = Flask(__name__)

UPLOAD = 'uploads/'
HSVmodel = 'machineModel/savedWeights/hsvModel.sav'
BGRmodel = 'machineModel/savedWeights/bgrModel.sav'
standardScaler = 'machineModel/savedWeights/std_scaler.bin'


@app.route('/')
def index():
    result = prediction_fun(hsvRegressor, bgrRegressor,
                            sc, uploadedFilePath='82.jpg')
    HTML = f'''
    <div style="font-family:Arial;text-align:center;">
        <h1>unScrawl</h1>
        <h3>API IS RUNNING!</h3>
        <h3>Moisture content: {result} </h3>
        
    </div>
        '''
    return HTML


@app.route('/upload', methods=['POST'])
def upload():

    if os.path.exists(UPLOAD):
        shutil.rmtree(UPLOAD)

    os.mkdir(UPLOAD)

    # Save Uploaded Image
    uploadedFilePath = UPLOAD+'uploaded_image.png'
    imageFile.save(uploadedFilePath)

    # Model
    result = prediction_fun(hsvRegressor, bgrRegressor,
                            sc, uploadedFilePath='82.jpg')

    shutil.rmtree(UPLOAD)

    return jsonify(status='Uploaded Successfully', prediction=result)


with app.app_context():
    hsvRegressor = load(HSVmodel)
    bgrRegressor = load(BGRmodel)
    sc = load(standardScaler)
# app.run()
