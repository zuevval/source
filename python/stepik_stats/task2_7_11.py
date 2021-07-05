from scipy.special import erfinv
import numpy as np

from python.stepik_stats.task2_7_8 import laplace_probab


def l0_inv(x: float) -> float:  # inverse Phi_0(x)
    return np.sqrt(2) * erfinv(2 * x)


def main():
    n, p = 1200, .75
    q = 1 - p
    delta = np.ceil(l0_inv(.25) * np.sqrt(n * p * q))
    A, B = n * p - delta, n * p + delta
    print(A)
    print(B)
    print(laplace_probab(A, B-1, n, p))


if __name__ == "__main__":
    main()
