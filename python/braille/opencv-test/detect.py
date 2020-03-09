'''
Shape detection: https://www.quora.com/How-I-detect-rectangle-using-OpenCV
Filter contours by size: https://answers.opencv.org/question/65005/in-python-how-can-i-reduce-a-list-of-contours-to-those-of-a-specified-size/
Crop image: https://stackoverflow.com/questions/28759253/how-to-crop-the-internal-area-of-a-contour
Otsu's thresholding: https://docs.opencv.org/master/d7/d4d/tutorial_py_thresholding.html
Bounding rectangle: https://docs.opencv.org/3.4/dd/d49/tutorial_py_contour_features.html
'''
from typing import List

from matplotlib import pyplot as plt
import cv2


def find_pentagons(img):
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    ret, thresh = cv2.threshold(gray, 127, 255, 1)
    contours, h = cv2.findContours(thresh, 1, 2)

    bigcontours = []
    displayed_pic = img.copy()
    for cnt in contours:
        approx = cv2.approxPolyDP(cnt, 0.01*cv2.arcLength(cnt,True),True)
        area = cv2.contourArea(cnt)
        if len(approx) == 5 and area > 2000:  # pentagon
            bigcontours.append(cnt)
            cv2.drawContours(displayed_pic,[cnt], 0, 255,-1)

    return bigcontours, displayed_pic


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
    coords = [(c[0]/width, c[1]/height) for c in coords]
    dots = []
    for coord in coords:
        dots.append(classify_dots(coord))
    dots.sort()

    #cv2.imshow("binarized letter", thresh)
    #cv2.waitKey(0)
    return brl_to_rus(dots), thresh

def classify_dots(coord):
    col = 0 if coord[0] < 0.5 else 1
    if coord[1] < 11/30:
        row = 0
    elif coord[1] < 19/30:
        row = 1
    else:
        row = 2
    return row + 3*col + 1  # dot number from 1 to 6


def brl_to_rus(brl: List[int]) -> str:
    if brl == [1]:
        return "а"
    elif brl == [1, 2]:
        return "б"
    elif brl == [2, 4, 5, 6]:
        return "в"
    elif brl == [1, 2, 4, 5]:
        return "г"
    elif brl == [1, 4, 5]:
        return "д"
    elif brl == [1, 5]:
        return "е"
    elif brl == [1, 6]:
        return "ё"
    elif brl == [2, 4, 5]:
        return "ж"
    elif brl == [1, 3, 5, 6]:
        return "з"
    elif brl == [2, 4]:
        return "и"
    return ""


if __name__ == "__main__":
    whole_img = cv2.imread('tiles2.JPG')
    pentagon_contours, img_with_pentagons = find_pentagons(whole_img)
    '''
    TODO
    вместо следующего шага:
    1. У каждого пентагона найти наибольшую сторону
    2. Найти ограничивающую рамку и вырезать в полтора раза большую область
    3. Повернуть изображение пентагона на угол, соответствующий углу поворота наибольшей стороны
    4. Обрезать уже получившуюся фигуру
    '''
    cropped_letters = crop_letters(whole_img, pentagon_contours)
    classified = []
    for i in range(len(cropped_letters)):
        let, thresh = find_dots(cropped_letters[i])
        classified.append((let, thresh))
        print(let)
    fig = plt.figure()
    subplots = []
    n = len(classified)
    for i in range(n):
        subplots.append(fig.add_subplot(1, n, i+1))
        subplots[-1].set_title(classified[i][0])
        subfig = plt.imshow(classified[i][1], cmap='binary')
        subfig.axes.get_xaxis().set_visible(False)
        subfig.axes.get_yaxis().set_visible(False)
    plt.axis('off')

    cv2.imshow('initial image with detected pentagons', img_with_pentagons)
    plt.show()
    cv2.waitKey(0)
    cv2.destroyAllWindows()