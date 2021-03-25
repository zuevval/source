from pathlib import Path

from .classifier import laplace_function
import matplotlib.pyplot as plt
import numpy as np


def test_laplace_function():
    abs_tol = 1e-3
    assert abs(laplace_function(0) - .5) < abs_tol
    assert abs(laplace_function(.5) - .6915) < abs_tol

    t = np.linspace(-4, 4, 100)
    y = list(map(laplace_function, t))

    plt.figure()
    plt.plot(t, y)
    plt.savefig(str(Path("out") / "test_laplace_function.png"))
