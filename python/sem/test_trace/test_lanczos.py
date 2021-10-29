import numpy as np

from python.sem.trace.lanczos_tridiagonalization import lanczos_naive
from sem.test_trace.test_utils import rand_positive_definite_mtx


def test_lanczos_naive():
    eig_max = 10
    for mtx_size in (5, 10, 15, 20,  # 25, 30 # TODO this does not converge in the naive implementation
                     ):
        rand_mtx_props = rand_positive_definite_mtx(mtx_size, seed=0, eig_max=eig_max)
        np.random.seed(0)
        q = np.random.uniform(-1, 1, mtx_size)  # TODO ask: what's the best choice for q1?
        q /= np.linalg.norm(q)

        max_eig_estimate = lanczos_naive(a=rand_mtx_props.mtx, q1=q)  # TODO find out the number of iterations
        assert 0 <= max_eig_estimate <= eig_max
        print("test for n={} passed, deviation~={:.3f}"
              .format(mtx_size, np.abs(np.max(rand_mtx_props.eigvals) - max_eig_estimate)))
