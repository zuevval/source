from pathlib import Path

from .classifier import Sample
from .pca import pca, plot_two_prcomps

import numpy as np


def test_pca():
    x = np.random.multivariate_normal(mean=[1, 1], cov=[[1, .7], [.7, 1]], size=100)
    sample = Sample(x[:60, :], np.zeros(60), x[60:, :], np.zeros(40))
    prcomps, _, _ = pca(sample)
    plot_two_prcomps(prcomps, out_path=Path("out"), title="test_pca_prcomps")
    plot_two_prcomps(sample, out_path=Path("out"), title="test_pca_sample")
