import cv2
import numpy as np
from sklearn.ensemble import RandomForestRegressor
from machineModel.api import limiting


def processImage(sc, uploadedFilePath):
    medianHSV = []
    medianBGR = []

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
            medianBGR.append([np.median(img[:, :, 0]), np.median(
                img[:, :, 1]), np.median(img[:, :, 2])])

            img = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
            medianHSV.append([np.median(img[:, :, 0]), np.median(
                img[:, :, 1]), np.median(img[:, :, 2])])

    return np.array(medianBGR), np.array(medianHSV)


def prediction_fun(hsvRegressor, bgrRegressor, sc, uploadedFilePath):
    medianBGR, medianHSV = processImage(sc, uploadedFilePath)

    hsvPrediction = hsvRegressor.predict(sc.transform(medianHSV))
    bgrPrediction = bgrRegressor.predict(sc.transform(medianBGR))

    result = (np.mean(hsvPrediction) + np.mean(bgrPrediction))/2
    return limiting(int(result))
