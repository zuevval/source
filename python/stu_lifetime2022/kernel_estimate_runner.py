from enum import Enum
from typing import Tuple, Callable

from kernel_estimate import AlgParams, InputData, h_estimate, kb_plus

import numpy as np
import matplotlib.pyplot as plt


class DistType(Enum):
    weibull = "weibull"
    exp = "exponential"


def gen_data(type: DistType, n: int = 50, seed: int = 0) -> Tuple[InputData, Callable[[float], float]]:
    np.random.seed(seed)

    if type == DistType.weibull:
        uncensored = np.random.weibull(a=.5)
    else:
        uncensored = np.random.standard_exponential(n)

    censor_times = np.random.uniform(0, 7, size=n)
    x = np.where(uncensored < censor_times, uncensored, censor_times)
    data = InputData(x=x, ind=(uncensored < censor_times))

    if type == DistType.weibull:
        h = lambda t: .5 * t ** -.5
    else:
        h = lambda _: 1

    return data, h


def estimate_plot(data: InputData, params: AlgParams,
                  h_ref: Callable[[float], float], title: str) -> None:
    h_est = h_estimate(params, data, ret_dict=True)

    plt.figure()
    plt.title(title)
    plt.hist(data.x, density=True)

    sample_x = np.linspace(0, max(data.x) * .95, 50)
    sample_y = [h_est["h_est"](xi) for xi in sample_x]
    y_coarse = [h_est["h_coarse"](xi) for xi in sample_x]
    y_ref = [h_ref(xi) for xi in sample_x]
    plt.plot(sample_x, sample_y)
    plt.plot(sample_x, y_coarse)
    plt.plot(sample_x, y_ref, "--")
    plt.legend(["fine", "coarse", "ground truth"])
    plt.savefig(f"img/est_{title}.jpg")

    sample_b = [h_est["b"](xi) for xi in sample_x]
    plt.figure()
    plt.title(f"bandwidth b(x): {title}")
    plt.plot(sample_x, sample_b)
    plt.savefig(f"img/b_{title}.jpg")

    plt.figure()
    plt.title(f"variance: {title}")
    plt.plot(h_est["x"], h_est["vx"])
    plt.savefig(f"img/v_{title}.jpg")

    plt.figure()
    plt.title(f"bias: {title}")
    plt.plot(h_est["x"], h_est["beta"])
    plt.savefig(f"img/beta_{title}.jpg")


def plot_kbplus() -> None:
    x = np.linspace(-1, 1, 30)
    for mu in range(4):
        qs = [.5, .75, 1]
        plt.figure()
        plt.title(f"kernel (mu={mu})")
        plt.plot()
        for q in qs:
            y = [kb_plus(mu, q, xi) for xi in x]
            plt.plot(x, y)
        plt.legend([f"q={q}" for q in qs])
        plt.savefig(f"img/kernel_mu{mu}")



def main():
    for d_type in DistType:
        data, h_ref = gen_data(type=d_type)
        for mu in range(4):
            params = AlgParams(mu=mu, m1=11, l=10, m2=101)  # TODO b0=.2
            estimate_plot(data, params, h_ref, f"{d_type.value} (mu={mu})")


if __name__ == "__main__":
    plot_kbplus()
    # main()
