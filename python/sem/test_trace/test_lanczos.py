import numpy as np

from python.sem.trace.lanczos_tridiagonalization import lanczos_naive
from sem.test_trace.test_utils import rand_positive_definite_mtx


def test_lanczos_naive():
    eig_max = 10
    for mtx_size in (5, 10, 15, 20, 25, 30):
        rand_mtx_props = rand_positive_definite_mtx(mtx_size, seed=0, eig_max=eig_max)
        np.random.seed(0)
        q = np.random.uniform(-1, 1, mtx_size)
        q /= np.linalg.norm(q)

        eig_estimate = lanczos_naive(a=rand_mtx_props.mtx, q1=q.reshape((len(q), 1)), max_iter=mtx_size // 2 + 1)
        assert (0 <= eig_estimate.eigvals).all() and (eig_estimate.eigvals <= eig_max).all()
        print("test for n={} passed, k={}, deviation of max eig ={}"
              .format(mtx_size, len(eig_estimate.eigvals),
                      np.abs(np.max(rand_mtx_props.eigvals) - np.max(eig_estimate.eigvals))))
