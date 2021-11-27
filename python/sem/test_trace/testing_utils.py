from dataclasses import dataclass
from typing import Optional

import numpy as np
from numpy import random
from scipy.stats import ortho_group


@dataclass
class MatrixProperties:
    mtx: np.ndarray
    q: np.ndarray
    eigvals: np.ndarray


def rand_positive_definite_mtx(size: int, seed: int, eig_max: Optional[float] = None) -> MatrixProperties:
    random.seed(seed)
    q = ortho_group.rvs(dim=size)
    eigvals = np.random.uniform(low=1, high=eig_max, size=size) if eig_max else np.abs(random.randn(size)) + 1e-3
    return MatrixProperties(mtx=q @ np.diag(eigvals) @ q.T, q=q, eigvals=eigvals)


def rand_unit_vector(size: int, seed: int) -> np.ndarray:
    random.seed(seed)
    q = np.random.uniform(-1, 1, size)
    q /= np.linalg.norm(q)
    return q
