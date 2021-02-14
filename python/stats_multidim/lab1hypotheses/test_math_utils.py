import numpy as np

from .math_utils import mean, var, cdf


def test_mean():
    for arr, m in (([1], 1),
                   ([1.5, 3.5, 2], 7 / 3),
                   ([[0.1, 0.2], [0.6, 0.5]], .35)):
        assert abs(mean(np.array(arr)) - m) < 1e-4


def test_var():
    assert abs(var(np.array([1, 2, 3])) - 2 / 3) < 1e-4


def test_cdf():
    arr = np.array([1.5, 2.2, 3.3, 2.2])
    x, y = cdf(x=arr)
    assert (x == np.array([1.5, 2.2, 2.2, 3.3])).all()
    assert (y == np.array([.25, .5, .75, 1.])).all()
