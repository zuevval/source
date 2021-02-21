from typing import Tuple, Union

import matplotlib.pyplot as plt
import numpy as np  # type: ignore
from scipy.optimize import minimize, OptimizeResult
from scipy.stats import chi2


def mean(x: np.array) -> float:
    return np.sum(x) / np.prod(x.shape)  # mean of empty array is undefined


def var(x: np.array) -> float:
    return mean(x ** 2) - mean(x) ** 2


def asym(x: np.array) -> float:
    return mean((x - mean(x)) ** 3) / var(x) ** (3 / 2)


def kurtosis(x: np.array) -> float:
    return mean((x - mean(x)) ** 4) / var(x) ** 2


def cdf(x: np.array) -> Tuple[np.array, np.array]:
    """
    Calculates the empirical CDF
    :param x: random vector
    :return: sorted vector & corresponding CDF values
    """
    x_sorted = np.sort(x)
    n = len(x_sorted)
    return x_sorted, np.arange(1, n + 1) / n


def exp_cdf(lamb: float, x: Union[float, np.array]) -> Union[float, np.array]:  # assuming x >= 0
    return 1 - np.exp(- lamb * x)


def exp_pdf(lamb: float, x: Union[float, np.array]) -> Union[float, np.array]:  # assuming x >= 0
    return lamb * np.exp(- lamb * x)


def fisher_exp_test(x: np.array, n_bins: int = 6) -> float:
    """
    Fisher's test for exponential distribution
    """
    nu, bins = np.histogram(x, bins=n_bins)  # `bins`: intervals, `nu`: number of points in each bin
    bins = list(zip(bins[:-1], bins[1:]))  # `bins`: [b1, b2, b3, ...] -> [(b1, b2), (b2, b3), ...]
    n = len(x)

    def loss(lamb: float) -> float:  # minimized function: X_n^2 = sum((nu_j - n p_j^0)^2/(n p_j^0))
        probabs = np.array([exp_cdf(lamb, r) - exp_cdf(lamb, l) for l, r in bins]).T  # array of p_j^0
        return np.sum((nu - n * probabs) ** 2 / (n * probabs))

    lambda_init = 1 / mean(x)  # start with maximum likelihood lambda
    res: OptimizeResult = minimize(loss, lambda_init)
    print("lambda found by minimizing the loss function: " + str(res.x))

    # when n -> inf, res.x ~ chi_square(N - r - 1), r = 1 - number of parameters (1 parameter: lambda)
    print("p-value:" + str(1 - chi2.cdf(x=res.fun, df=(n_bins - 2))))
    return res.x


def plot_pdf_cdf(x: np.array) -> None:
    lamb = 1 / mean(x)
    t = np.arange(start=0, stop=5, step=.02)

    y_cdf = exp_cdf(lamb=lamb, x=t)
    plt.plot(t, y_cdf, label="theoretical CDF, lambda=%.1g" % lamb)
    sq_n = np.sqrt(len(x))  # sqrt(n)

    x_sorted, y_ecdf = cdf(x)
    plt.step(x_sorted, y_ecdf, label="empirical CDF")

    delta_y_01, delta_y_005 = 1.224 / sq_n, 1.385 / sq_n  # delta (alpha = 0.1, alpha = 0.05)
    label_template = "confidence interval for CDF (gamma = {})"
    for delta_y, color, label in ((delta_y_01, "green", label_template.format(0.9)),
                                  (delta_y_005, "black", label_template.format(0.95))):
        plt.step(x_sorted, y_ecdf + delta_y, color=color, label=label, linewidth=1)
        plt.step(x_sorted, y_ecdf - delta_y, color=color, linewidth=1)
    plt.legend()
    plt.show()

    y_pdf = exp_pdf(lamb=lamb, x=t)
    plt.plot(t, y_pdf, label="theoretical PDF, lambda=%.2g" % lamb)
    counts, bins = np.histogram(x, bins=6)
    plt.hist(bins[:-1], bins, weights=counts * np.max(y_pdf) / np.max(counts), label="histogram (normalized)")
    plt.legend()
    plt.show()
