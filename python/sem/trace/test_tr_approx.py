from scipy.stats import ortho_group
from numpy import random
import numpy as np

from python.sem.trace.trace_approx import tr_approx


def rand_positive_definite_mtx(size: int, seed: int):
    random.seed(seed)
    q = ortho_group.rvs(dim=size)
    eigvals = np.abs(random.randn(size)) + 1e-3  # random positive numbers
    return q @ np.diag(eigvals) @ q.T


def test_rand_positive_definite():
    for seed in range(10):
        assert np.all(np.linalg.eigvals(rand_positive_definite_mtx(10, seed)) > 0)


def test_tr_approx():
    m = rand_positive_definite_mtx(10, 0)

    def f(x: np.array) -> np.array:
        return np.log(np.abs(x) + .5)

    trace_precise = np.trace(f(m))
    residuals = [np.abs(tr_approx(m, f, n_samples, 0) - trace_precise)
                 for n_samples in range(1, 20)]
    assert np.median(residuals[:5]) > np.median(residuals[-5:])
