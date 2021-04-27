import numpy as np
import matplotlib.pyplot as plt
from scipy import stats


def first():
    x = np.array([[2, .5]]).T
    s = np.array([[2, 0], [0, 2]])
    s_inv = np.linalg.inv(s)
    m = np.array([[1, 2], [1, 1], [2, 1]])
    for i in range(len(m)):
        mi = m[i]
        ai = np.array([s_inv @ mi])
        print(ai)
        gamma_i = - .5 * mi.T @ s_inv @ mi
        # print(gamma_i)
        # print(i + 1)
        print(ai @ x + gamma_i)


def second():
    import numpy as np

    V = np.array([[-(1 + np.sqrt(2)), 1], [-(1 - np.sqrt(2)), 1]])
    origin = np.array([[0, 0], [0, 0]])  # origin point

    plt.quiver(*origin, V[:, 0], V[:, 1], color=['r', 'b'], scale=7)
    plt.axis("equal")
    plt.xticks(())
    plt.yticks(())
    plt.xlabel("$x_1$")
    plt.ylabel("$x_2$")
    plt.title("red: $l^{(1)}$, blue: $l^{(2)}$")
    plt.show()


def fourth():
    m1 = np.array([[1.1, 3.3]]).T
    m2 = np.array([[.8, 3.45]]).T
    s = np.array([[2, 0], [0, 2]]).T
    n1, n2 = 150, 170
    p = len(s)
    T2 = n1 * n2 / (n1 + n2) * (m1 - m2).T @ np.linalg.inv(s) @ (m1 - m2)
    t = (n1 + n2 - p - 1) / ((n1 + n2 - 2) * p) * T2
    print(T2)
    print(t)

    alpha = .05
    quantile = stats.f(p, n1 + n2 - p - 1).ppf(1 - alpha)
    print(quantile)


def main():
    # first()
    # second()
    fourth()


if __name__ == "__main__":
    main()
