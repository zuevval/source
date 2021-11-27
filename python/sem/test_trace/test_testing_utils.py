from typing import List

import matplotlib.pyplot as plt
import plotly.express as px
import numpy as np

from python.sem.test_trace.testing_utils import rand_positive_definite_mtx


def test_rand_matrix():
    matrices: List[np.ndarray] = []
    size = 2
    max_eig = 20
    out_file_stem = "rand_matrices"
    for seed in range(200):
        matrices.append(rand_positive_definite_mtx(size=size, seed=seed, eig_max=max_eig).mtx)
    matrices_flat = np.array([mtx.flatten() for mtx in matrices])

    fig = plt.figure()
    ax = fig.add_subplot(projection="3d")
    ax.scatter(matrices_flat[:, 0], matrices_flat[:, 1], matrices_flat[:, 3], c=matrices_flat[:, 2])
    ax.set_xlabel("a[0,0]")
    ax.set_ylabel("a[0,1]")
    ax.set_zlabel("a[1,1]")
    plt.savefig(out_file_stem + ".png")

    px_fig = px.scatter_3d(x=matrices_flat[:, 0], y=matrices_flat[:, 1], z=matrices_flat[:, 3],
                           color=matrices_flat[:, 2])
    with open(out_file_stem + ".html", "w") as fout:
        fout.write(px_fig.to_html())
