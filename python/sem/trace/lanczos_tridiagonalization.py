from dataclasses import dataclass

import numpy as np
from scipy.linalg import eigh_tridiagonal


@dataclass
class LanczosResult:
    eigvecs: np.ndarray
    eigvals: np.ndarray


def lanczos_naive(a: np.ndarray, q1: np.ndarray, max_iter: int) -> LanczosResult:
    """
    Approximately calculates the largest eigenvalue of `a`.
    Reference: Matrix computation (4th edition), Gene H. Golub and Charles F. Van Loan, 2013 (alg-m 10.1.1)
    @param a: Symmetric positive definite square matrix (two-dimensional: NxN)
    @param q1: unit vector (the starting point for Lanczos tridiagonalization) (two-dimensional: Nx1)
    @param max_iter: maximum number of iterations
    @return: lambda_0 (the estimate of the largest eigenvalue of `a`)
    """
    n = len(q1)
    alpha, beta = [], [1]
    r = [q1]
    q = [np.zeros((n, 1))]
    while len(alpha) < max_iter and not (np.isclose(beta[-1], 0)):
        q.append(r[-1] / beta[-1])
        alpha.append((q[-1].T @ a @ q[-1])[0, 0])
        r.append((a - alpha[-1] * np.eye(N=n)) @ q[-1] - beta[-1] * q[-2])
        beta.append(np.linalg.norm(r[-1]))
    eigval, eigvec = eigh_tridiagonal(d=np.array(alpha), e=np.array(beta[1:-1]))
    return LanczosResult(eigvecs=eigvec, eigvals=eigval)
