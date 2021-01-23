import numpy as np
from .week1_convolutional_model import conv_single_step, conv_forward, pool_forward


def test_conv_single_step():
    np.random.seed(1)
    a_slice_prev = np.random.randn(4, 4, 3)
    w = np.random.randn(4, 4, 3)
    b = np.random.randn(1, 1, 1)

    z = conv_single_step(a_slice_prev, w, b)
    assert (z + 23.1602) < 1e-4


def test_conv_forward():
    np.random.seed(1)
    a_prev = np.random.randn(10, 4, 4, 3)
    W = np.random.randn(2, 2, 3, 8)
    b = np.random.randn(1, 1, 1, 8)
    hparameters = {"pad": 2,
                   "stride": 1}

    z, cache_conv = conv_forward(a_prev, W, b, hparameters)

    assert (np.mean(z) - 0.1559) < 1e-4
    assert np.sum(cache_conv[0][1][2][3] - [-0.20075807, 0.18656139, 0.41005165]) < 1e-3


def test_pool_forward():
    np.random.seed(1)
    A_prev = np.random.randn(2, 4, 4, 3)
    hparameters = {"stride": 1, "f": 4}

    a, cache = pool_forward(A_prev, hparameters)
    assert np.sum((a - [[[[1.74481176, 1.6924546, 2.10025514]]], [[[1.19891788, 1.51981682, 2.18557541]]]])) < 1e-3
