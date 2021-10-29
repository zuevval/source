import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm
from python.sem.trace.trace_approx import tr_approx
from python.sem.test_trace.test_utils import rand_positive_definite_mtx


@np.vectorize
def average_deviation(n_samples: int, eig_max: float, absolute: bool):
    def f(x: np.array) -> np.array:
        return x ** 2

    n_sample_runs = 15
    mtx_size = 100
    result = 0
    for seed in range(n_sample_runs):
        mtx = rand_positive_definite_mtx(size=mtx_size, seed=seed, eig_max=eig_max).mtx
        tr_precise = np.trace(f(mtx))
        delta_tr = np.abs(tr_precise - tr_approx(mtx=mtx, f=f, n_samples=n_samples, seed=seed))
        if not absolute:
            delta_tr /= np.abs(tr_precise)
        result += delta_tr
    return result / n_sample_runs


def main():
    eig_maxes = np.arange(start=2, stop=30, step=2)
    n_samples = np.arange(1, 10)
    x, y = np.meshgrid(n_samples, eig_maxes)

    for absolute_dev in (True, False):
        z = average_deviation(x, y, absolute_dev)
        fig, ax = plt.subplots(subplot_kw={"projection": "3d"})
        ax.plot_surface(x, y, z, cmap=cm.get_cmap("RdYlGn"),
                        linewidth=0, antialiased=False)
        ax.set_xlabel("# samples")
        ax.set_xticks(n_samples)
        ax.set_ylabel("max eigenvalue")
        ax.set_yticks(eig_maxes)
        ax.set_zlabel("average deviation")
        ax.set_title("Method error for 10-by-10 matrix: " + "absolute" if absolute_dev else "relative")
        plt.show()


if __name__ == "__main__":
    main()
