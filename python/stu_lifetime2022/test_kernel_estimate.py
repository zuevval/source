from typing import Tuple

from kernel_estimate import kx_factory, ln_factory, AlgParams, InputData, h_estimate

import numpy as np
import matplotlib.pyplot as plt


def generate_input() -> Tuple[InputData, AlgParams]:
    data_len = 100
    np.random.seed(0)
    data = InputData(
        x=np.random.standard_exponential(data_len),
        ind=np.ones(data_len)  # all not censored
    )
    params = AlgParams(mu=1, m1=5, l=4, m2=3)
    return data, params


def test_kx_factory():
    kx = kx_factory(mu=1, x=.5, bandwidth=lambda _: 1, r=10)
    print(kx(5))


def test_ln_factory():
    data, params = generate_input()
    ln = ln_factory(data)

    ln_x = np.linspace(0, 4)
    ln_y = [ln(xi) for xi in ln_x]

    plt.figure()
    plt.hist(data.x, density=True)
    plt.plot(ln_x, ln_y)
    plt.show()


def test_h_estimate():
    data, params = generate_input()
    h = h_estimate(params, data)
    print(h(0))

    plt.figure()
    plt.hist(data.x, density=True)

    sample_x = np.arange(.5, 4, .1)
    sample_y = [h(xi) for xi in sample_x]

    plt.plot(sample_x, sample_y)  # we expect h(t) ~ 1 for standard exponential distribution
    plt.show()
