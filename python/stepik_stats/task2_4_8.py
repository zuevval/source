from fractions import Fraction
from python.stepik_stats.task2_3_10 import RandomVar


def main():
    n = 6
    xi_k = RandomVar(states=list(range(1, n + 1)),
                     probabs=[Fraction(1, n) for _ in range(n)],
                     name="xi_k")
    var_eta = xi_k.var() / 500  # eta := 1/500 sum({xi_k})
    print(float(1 - var_eta * 25))


if __name__ == "__main__":
    main()
