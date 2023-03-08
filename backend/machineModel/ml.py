import cv2
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from machineModel.api import limiting
from urllib.request import urlopen
import json


def processImage(uploadedFilePath):
    medianHSV = []

    im = cv2.imread(uploadedFilePath)
    if im.shape[0] > im.shape[1]:
        im = cv2.rotate(src=im, rotateCode=cv2.ROTATE_90_CLOCKWISE)

    imgHeight = im.shape[0]
    imgWidth = im.shape[1]
    y1 = 0
    M = imgHeight//2
    N = imgWidth//2

    for y in range(0, imgHeight, M):
        for x in range(0, imgWidth, N):
            y1 = y + M
            x1 = x + N
            img = im[y:y+M, x:x+N, :]

            img = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
            medianHSV.append([np.median(img[:, :, 0]), np.median(
                img[:, :, 1]), np.median(img[:, :, 2])])

    return np.array(medianHSV)


def weatherPrediction(weatherRegressor, w_sc):
    url = "https://api.weatherapi.com/v1/forecast.json?key=bc63089e69da4649b0571422222311&q=28.439422,77.508743&days=5"
    parameters = ['avgtemp_c', 'maxwind_kph', 'totalprecip_mm', 'avghumidity']

    response = urlopen(url)
    data_json = json.loads(response.read())
    weather = []
    icons = []
    for i in range(5):
        row = []
        for para in parameters:
            row.append(data_json['forecast']['forecastday'][i]['day'][para])
        icons.append(data_json['forecast']['forecastday']
                     [i]['day']['condition']['icon'])
        weather.append(row)

    prediction = weatherRegressor.predict(w_sc.transform(np.array(weather)))
    prediction = prediction-1

    # print(prediction)

    return weather, prediction, icons


def prediction_fun(hsvRegressor, weatherRegressor, sc, w_sc, uploadedFilePath):
    medianHSV = processImage(uploadedFilePath)

    hsvPrediction = hsvRegressor.predict(sc.transform(medianHSV))

    result = np.mean(hsvPrediction)

    weather, w_Prediction, icons = weatherPrediction(weatherRegressor, w_sc)

    data = result
    moistureList=[]
    moistureList.append(data)
    
    for preds in w_Prediction:
        data = preds*data
        moistureList.append(data)
    print(moistureList)
    return limiting(int(result)),weather, icons,moistureList

