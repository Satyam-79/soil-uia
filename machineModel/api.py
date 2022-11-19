def greenRemove():
    mask = cv2.inRange(img, (36, 25, 25), (86, 255,255))
    iMask = mask<1
    green = np.zeros_like(img, np.uint8)
    green[iMask] = img[iMask]
    return green

