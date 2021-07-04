from math import sqrt
from python.stats_multidim.lab2pca.classifier import laplace_function


def main():
    n, p = 600, .6
    lo, hi = 345, 375
    q = 1 - p
    p_cheb = 1 - n * p * q / (hi - n * p) ** 2  # P(|xi - E xi| <= t) = 1 - P( ... >= t) >= 1 - D xi / t^2
    print("chebyshev: {:.3f}".format(p_cheb))

    lo_laplace, hi_laplace = map(lambda x: laplace_function((x - n * p) / sqrt(n * p * q)), (lo, hi))
    p_laplace = hi_laplace - lo_laplace
    print("laplace: {:.3f}".format(p_laplace))


if __name__ == "__main__":
    main()
