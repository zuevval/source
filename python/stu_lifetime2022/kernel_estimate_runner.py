from enum import Enum
from typing import Tuple, Callable

from kernel_estimate import AlgParams, InputData, h_estimate

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
    h_est = h_estimate(params, data)
    h_coarse = h_estimate(params, data, coarse_est=True)

    plt.figure()
    plt.title(title)
    plt.hist(data.x, density=True)

    sample_x = np.linspace(0, max(data.x) * .95, 50)
    sample_y = [h_est(xi) for xi in sample_x]
    y_coarse = [h_coarse(xi) for xi in sample_x]
    y_ref = [h_ref(xi) for xi in sample_x]
    plt.plot(sample_x, sample_y)
    plt.plot(sample_x, y_coarse)
    plt.plot(sample_x, y_ref, "--")
    plt.legend(["fine", "coarse", "ground truth"])
    plt.savefig(f"img/est_{title}.jpg")


def main():
    for d_type in DistType:
        data, h_ref = gen_data(type=d_type)
        params = AlgParams(mu=1, m1=11, l=10, m2=101)  # TODO b0=.2
        estimate_plot(data, params, h_ref, d_type.value)


if __name__ == "__main__":
    main()
