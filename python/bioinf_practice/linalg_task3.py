import numpy as np


def main():
    a = np.array([[1, 2],
                  [3, 4]])
    b = np.array([[5, 6],
                  [7, 8]])
    print(a @ b)
    print(a @ b.T)
    print(np.linalg.eigh(np.array([[1, 0], [0, 1]])))


if __name__ == "__main__":
    main()
