from pathlib import Path

import cv2


def split(directory: Path, filename: str, extension: str, n_horis: int = 10, n_vert: int = 10) -> None:
    out_path = directory / (filename + "_split")
    out_path.mkdir(parents=True, exist_ok=True)
    in_path = directory / (filename + extension)
    print("reading image from path: " + str(in_path))  # TODO logging
    whole_img = cv2.imread(str(in_path))
    height, width = whole_img.shape[:2]

    k = 0
    w, h = int(width / n_horis), int(height / n_horis)
    for i in range(n_horis):
        x = int(width * i / n_horis)
        for j in range(n_vert):
            y = int(height * j / n_vert)
            new_img = whole_img[y:y + h, x:x + w]
            cv2.imwrite(str(out_path / (str(k) + ".jpg")), new_img)
            k += 1


if __name__ == "__main__":
    split(Path("img/"), "syf_3", ".jpg")
