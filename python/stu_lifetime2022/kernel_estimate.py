from dataclasses import dataclass
from typing import Callable

import numpy as np


def kb_plus(mu: int, q: float, x: float) -> float:
    # assert -1 <= q <= 1, f"`q` should be in [-1; 1], but {q} is passed" # TODO return assert?

    if mu == 0:
        return (2 / (1 + q) ** 3) * (3 * (1 - q) * x + 2 * (1 - q + q ** 2))
    if mu == 1:
        return (12 / (1 + q) ** 4) * (x + 1) * (x * (1 - 2 * q) + (3 * q ** 2 - 2 * q + 1) / 2)
    if mu == 2:
        return (15 / (1 + q) ** 5) * (x + 1) ** 2 * (q - x) * (
                2 * x * (5 * (1 - q) / (1 + q) - 1) + 3 * q - 1 + 5 * (1 - q) ** 2 / (1 + q))
    if mu == 3:
        return 70 / (1 + q) ** 7 * (x + 1) ** 3 * (q - x) ** 2 * (
                2 * x * (7 * (1 - q) / (1 + q) - 1) + 3 * q - 1 + 7 * (1 - q) ** 2 / (1 + q))

    raise ValueError(f"Wrong Mu value: {mu}")


def kb_minus(mu: int, q: float, x: float) -> float:
    return kb_plus(mu, q, -x)


def kx_factory(mu: int, x: float,
               bandwidth: Callable[[float], float], r: float) -> Callable[[float], float]:
    """
    Enhanced kernel K_x(z) (equation 2.3 in the article)
    """
    if bandwidth(x) <= x <= r - bandwidth(x):
        return lambda z: kb_plus(mu=mu, q=x / bandwidth(x), x=z)
    if x < bandwidth(x):
        return lambda z: kb_minus(mu=mu, q=x / bandwidth(x), x=z)
    return lambda z: kb_minus(mu=mu, q=(r - x) / bandwidth(x), x=z)


@dataclass
class AlgParams:
    mu: int  # kernel parameter (possible values: 0, 1, 2, 3)
    m1: int  # number of points in bandwidth minimization grid
    m2: int  # number of points in final hazard rate estimation grid


@dataclass
class InputData:
    x: np.array  # one-dimensional time data
    ind: np.array  # 1 = not censored, 0 = censored (delta_i in equation 2.1)

    @property
    def n(self):
        return len(self.x)


def estimate_h(params: AlgParams, data: InputData,
               bandwidth: Callable[[float], float], r: float) -> Callable[[float], float]:
    """
    Given bandwidth estimation, right boundary and data, constructs kernels and provides h(t) (equation 2.2)
    """

    def h(x: float) -> float:
        sum_kx: float = 0
        kx = kx_factory(params.mu, x=x, bandwidth=bandwidth, r=r)
        for i, (xi, ind_i) in enumerate(zip(data.x, data.ind)):
            sum_kx += kx((x - xi) / bandwidth(x)) * ind_i / (data.n - i + 1)
        return sum_kx / bandwidth(x)

    return h


def h_estimate(params: AlgParams, data: InputData) -> Callable[[float], float]:
    """
    hazard rate estimate with varying kernel and bandwidth
    """
    r = np.max(data.x)  # right bound
    n_uncensored = np.sum(data.ind)
    b0 = lambda x: r / (8 * n_uncensored ** (1 / 5))  # recommended initial bandwidth
    h0 = estimate_h(params, data, b0, r)
    return h0  # TODO return better estimate
    # b1 = 2 * b0(0) / 3  # b1, b2 - boundaries for optimal bandwidth search
    # b2 = 4 * b0(0)


def main():
    print(kb_plus(0, 0, 0.5))
    try:
        kb_plus(4, 0, 0.5)
    except Exception as e:
        print(e)


if __name__ == "__main__":
    main()
