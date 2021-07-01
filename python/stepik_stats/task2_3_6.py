import numpy as np


def main():
    a, b = np.array([[1, 1, 1],
                     [1, 2, 3],
                     [1.21, .001, .81]]), \
           np.array([1, 2.1, .89])
    print(np.round(np.linalg.solve(a, b), 1))


if __name__ == "__main__":
    main()
