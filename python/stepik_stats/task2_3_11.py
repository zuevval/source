from fractions import Fraction
from itertools import product
from python.stepik_stats.task2_3_10 import RandomVar


def main():
    n = 4
    states = list(range(1, n + 1))
    eta_probabs = list(map(Fraction, "1/16 7/48 13/48 25/48".split()))
    assert sum(eta_probabs) == 1, "smth wrong with `eta_probabs`"

    eta = RandomVar(states=states,
                    probabs=eta_probabs,
                    name="eta")
    eta.pprint()

    xi = RandomVar(states=states,
                   probabs=[Fraction(1, n) for _ in range(n)],
                   name="xi")
    mutual_probabs = {(x_xi, x_eta): Fraction(1, n * (n + 1 - x_xi)) for x_xi, x_eta in product(states, states) if
                      x_eta >= x_xi}
    assert sum(mutual_probabs.values()) == 1, "something wrong with `mutual_probabs`"
    print(xi.cov(eta, mutual_probabs))


if __name__ == "__main__":
    main()
