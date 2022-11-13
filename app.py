import os
import shutil
from flask import Flask, request, jsonify
from machineModel.ml import prediction_fun

app = Flask(__name__)

UPLOAD = 'uploads/'


@app.route('/')
def index():
    HTML = '''
    <div style="font-family:Arial;text-align:center;">
        <h1>unScrawl</h1>
        <h3>API IS RUNNING!</h3>
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
    resultList = prediction_fun(UPLOAD, uploadedFilePath)

    # Firebase Storage
    # folderID = uploadRecord(
    #     mainImagePath, PREDICTION, dictionaryList)  # Need Changes

    shutil.rmtree(UPLOAD)

    return jsonify(status='Uploaded Successfully', prediction=resultList)
