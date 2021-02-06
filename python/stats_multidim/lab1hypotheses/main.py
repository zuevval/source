import numpy as np

from python.stats_multidim.lab1hypotheses.math_utils \
    import mean, var, asym, kurtosis, cdf, plot_cdf, plot_log_hist


def part1_moments(x: np.array) -> None:
    print("mean: " + str(mean(x)))
    print("variance: " + str(var(x)))
    print("asymmetry: " + str(asym(x)))
    print("kurtosis: " + str(kurtosis(x)))


def part2_cdf(x: np.array) -> None:
    plot_cdf(*cdf(x))
    plot_log_hist(x)


def main():
    x = np.fromfile("./data/data4.txt")
    part1_moments(x)
    part2_cdf(x)


if __name__ == "__main__":
    main()
