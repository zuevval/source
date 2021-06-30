from fractions import Fraction
from sympy import ntheory


def main():
    p10, p9, p8, p7 = map(Fraction, ["3/10", "4/10", "2/10", "5/100"])
    mcoef = ntheory.multinomial_coefficients(5, 5)
    p = p10 ** 2 * (mcoef[(4, 0, 0, 1, 0)] * p10 ** 2 * p7 +
                    mcoef[(3, 1, 1, 0, 0)] * p10 * p9 * p8 +
                    mcoef[(2, 3, 0, 0, 0)] * p9 ** 3)
    print(float(p))


if __name__ == "__main__":
    main()
