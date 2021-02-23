import random
from typing import Optional

import cv2
import numpy as np


def brightness(img, low, high, seed: Optional[int] = None):
    # https://towardsdatascience.com/complete-image-augmentation-in-opencv-31a6b02694f5
    random.seed(seed)
    value = random.uniform(low, high)
    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    hsv = np.array(hsv, dtype=np.float64)
    hsv[:, :, 1] = hsv[:, :, 1] * value
    hsv[:, :, 1][hsv[:, :, 1] > 255] = 255
    hsv[:, :, 2] = hsv[:, :, 2] * value
    hsv[:, :, 2][hsv[:, :, 2] > 255] = 255
    hsv = np.array(hsv, dtype=np.uint8)
    img = cv2.cvtColor(hsv, cv2.COLOR_HSV2BGR)
    return img


def main():
    img: np.ndarray = cv2.imread('book.jpg')
    rows, cols, _ = img.shape

    rotation_mtx = cv2.getRotationMatrix2D((cols / 2, rows / 2), 45, 1)
    img_rotated = cv2.warpAffine(img, rotation_mtx, (cols, rows))
    cv2.imwrite("out/rotated.jpg", img_rotated)

    pts1 = np.float32([[0, 0], [0, cols], [rows, cols / 4], [rows, cols * 3 / 4]])
    pts2 = np.float32([[0, 0], [0, cols], [rows, 0], [rows, cols]])
    warp_mtx = cv2.getPerspectiveTransform(pts1, pts2)
    img_warped = cv2.warpPerspective(img, warp_mtx, (cols, rows))
    cv2.imwrite("out/warped.jpg", img_warped)

    img_bright = brightness(img, 0.7, 1.5, seed=0)
    cv2.imwrite("out/bright.jpg", img_bright)

    img_combined = cv2.warpPerspective(brightness(img_rotated, .7, 1.5, seed=0), warp_mtx, (cols, rows))
    cv2.imwrite("out/combined.jpg", img_combined)


if __name__ == "__main__":
    main()
