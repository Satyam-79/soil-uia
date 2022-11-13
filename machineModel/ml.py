from random import normalvariate


def limiting(value):
    if value <= 0:
        return 0
    elif value >= 100:
        return 100
    else:
        return value


def prediction_fun(UPLOAD, uploadedFilePath):
    return limiting(normalvariate(50, 50))
