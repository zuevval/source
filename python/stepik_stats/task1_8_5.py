from math import comb
from sympy import symbols


def main():
    p_clear = symbols("1/3")  # probability of night to be clear
    p_dark = 1 - p_clear  # probability of night to be dark
    p_fail = sum(comb(7, k) * p_clear ** k * p_dark ** (7 - k) for k in range(3))
    print(1 - p_fail)


if __name__ == "__main__":
    main()  # well, it doesn't give much info, just to check
    print("num: {}".format(3 ** 7))
    print("den: {}".format(3 ** 7 - 2 ** 5 * 39))
