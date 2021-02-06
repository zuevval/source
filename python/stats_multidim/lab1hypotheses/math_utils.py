from typing import Tuple

import matplotlib.pyplot as plt
import numpy as np  # type: ignore


def mean(x: np.array) -> float:
    return np.sum(x) / np.prod(x.shape)  # mean of empty array is undefined


def var(x: np.array) -> float:
    return mean(x ** 2) - mean(x) ** 2


def asym(x: np.array) -> float:
    return mean((x - mean(x)) ** 3)


def kurtosis(x: np.array) -> float:
    return mean((x - mean(x)) ** 4)


def cdf_repeated(x: np.array) -> Tuple[np.array, np.array]:
    """
    Calculates the empirical cumulative distribution function
    for SMALL random vectors with possibly repeated values
    :param x: a sample vector
    :return: sorted sample vector and corresponding CDF values
    """
    precision = 4  # retained digits after floating point
    x_int = (x * 10 ** precision).astype(int)
    unique, counts = np.unique(x_int, return_counts=True)
    cdf_values = np.zeros(counts.shape)
    cdf_values[0] = counts[0]  # assuming there is at least 1 element
    for i in range(1, len(counts)):
        cdf_values[i] = cdf_values[i - 1] + counts[i]
    return unique / 10 ** precision, cdf_values / len(x)


def cdf(x: np.array) -> Tuple[np.array, np.array]:
    """
    Calculates the empirical CDF
    :param x: random vector
    :return: sorted vector & corresponding CDF values
    """
    x_sorted = np.sort(x)
    n = len(x_sorted)
    return x_sorted, np.arange(n) / n


def plot_cdf(x: np.array, cdf_values: np.array) -> None:
    assert len(x) == len(cdf_values), "input dimensions mismatch"
    plt.step(x, cdf_values, label="cumulative distribution function")
    plt.legend()
    plt.show()


def plot_log_hist(x: np.array) -> None:
    counts, bins = np.histogram(np.log(x))
    plt.hist(bins[:-1], bins, weights=counts)
    plt.title("histogram (logarithm of data)")
    plt.show()
