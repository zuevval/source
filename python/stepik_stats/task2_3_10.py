from dataclasses import dataclass
from fractions import Fraction
from itertools import product
from numbers import Rational
from typing import Dict, Sequence, Tuple


@dataclass
class RandomVar:
    """
    any discrete random variable with a finite number of states
    """
    states: Sequence[float]
    probabs: Sequence[Rational]
    name: str

    def mean(self) -> Rational:
        return sum(s * p for s, p in zip(self.states, self.probabs))

    def var(self) -> Rational:
        squared = RandomVar([s ** 2 for s in self.states], self.probabs, "squared")
        return squared.mean() - self.mean() ** 2

    def cov(self, other: "RandomVar", mutual_probabs: Dict[Tuple[int, int], Rational]) -> Rational:
        prod = RandomVar([a * b for a, b in mutual_probabs.keys()], list(mutual_probabs.values()), "prod")
        return prod.mean() - self.mean() * other.mean()

    def pprint(self):
        print("--- {} ---".format(self.name))
        print("mean: {}".format(self.mean()))
        print("variance: {}".format(self.var()))


def main():
    n = 6
    states = list(range(1, n + 1))
    xi = RandomVar(states, list(map(lambda pair: Fraction(*pair), [(1, n)] * n)), "xi")
    xi.pprint()

    eta = RandomVar(states, list(map(Fraction, "1/36 3/36 5/36 7/36 9/36 11/36".split())), "eta")
    eta.pprint()

    def n_mutual_occurences(x_xi, x_eta):
        if x_xi < x_eta:
            return 1
        elif x_xi == x_eta:
            return x_xi
        return 0

    mutual_occurences = {(x_xi, x_eta): n_mutual_occurences(x_xi, x_eta) for x_xi, x_eta in product(states, states)}
    mutual_probabs = {k: Fraction(v, n ** 2) for k, v in mutual_occurences.items()}
    print(xi.cov(eta, mutual_probabs))


if __name__ == "__main__":
    main()
