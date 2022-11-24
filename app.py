import os
import shutil
from flask import Flask, request, jsonify
from machineModel.ml import prediction_fun
from joblib import load
from sklearn.ensemble import RandomForestRegressor


app = Flask(__name__)

UPLOAD = 'uploadedimages/'
HSVmodel = 'machineModel/savedWeights/hsvModel.sav'
weatherModel = 'machineModel/savedWeights/weatherRegressor.sav'
standardScaler = 'machineModel/savedWeights/std_scaler.bin'
weatherScaler = 'machineModel/savedWeights/weather_scaler.bin'


@app.route('/')
def index():
    result = prediction_fun(hsvRegressor,
                            sc, uploadedFilePath='82.jpg')
    HTML = f'''
    <div style="font-family:Arial;text-align:center;">
        <h1>Optical Moisture Detector</h1>
        <h3>API IS RUNNING!</h3>
        <h3>Moisture content: {result} </h3>
        
    </div>
        '''
    return HTML


@app.route('/upload', methods=['POST'])
def upload():

    if (request.method == "POST"):
        imagefile = request.files['image']
        # lat = request.form["Lat"]
        # lon = request.form["Lon"]
        # print(lat,lon)
        # lat = request.args['Lat']
        # lon = request.args['Lon']
        if os.path.exists(UPLOAD):
            shutil.rmtree(UPLOAD)
        os.mkdir(UPLOAD)
        # Save Uploaded Image
        filename = werkzeug.utils.secure_filename(imagefile.filename)
        uploadedFilePath="./uploadedimages/sgsd.jpg"
        imagefile.save(uploadedFilePath)
        # print(uploadedFilePath)
        
    # Model
        result = prediction_fun(hsvRegressor, weatherRegressor,
                                sc,w_sc, uploadedFilePath)
        os.remove(uploadedFilePath)


        print(result)
        return jsonify(status='Uploaded Successfully', prediction=result,temperature=18,weather="cloudy",imagefile='82.jpg')


with app.app_context():
    hsvRegressor = load(HSVmodel)
    weatherRegressor = load(weatherModel)
    sc = load(standardScaler)
    w_sc = load(weatherScaler)

app.run(debug=True,host='0.0.0.0',port=5000)