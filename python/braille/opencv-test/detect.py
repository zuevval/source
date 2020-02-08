'''
Shape detection: https://www.quora.com/How-I-detect-rectangle-using-OpenCV
Filter contours by size: https://answers.opencv.org/question/65005/in-python-how-can-i-reduce-a-list-of-contours-to-those-of-a-specified-size/
Crop image: https://stackoverflow.com/questions/28759253/how-to-crop-the-internal-area-of-a-contour
Otsu's thresholding: https://docs.opencv.org/master/d7/d4d/tutorial_py_thresholding.html
Bounding rectangle: https://docs.opencv.org/3.4/dd/d49/tutorial_py_contour_features.html
'''

import numpy as np
import cv2


def find_pentagons(img):
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    ret, thresh = cv2.threshold(gray, 127, 255, 1)
    contours, h = cv2.findContours(thresh, 1, 2)

    bigcontours = []
    displayed_pic = img.copy()
    for cnt in contours:
        approx = cv2.approxPolyDP(cnt,0.01*cv2.arcLength(cnt,True),True)
        area = cv2.contourArea(cnt)
        if len(approx) == 5 and area > 2000:  # pentagon
            bigcontours.append(cnt)
            cv2.drawContours(displayed_pic,[cnt],0,255,-1)

    cv2.imshow('img',displayed_pic)
    cv2.waitKey(0)
    cv2.destroyAllWindows()
    return bigcontours


def crop_letters(img, contours):
    letters = []
    for i in range(len(contours)):
        x, y, w, h = cv2.boundingRect(contours[i])
        cropped_area = img[y:y + h, x:x + w]
        letters.append(cropped_area)
        #cv2.imshow('one letter', cropped_area)
        #cv2.waitKey()
    return letters


def find_dots(letter_pic):
    gray = cv2.cvtColor(letter_pic, cv2.COLOR_BGR2GRAY)
    blur = cv2.GaussianBlur(gray, (5, 5), 0)
    ret, thresh = cv2.threshold(blur, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)

    contours, h = cv2.findContours(thresh, 1, 2)
    bigcontours = []
    for cnt in contours:
        area = cv2.contourArea(cnt)
        if 10 < area < 1000:  # actually ~100
            bigcontours.append(cnt)
    coords = []
    for cnt in bigcontours:
        x, y, w, h = cv2.boundingRect(cnt)
        cv2.rectangle(thresh, (x, y), (x + w, y + h), (0, 0, 255), 1)
        coords.append((x + w/2, y + h/2))

    height, width, _ = letter_pic.shape
    coords = [(c[0]/height, c[1]/width) for c in coords]
    for coord in coords:
        classify_dots(coord)

    cv2.imshow("output", thresh)
    cv2.waitKey(0)
    return coords, thresh

def classify_dots(coord):
    col = 1 if coord[0] < 0.33 else 2
    print("col:" + str(col))
    # TODO detect row





if __name__ == "__main__":
    whole_img = cv2.imread('tiles2.JPG')
    pentagon_contours = find_pentagons(whole_img)
    cropped_letters = crop_letters(whole_img, pentagon_contours)
    for i in range(len(cropped_letters)):
        coords, thresh = find_dots(cropped_letters[i])
        print(coords)