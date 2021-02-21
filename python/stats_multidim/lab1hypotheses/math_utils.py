from typing import Tuple, Union, Callable

import matplotlib.pyplot as plt
import numpy as np  # type: ignore
from scipy.optimize import minimize, OptimizeResult
from scipy.stats import chi2
from scipy.special import gamma


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


def exp_cdf(x: Union[float, np.array], lamb: float) -> Union[float, np.array]:  # assuming x >= 0
    return 1 - np.exp(- lamb * x)


def exp_pdf(lamb: float, x: Union[float, np.array]) -> Union[float, np.array]:  # assuming x >= 0
    return lamb * np.exp(- lamb * x)


def fisher_test(x: np.array, n_bins: int = 6) -> float:
    """
    Fisher's test for exponential distribution
    """
    nu, bins = np.histogram(x, bins=n_bins)  # `bins`: intervals, `nu`: number of points in each bin
    bins = list(zip(bins[:-1], bins[1:]))  # `bins`: [b1, b2, b3, ...] -> [(b1, b2), (b2, b3), ...]
    n = len(x)

    def loss(param: float, theor_cdf: Callable[[float, float], float]) -> float:
        # minimized function: X_n^2 = sum((nu_j - n p_j^0)^2/(n p_j^0))
        probabs = np.array([theor_cdf(r, param) - theor_cdf(l, param) for l, r in bins]).T  # array of p_j^0
        return np.sum((nu - n * probabs) ** 2 / (n * probabs))

    lambda_init = 1 / mean(x)  # start with maximum likelihood lambda
    df_init = 1 / mean(x)  # chi2 distribution: start with maximum likelihood degrees-of-freedom

    for theor_cdf, param, label in ((exp_cdf, lambda_init, "exponential"), (chi2.cdf, df_init, "chi squared")):
        print("\n" + label + " distribution:")
        res: OptimizeResult = minimize(loss, param, args=(theor_cdf,))
        print("parameter found by minimizing the loss function: " + str(res.x))

        # when n -> inf, res.x ~ chi_square(N - r - 1), r = 1 - number of parameters (1 parameter: lambda)
        print("value found by minimizing the loss function:" + str(res.fun))
        degrees_of_freedom = n_bins - 2
        for gamma_value in [.9, .95]:
            print("critical value for gamma={}: {}".format(gamma_value, chi2.ppf(gamma_value, df=degrees_of_freedom)))
        print("p-value:" + str(1 - chi2.cdf(x=res.fun, df=degrees_of_freedom)))


def plot_pdf_cdf(x: np.array, n_bins=6) -> None:
    lamb = 1 / mean(x)
    deg_of_freedom = 1 / mean(x)
    t = np.arange(start=0, stop=5, step=.02)

    for y_pdf, y_cdf, label in (
            (exp_pdf(lamb=lamb, x=t), exp_cdf(x=t, lamb=lamb), "exponential (lambda=%.2g)" % lamb),
            (chi2.pdf(x=t, df=deg_of_freedom), chi2.cdf(x=t, df=deg_of_freedom),
             "chi square (DoF=%.2g)" % deg_of_freedom)):
        plt.figure()
        plt.plot(t, y_cdf, label="theoretical CDF: " + label)
        sq_n = np.sqrt(len(x))  # sqrt(n)

        x_sorted, y_ecdf = cdf(x)
        plt.step(x_sorted, y_ecdf, label="empirical CDF")

        delta_y_01, delta_y_005 = 1.224 / sq_n, 1.385 / sq_n  # delta (alpha = 0.1, alpha = 0.05)
        label_template = "confidence interval for CDF (gamma = {})"
        for delta_y, color, label_conf in ((delta_y_01, "green", label_template.format(0.9)),
                                           (delta_y_005, "black", label_template.format(0.95))):
            plt.step(x_sorted, y_ecdf + delta_y, color=color, label=label_conf, linewidth=1)
            plt.step(x_sorted, y_ecdf - delta_y, color=color, linewidth=1)
        plt.legend()
        plt.savefig("data/cdf " + label + ".png")

        plt.figure()
        plt.plot(t, y_pdf, label="theoretical PDF, lambda=%.2g" % lamb)
        counts, bins = np.histogram(x, bins=n_bins)
        plt.hist(bins[:-1], bins, weights=counts * np.max(y_pdf[y_pdf != np.inf]) / np.max(counts),
                 label="histogram (normalized)")
        plt.legend()
        plt.savefig("data/pdf " + label + ".png")
