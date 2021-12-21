from typing import List

from scipy.optimize import minimize
from scipy.stats import kstest, kstwo, norm
import numpy as np
import matplotlib.pyplot as plt


def kolm_smirn(x: List[float]) -> None:
    a0 = -7
    sigma = 2
    z = [(xi - a0) / sigma for xi in x]
    print(kstest(z, "norm"))

    plt.figure()
    plt.hist(z)
    plt.show()

    a2 = .01
    print("1-alpha2 Kolmogorov dist-n quantile", kstwo.ppf(n=len(x), q=1 - a2))


def chisq_complex(x: List[float]) -> None:
    mu_start, sigma_start = np.mean(x), np.var(x)
    breaks = [-float("inf"), -3.5, -2, 0, 1.5, float("inf")]
    nu, _ = np.histogram(x, bins=breaks)

    def log_likelihood(params: np.array) -> float:
        mu, sigma = params
        cdf_values = np.array([norm.cdf(q, loc=mu, scale=sigma) for q in breaks])
        cdf_deltas = np.array([hi - lo for lo, hi in zip(cdf_values[:-1], cdf_values[1:])])
        return -float(np.sum(nu * np.log(cdf_deltas)))

    params_start = np.array([mu_start, sigma_start])
    print("starting point:", params_start)
    print("starting point log-likelihood:", log_likelihood(params=params_start))

    print("minimization result:", minimize(log_likelihood, params_start))


def main():
    x = [-4.503, -2.342, 0.437, 0.473, 1.531,
         -1.864, -2.283, -1.011, -2.743, -3.224,
         -3.284, 0.561, -0.626, -1.95, -0.825,
         2.213, -2.503, -2.371, 0.278, 0.361,
         0.653, -1.057, -1.404, -1.059, 1.673,
         -0.429, -2.543, 0.758, -1.195, -3.485,
         -0.863, -1.398, -4.31, 3.068, -3.704,
         -2.858, -4.464, -3.021, -1.593, 2.71,
         -3.191, 2.498, -0.024, 1.903, 1.244,
         -0.048, 1.354, -3.339, 1.33, -3.136
         ]
    kolm_smirn(x=x)
    chisq_complex(x=x)


if __name__ == "__main__":
    main()
