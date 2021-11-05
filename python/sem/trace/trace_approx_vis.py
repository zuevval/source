import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm
from python.sem.trace.trace_approx import tr_approx, ApproxMethod
from python.sem.test_trace.test_utils import rand_positive_definite_mtx


def matrix_fun(x: np.array) -> np.array:
    if isinstance(x, np.ndarray) and x.ndim == 2:
        return x @ x @ x
    return x ** 3  # when the matrix is not rectangular, return element-wise product


@np.vectorize
def average_deviation(n_samples: int, eig_max: float, absolute: bool, mtx_size: int):
    n_sample_runs = 15
    result = 0
    for seed in range(n_sample_runs):
        mtx = rand_positive_definite_mtx(size=mtx_size, seed=seed, eig_max=eig_max).mtx
        tr_precise = np.trace(matrix_fun(mtx))
        delta_tr = np.abs(tr_precise - tr_approx(mtx=mtx, f=matrix_fun, n_samples=n_samples, seed=seed,
                                                 approx_method=ApproxMethod.bruteforce))
        if not absolute:
            delta_tr /= np.abs(tr_precise)
        result += delta_tr
    return result / n_sample_runs


def vis_hutchinson():
    eig_maxes = np.arange(start=2, stop=30, step=2)
    n_samples = np.arange(1, 10)
    mtx_size = 10
    x, y = np.meshgrid(n_samples, eig_maxes)

    for absolute_dev in (True, False):
        z = average_deviation(x, y, absolute_dev, mtx_size=mtx_size)
        fig, ax = plt.subplots(subplot_kw={"projection": "3d"})
        ax.plot_surface(x, y, z, cmap=cm.get_cmap("RdYlGn"),
                        linewidth=0, antialiased=False)
        ax.set_xlabel("# samples")
        ax.set_xticks(n_samples)
        ax.set_ylabel("max eigenvalue")
        ax.set_yticks(eig_maxes)
        ax.set_zlabel("average deviation")
        ax.set_title("Hutchinson error for {}-by-{} matrix: {}".format(mtx_size, mtx_size,
                                                                       "absolute" if absolute_dev else "relative"))
        plt.show()


def vis_gauss_lanczos():
    n_repetitions = 30
    eig_max = 5

    mtx_sizes = list(range(2, 45))
    average_errs = []
    for mtx_size in mtx_sizes:
        np.random.seed(0)
        average_err = 0
        for seed in range(n_repetitions):
            mtx = rand_positive_definite_mtx(size=mtx_size, seed=seed, eig_max=eig_max).mtx
            tr_appr = tr_approx(mtx=mtx, f=matrix_fun, n_samples=mtx_size // 2 + 1, seed=seed,
                                approx_method=ApproxMethod.gauss_lanczos, max_iter=mtx_size // 2 + 1)
            tr_precise = np.trace(matrix_fun(mtx))
            print("trace (approx): {}".format(tr_appr))
            print("trace (precise): {}".format(tr_precise))
            average_err += np.abs((tr_appr - tr_precise) / tr_appr)
        average_err /= n_repetitions
        average_errs.append(average_err)

    plt.figure()
    plt.plot(mtx_sizes, average_errs)
    plt.title("Trace approximation with Gauss-Lanczos procedure: \n relative deviation")
    plt.xlabel("matrix size")
    plt.ylabel("average relative error per {} runs".format(n_repetitions))
    plt.show()


def main():
    vis_gauss_lanczos()
    vis_hutchinson()


if __name__ == "__main__":
    main()
