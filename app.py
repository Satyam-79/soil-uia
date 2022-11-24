import os
import shutil
from flask import Flask, request, jsonify
from machineModel.ml import prediction_fun
from joblib import load
from sklearn.ensemble import RandomForestRegressor


app = Flask(__name__)

UPLOAD = 'uploads/'
HSVmodel = 'machineModel/savedWeights/hsvModel.sav'
standardScaler = 'machineModel/savedWeights/std_scaler.bin'


@app.route('/')
def index():
    listOfFiles = list()
    for (dirpath, dirnames, filenames) in os.walk("C:/Users/satya/Pictures/soil/ds"):
        listOfFiles += [os.path.join(dirpath, file) for file in filenames]
    results=[]
    listOfFiles.sort()
    print(listOfFiles)
    for path in listOfFiles:
        result = prediction_fun(hsvRegressor, bgrRegressor,
                                sc, uploadedFilePath=path)
        results.append(result)
    HTML = f'''
    <div style="font-family:Arial;text-align:center;">
        <h1>Optical Moisture Detector</h1>
        <h3>API IS RUNNING!</h3>
        <h3>Moisture content: {result} </h3>
    </div>
        '''
    print(results)
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
    sc = load(standardScaler)

app.run(debug=True,host='0.0.0.0',port=5000)