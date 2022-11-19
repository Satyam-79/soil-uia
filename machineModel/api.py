def greenRemove(img):
    mask = cv2.inRange(img, (36, 25, 25), (86, 255,255))
    iMask = mask<1
    green = np.zeros_like(img, np.uint8)
    green[iMask] = img[iMask]
    return green

def limiting(value):
    if value <= 0:
        return 0
    elif value >= 100:
        return 100
    else:
        return value