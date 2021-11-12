import numpy as np

from python.sem.trace.lanczos_tridiagonalization import lanczos_naive, lanczos_vectorized
from sem.test_trace.test_utils import rand_positive_definite_mtx, rand_unit_vector


def test_lanczos_naive():
    eig_max = 10
    for mtx_size in (5, 10, 15, 20, 25, 30):
        rand_mtx_props = rand_positive_definite_mtx(mtx_size, seed=0, eig_max=eig_max)
        np.random.seed(0)

        q = rand_unit_vector(size=mtx_size, seed=0)
        eig_estimate = lanczos_naive(a=rand_mtx_props.mtx, q1=q.reshape((len(q), 1)), max_iter=mtx_size // 2 + 1)
        assert (0 <= eig_estimate.eigvals).all() and (eig_estimate.eigvals <= eig_max).all()
        print("test for n={} passed, k={}, deviation of max eig ={}"
              .format(mtx_size, len(eig_estimate.eigvals),
                      np.abs(np.max(rand_mtx_props.eigvals) - np.max(eig_estimate.eigvals))))


def test_lanczos_vectorized():
    mtx_size, seed = 10, 0
    abs_tol = .1
    for mtx_size in range(10, 40, 5):
        rand_mtx_props = rand_positive_definite_mtx(size=mtx_size, seed=seed, eig_max=5)
        q1, max_iter = rand_unit_vector(size=mtx_size, seed=seed).reshape((mtx_size, 1)), mtx_size // 2 + 1
        res_vec = lanczos_vectorized(a=rand_mtx_props.mtx, q1=q1, max_iter=max_iter)
        assert np.abs(np.max(res_vec.eigvals) - np.max(rand_mtx_props.eigvals)) < abs_tol
