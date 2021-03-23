from dataclasses import dataclass
from pathlib import Path
from typing import Tuple, Dict, List

import matplotlib.pyplot as plt
import numpy as np

from python.stats_multidim.lab2pca.classifier import Sample, calc_alpha


def pca(sample: Sample) -> Tuple[Sample, np.array, np.array]:
    x = np.concatenate((sample.test_x, sample.train_x))
    u, s, vt = np.linalg.svd(x, full_matrices=False)
    new_test_x = u[:len(sample.test_x), :]
    new_train_x = u[len(sample.test_x):, :]
    return Sample(train_x=new_train_x, train_y=sample.train_y, test_x=new_test_x, test_y=sample.test_y), s, u


def cut_components(sample: Sample, leave_components: int) -> Sample:
    new_train_x = sample.train_x[:, :leave_components]
    new_test_x = sample.test_x[:, :leave_components]
    return Sample(train_x=new_train_x, train_y=sample.train_y, test_x=new_test_x, test_y=sample.test_y)


def plot_explained_variance(s: np.array, out_path: Path, title: str):
    plt.figure()
    plt.bar(range(len(s)), np.cumsum(s) / np.sum(s))
    plt.title("PCA for {}: explained variance".format(title))
    plt.xlabel("number of retained components")
    plt.xlabel("explained variance")
    plt.savefig(out_path / "{}_explained_var.png".format(title))


def normalize(sample: Sample) -> Sample:
    x = np.concatenate((sample.test_x, sample.train_x))
    x_normalized = (x - np.mean(x)) / np.sqrt(np.var(x, axis=0))
    new_test_x = x_normalized[:len(sample.test_x), :]
    new_train_x = x_normalized[len(sample.test_x):, :]
    return Sample(train_x=new_train_x, train_y=sample.train_y, test_x=new_test_x, test_y=sample.test_y)


@dataclass
class MisclassProbab:
    p12: float
    p21: float


def plot_misclass_probabs(n_retained_components: List[int], misclass_probabs: Dict[str, List[MisclassProbab]],
                          out_path: Path) -> None:
    plt.figure()
    for title, misclass_prob in misclass_probabs.items():
        p21s = [mp.p21 for mp in misclass_prob]
        p12s = [mp.p12 for mp in misclass_prob]
        plt.plot(n_retained_components, p21s, "--", label="p(2|1) ({})".format(title))
        plt.plot(n_retained_components, p12s, label="p(1|2) ({})".format(title))
    plt.legend()
    plt.xticks(n_retained_components)
    plt.xlabel("number of retained components")
    plt.ylabel("probability of misclassification")
    plt.savefig(out_path / "misclass_probabs.png")


def plot_two_prcomps(sample: Sample, title: str, out_path: Path):
    # `sample` must be a result of PCA
    plt.figure()
    x, y = np.concatenate((sample.test_x, sample.train_x)), np.concatenate((sample.test_y, sample.train_y))
    plt.scatter(x[:, 0], x[:, 1], c=y)

    alpha, c, _ = calc_alpha(cut_components(sample, leave_components=2))
    x_boundary = np.linspace(*plt.gca().get_xlim(), 20)  # x values for decision boundary
    y_boundary = (- alpha[0] * x_boundary + c) / alpha[1]  # y values for decision boundary
    plt.plot(x_boundary, y_boundary)

    plt.title("{}: data on the plane of two first principal components".format(title))
    path_to_save = out_path / "pca_two_comp_{}".format(title)
    plt.savefig(path_to_save)
    print("saved figure at path: " + str(path_to_save))
