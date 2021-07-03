from math import exp, sqrt, pi


def main():
    n, k, p = 1000, 500, .51
    q = 1 - p
    x = (k - n * p) / sqrt(n * p * q)
    print(round(exp(-x ** 2 / 2) / sqrt(2 * pi * n * p * q), 4))


if __name__ == "__main__":
    main()
