import numpy as np
from scipy.stats import ortho_group
import matplotlib.pyplot as plt
from matplotlib import cm
from python.sem.trace.trace_approx import tr_approx


@np.vectorize
def average_deviation(n_samples: int, eig_max: float):
    def f(x: np.array) -> np.array:
        return np.sin(x)

    n_sample_runs = 15
    mtx_size = 10
    result = 0
    for seed in range(n_sample_runs):
        np.random.seed(seed)
        q = ortho_group.rvs(dim=mtx_size)
        eigvals = np.random.uniform(low=1, high=eig_max, size=mtx_size)
        mtx = q @ np.diag(eigvals) @ q.T
        result += np.abs(np.trace(f(mtx)) - tr_approx(mtx=mtx, f=f, n_samples=n_samples, seed=seed))
    return result / n_sample_runs


def main():
    eig_maxes = np.arange(start=2, stop=30, step=2)
    n_samples = np.arange(1, 10)
    x, y = np.meshgrid(n_samples, eig_maxes)
    z = average_deviation(x, y)

    fig, ax = plt.subplots(subplot_kw={"projection": "3d"})
    ax.plot_surface(x, y, z, cmap=cm.get_cmap("RdYlGn"),
                    linewidth=0, antialiased=False)
    ax.set_xlabel("# samples")
    ax.set_xticks(n_samples)
    ax.set_ylabel("max eigenvalue")
    ax.set_yticks(eig_maxes)
    ax.set_zlabel("average deviation")
    ax.set_title("Method error for 10-by-10 matrix")
    plt.show()


if __name__ == "__main__":
    main()
