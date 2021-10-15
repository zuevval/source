import numpy as np
from typing import Callable


def quad_approx(mtx: np.array, vec: np.array, f: Callable[[np.array], np.array]):
    return (vec.T @ f(mtx) @ vec)[0, 0]  # TODO stochastic estimate


def tr_approx(mtx: np.array, f: Callable[[np.array], np.array], n_samples: int, seed: int) -> float:
    result = 0
    np.random.seed(seed)
    for _ in range(n_samples):
        result += quad_approx(mtx=mtx, vec=np.random.choice((-1, 1), (len(mtx), 1)), f=f)
    return result / n_samples
