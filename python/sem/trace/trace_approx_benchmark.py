from pathlib import Path
from typing import List

import time

import numpy as np
import matplotlib.pyplot as plt

from python.sem.test_trace.test_utils import rand_positive_definite_mtx
from python.sem.trace.trace_approx import tr_approx, ApproxMethod
from python.sem.trace.trace_approx_vis import matrix_fun


def trace_approx_benchmark(n_lanczos_iter: int,
                           n_hutchinson_iter: int,
                           eig_max: int,
                           fig_file: Path):
    methods = (
        ApproxMethod.gauss_lanczos_naive,
        ApproxMethod.gauss_lanczos_memopt,
    )

    n_repeats = 5
    mtx_sizes = list(range(20, 521, 20))
    n_observ = len(mtx_sizes)
    times_exact = [0] * n_observ
    times, errs = ({method: [0] * n_observ for method in methods} for _ in range(2))

    for i_obs, m_size in enumerate(mtx_sizes):
        for seed in range(n_repeats):
            r_mtx = rand_positive_definite_mtx(size=m_size, seed=seed, eig_max=eig_max)

            t_exact_start = time.perf_counter()
            tr_exact = np.trace(matrix_fun(r_mtx.mtx))
            t_exact_end = time.perf_counter()
            times_exact[i_obs] += t_exact_end - t_exact_start

            for method in methods:
                t_start = time.perf_counter()
                tr_appr = tr_approx(mtx=r_mtx.mtx, f=matrix_fun, n_samples=n_hutchinson_iter, max_iter=n_lanczos_iter,
                                    seed=seed, approx_method=method)
                t_end = time.perf_counter()

                times[method][i_obs] += t_end - t_start
                errs[method][i_obs] += np.abs((tr_appr - tr_exact) / tr_exact)

            def normalize(arr: List[int]):
                arr[i_obs] /= n_repeats

            map(normalize, [times_exact, *times.values(), *errs.values()])

    fig, (ax_top, ax_bottom) = plt.subplots(nrows=2, ncols=1)

    ax_top.plot(mtx_sizes, times_exact)
    for method in methods:
        ax_top.plot(mtx_sizes, times[method])
    ax_top.legend(["exact", *(str(method) for method in methods)])
    ax_top.set_title("time performance in seconds")
    ax_top.set_xlabel("mtx size")

    for method in methods:
        ax_bottom.plot(mtx_sizes, errs[method])
    ax_bottom.legend(list(map(str, methods)))
    ax_bottom.set_title("relative error")
    ax_bottom.set_xlabel("mtx size")

    plt.tight_layout()
    plt.savefig(fig_file)


def main():
    out_dir = Path("img_benchmark")
    out_dir.mkdir(exist_ok=True)

    n_hutchinson_iter = 10
    eig_max = 10

    for n_lanczos_iter in range(1, 5):
        trace_approx_benchmark(n_lanczos_iter=n_lanczos_iter,
                               n_hutchinson_iter=n_hutchinson_iter,
                               eig_max=eig_max,
                               fig_file=out_dir / "hutchinson_iter{}_lanczos_iter{}_max_eig{}.png".format(
                                   n_hutchinson_iter, n_lanczos_iter, eig_max))


if __name__ == "__main__":
    main()
