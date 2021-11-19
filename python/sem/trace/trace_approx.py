import numpy as np
from typing import Callable, Optional
from enum import Enum

from python.sem.trace.lanczos_tridiagonalization import lanczos_naive, lanczos_memoptimized


class ApproxMethod(Enum):
    bruteforce = "br"
    gauss_lanczos_naive = "gl"
    gauss_lanczos_memopt = "gl2"


def bruteforce_approx(mtx: np.ndarray, vec: np.ndarray, f: Callable[[np.ndarray], np.ndarray]) -> float:
    return (vec.T @ f(mtx) @ vec)[0, 0]


def gauss_lanczos_approx(mtx: np.ndarray, vec: np.ndarray, f: Callable[[np.ndarray], np.ndarray],
                         max_iter: int, method: ApproxMethod) -> float:
    vec_norm = np.linalg.norm(vec)
    q1 = vec / vec_norm
    if method == ApproxMethod.gauss_lanczos_naive:
        decomposition = lanczos_naive(a=mtx, q1=q1, max_iter=max_iter)
    elif method == ApproxMethod.gauss_lanczos_memopt:
        decomposition = lanczos_memoptimized(a=mtx, q1=q1, max_iter=max_iter)
    else:
        raise ValueError("Method " + str(method) + " not supported in `gauss_lanczos_approx`")
    weights = decomposition.eigvecs[0, :] ** 2
    nodes = decomposition.eigvals.flatten()
    return np.sum(weights * f(nodes)) * vec_norm ** 2


def tr_approx(mtx: np.array, f: Callable[[np.array], np.array], n_samples: int, seed: int,
              approx_method: ApproxMethod, max_iter: Optional[int] = None) -> float:
    """
    Unbiased stochastic trace estimator using Hutchinson trick.
    Calculates trace(f(mtx))
    @param mtx: square symmetric positive definite matrix
    @param f: element-wise function to be applied to `mtx`
    @param n_samples: number of iterations for the Hutchinson trick
    @param seed: integer (a source of randomness)
    @param approx_method: the method for the quadrature estimation
    @param max_iter: when ApproxMethod is `gauss_lanczos_*`, limits the number of iterations in tridiagonalization
    @return: estimated trace value
    """
    result = 0
    np.random.seed(seed)
    for _ in range(n_samples):
        vec = np.random.choice((-1, 1), (len(mtx), 1))
        if approx_method == ApproxMethod.bruteforce:
            result += bruteforce_approx(mtx=mtx, vec=vec, f=f)
        elif approx_method in (ApproxMethod.gauss_lanczos_naive, ApproxMethod.gauss_lanczos_memopt):
            result += gauss_lanczos_approx(mtx=mtx, vec=vec, f=f, max_iter=max_iter if max_iter else len(mtx),
                                           method=approx_method)
    return result / n_samples
