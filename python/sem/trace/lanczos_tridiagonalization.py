import numpy as np
from scipy.linalg import eigh_tridiagonal


def lanczos_naive(a: np.ndarray, q1: np.ndarray) -> float:
    """
    Approximately calculates the largest eigenvalue of `a`.
    Reference: Matrix computation (4th edition), Gene H. Golub and Charles F. Van Loan, 2013 (alg-m 10.1.1)
    @param a: Symmetric positive definite square matrix (two-dimensional)
    @param q1: unit vector (the starting point for Lanczos tridiagonalization) (one-dimensional)
    @return: lambda_0 (the estimate of the largest eigenvalue of `a`)
    """
    n = len(q1)
    alpha, beta = [], [1]
    r = [q1.reshape((n, 1))]
    q = [np.zeros((n, 1))]
    while not (np.isclose(beta[-1], 0)):
        q.append(r[-1] / beta[-1])
        alpha.append((q[-1].T @ a @ q[-1])[0, 0])
        r.append((a - alpha[-1] * np.eye(N=n)) @ q[-1] - beta[-1] * q[-2])
        beta.append(np.linalg.norm(r[-1]))
    last_eig_index = len(alpha) - 1
    return eigh_tridiagonal(
        d=np.array(alpha),
        e=np.array(beta[1:-1]),
        eigvals_only=True,
        select="i",
        select_range=(last_eig_index, last_eig_index))[0]
