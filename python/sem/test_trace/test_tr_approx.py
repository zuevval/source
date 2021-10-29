import numpy as np

from python.sem.trace.trace_approx import tr_approx, ApproxMethod
from sem.test_trace.test_utils import rand_positive_definite_mtx


def test_rand_positive_definite():
    for seed in range(10):
        assert np.all(np.linalg.eigvals(rand_positive_definite_mtx(10, seed).mtx) > 0)


def test_hutchinson_trick():
    m = rand_positive_definite_mtx(10, 0).mtx

    def f(x: np.array) -> np.array:
        return np.log(np.abs(x) + .5)

    trace_precise = np.trace(f(m))
    residuals = [np.abs(tr_approx(m, f, n_samples, 0, ApproxMethod.bruteforce) - trace_precise)
                 for n_samples in range(1, 20)]
    assert np.median(residuals[:5]) > np.median(residuals[-5:])


def test_gauss_lanzcos():
    mtx = rand_positive_definite_mtx(5, 0).mtx

    def f(x: np.ndarray) -> np.ndarray:
        return x ** 2

    tr_appr = tr_approx(mtx=mtx, f=f, n_samples=3, seed=0, approx_method=ApproxMethod.bruteforce)
    assert np.abs((tr_appr - np.trace(f(mtx))) / tr_appr) < .5
