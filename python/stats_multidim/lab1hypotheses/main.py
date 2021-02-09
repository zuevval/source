import numpy as np

from python.stats_multidim.lab1hypotheses.data import load_data
from python.stats_multidim.lab1hypotheses.math_utils \
    import mean, var, asym, kurtosis, cdf, plot_cdf, plot_hist, fisher_exp_test, plot_pdf_cdf


def print_var(variable: float, name: str, precision: int = 3) -> None:
    print(name + ": " + ("%." + str(precision) + "g") % variable)


def part1_moments(x: np.array) -> None:
    print_var(mean(x), "mean")
    print_var(var(x), "variance")
    print_var(asym(x), "asymmetry")
    print_var(kurtosis(x), "kurtosis")


def part2_cdf(x: np.array) -> None:
    plot_cdf(*cdf(x))
    plot_cdf(*cdf(np.log(x)))
    plot_hist(x)
    plot_hist(np.log(x))


def part4_fisher(x: np.array) -> None:
    fisher_exp_test(x)


def part6_theoretical_dist(x: np.array) -> None:
    plot_pdf_cdf(x)


def main():
    x = load_data()
    part1_moments(x)
    # part2_cdf(x)
    part4_fisher(x)
    # part6_theoretical_dist(x)


if __name__ == "__main__":
    main()
