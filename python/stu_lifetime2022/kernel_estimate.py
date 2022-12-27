from dataclasses import dataclass
from typing import Callable, Union
from scipy.integrate import quad, trapezoid

import numpy as np


def kb_plus(mu: int, q: float, x: float) -> float:
    assert 0 <= q <= 1, f"`q` should be in [0; 1], but {q} is passed"  # TODO return assert?
    if x < -1 or x > q:
        return 0

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
        return lambda z: kb_plus(mu=mu, q=1, x=z)
    if x < bandwidth(x):
        return lambda z: kb_plus(mu=mu, q=x / bandwidth(x), x=z)
    return lambda z: kb_minus(mu=mu, q=(r - x) / bandwidth(x), x=z)


@dataclass
class AlgParams:
    mu: int  # kernel parameter (possible values: 0, 1, 2, 3)
    m1: int  # number of points between 0 and R in bandwidth minimization grid
    l: int  # number of points between b1 and b2 in bandwidth minimization grid
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


def ln_factory(data: InputData) -> Callable[[float], float]:
    """
    empirical survival function of uncensored observations L_n(x)
    """
    x_not_censored = data.x[np.where(data.ind == 1)]

    def ln(x: float) -> float:
        count = sum(x_not_censored <= x)
        return 1 - count / (data.n + 1)

    return ln


def mse_estimate(x: float, bx: float, params: AlgParams, data: InputData,
                 h0: Callable[[float], float], r: float, ret_dict: False) -> Union[float, dict]:
    b = lambda _: bx  # bandwidth
    kx = kx_factory(mu=params.mu, x=x, bandwidth=b, r=r)
    ln = ln_factory(data)
    integr_x = np.arange(0, 1, .2)
    integr_vx = [(kx(y) ** 2 * h0(abs(x - bx * y)) / (1 - ln(x - bx * y))) for y in integr_x]  # TODO remove abs, [-1;1]
    vx = 1 / (data.n * bx) * trapezoid(integr_vx, integr_x)

    beta_x = trapezoid([h0(abs(x - bx * y)) * kx(y) for y in integr_x], integr_x) - h0(x)  # TODO remove abs
    mse_est = vx + beta_x ** 2
    if ret_dict:
        return {"mse_est": mse_est, "vx": vx, "beta_x": beta_x}
    return mse_est


def update_b(params: AlgParams, data: InputData, h0: Callable[[float], float],
             b1: float, b2: float, r: float, ret_dict: bool = False) -> Union[Callable[[float], float], dict]:
    mse_mtx = np.zeros((params.m1, params.l))
    vx_mtx, betax_mtx = mse_mtx.copy(), mse_mtx.copy()
    grid_x = np.linspace(0, r, params.m1)
    grid_b = np.linspace(b1, b2, params.l)

    for i_x in range(params.m1):
        for i_b in range(params.l):
            mse_res = mse_estimate(x=grid_x[i_x], bx=grid_b[i_b], params=params,
                                   data=data, h0=h0, r=r, ret_dict=ret_dict)
            mse_mtx[i_x, i_b] = mse_res["mse_est"] if ret_dict else mse_res
            if ret_dict:
                vx_mtx[i_x, i_b] = mse_res["vx"]
                betax_mtx[i_x, i_b] = mse_res["beta_x"]

    opt_b_indices = np.argmin(mse_mtx, axis=1)
    opt_b = [grid_b[i_b] for i_b in opt_b_indices]
    delta_x = grid_x[1]

    def b(x: float) -> float:
        assert 0 <= x <= r, f"x should be in [0;r], r={r}; but given x={x}"
        idx_x = int(x / delta_x)
        return opt_b[idx_x]

    if ret_dict:
        opt_vx = [vxi[i_b] for vxi, i_b in zip(vx_mtx, opt_b_indices)]
        opt_beta = [beta_i[i_b] for beta_i, i_b in zip(betax_mtx, opt_b_indices)]
        return {"b": b, "x": grid_x, "vx": opt_vx, "beta": opt_beta}

    return b


def h_estimate(params: AlgParams, data: InputData, coarse_est: bool = False,
               ret_dict: bool = False) -> Union[Callable[[float], float], dict]:
    """
    hazard rate estimate with varying kernel and bandwidth
    """
    r = np.max(data.x)  # right bound
    n_uncensored = np.sum(data.ind)
    b0 = lambda x: r / (8 * n_uncensored ** (1 / 5))  # recommended initial bandwidth
    h0 = estimate_h(params, data, b0, r)
    if coarse_est:
        return h0
    b1 = 2 * b0(0) / 3  # b1, b2 - boundaries for optimal bandwidth search
    b2 = 4 * b0(0)
    b_result = update_b(params, data, h0=h0, b1=b1, b2=b2, r=r, ret_dict=ret_dict)
    b = b_result if not ret_dict else b_result["b"]
    # TODO calculate even finer b
    h_est = estimate_h(params, data, b, r)
    if ret_dict:
        return {
            "h_est": h_est,
            "h_coarse": h0,
            **b_result
        }
    return h_est


def main():
    print(kb_plus(0, 0, 0.5))
    try:
        kb_plus(4, 0, 0.5)
    except Exception as e:
        print(e)


if __name__ == "__main__":
    main()
