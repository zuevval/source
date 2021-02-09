from typing import Tuple, Union

import matplotlib.pyplot as plt
import numpy as np  # type: ignore
from scipy.optimize import minimize, OptimizeResult, Bounds
from scipy.stats import chi2


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


def plot_hist(x: np.array) -> None:
    counts, bins = np.histogram(x)
    plt.hist(bins[:-1], bins, weights=counts)
    plt.title("histogram")
    plt.show()


def exp_cdf(lamb: float, x: Union[float, np.array]) -> Union[float, np.array]:  # assuming x >= 0
    return 1 - np.exp(- lamb * x)


def exp_pdf(lamb: float, x: Union[float, np.array]) -> Union[float, np.array]:  # assuming x >= 0
    return lamb * np.exp(- lamb * x)


# def chi_sq()


def fisher_exp_test(x: np.array, nu: float = 6) -> float:
    x = np.sort(x)
    n = len(x)
    nu_last = n % nu or nu
    bins = [(0, x[nu]),
            *[(x[nu * (i - 1)], x[nu * i]) for i in range(2, (n - nu_last) // nu + 1)],
            (x[n - nu_last], np.inf)]  # assuming n > nu

    def loss(lamb: float) -> float:
        probabs = np.array([exp_cdf(lamb, r) - exp_cdf(lamb, l) for l, r in bins])
        nu_arr = np.array([nu] * (len(bins) - 1) + [nu_last])
        return np.sum((nu_arr - n * probabs) ** 2 / (n * probabs))

    lambda_init = 1 / mean(x)
    lambda_bounds = Bounds(0, np.inf)
    res: OptimizeResult = minimize(fun=loss, x0=lambda_init, options={"verbose": 1}, method='trust-constr',
                                   bounds=lambda_bounds)
    print("lambda found by minimizing the loss function: " + str(res.x))

    # when n -> inf, res.x ~ chi_square(n/nu - 2)
    print("p-value:" + str(1 - chi2.cdf(x=0.98, df=(n // nu - 2))))
    return res.x


def plot_pdf_cdf(x: np.array) -> None:
    lamb = 1 / mean(x)
    t = np.arange(start=0, stop=5, step=.02)

    y_cdf = exp_cdf(lamb=lamb, x=t)
    plt.plot(t, y_cdf, label="theoretical CDF, lambda=%.1g" % lamb)
    plt.step(*cdf(x), label="empirical CDF")
    plt.legend()
    plt.show()

    y_pdf = exp_pdf(lamb=lamb, x=t)
    plt.plot(t, y_pdf, label="theoretical PDF, lambda=%.1g" % lamb)
    counts, bins = np.histogram(x)
    plt.hist(bins[:-1], bins, weights=counts * np.max(y_pdf) / np.max(counts), label="histogram")
    plt.legend()
    plt.show()
