import numpy as np


# https://ajcr.net/Basic-guide-to-einsum/

def main():
    a = np.array([[1, 2, 3], [4, 5, 6]])
    b = np.array([[5, 6], [7, 8], [9, 10]])
    assert (np.einsum("ij,ji->", a, b) == np.sum(a * b.T)).all()


if __name__ == "__main__":
    main()
