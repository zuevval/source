from dataclasses import dataclass
from pathlib import Path

from typing import Tuple

import matplotlib.pyplot as plt  # type: ignore
import numpy as np  # type: ignore


@dataclass
class Sample:
    train_x: np.array
    train_y: np.array
    test_x: np.array
    test_y: np.array


def generate_data(train_size: int = 300, test_size: int = 100, seed: int = 0) -> Sample:
    means = [[1, 2, 1], [1, -2, -1]]
    covariances = [[[1, 0, 1], [0, 1, 0], [1, 0, 1]],
                   [[1, .5, .5], [.5, 1, 0], [.5, 0, 1]]]
    n_classes = len(means)

    def generate_subsample(n: int) -> Tuple[np.array, np.array]:
        x = np.concatenate(
            [np.random.multivariate_normal(mean=m, cov=c, size=n) for m, c in zip(means, covariances)])
        y = np.concatenate([np.array([i] * n) for i in range(n_classes)])
        return x, y

    n_train = train_size // n_classes
    n_test = test_size // n_classes
    np.random.seed(seed)
    train_x, train_y = generate_subsample(n_train)
    test_x, test_y = generate_subsample(n_test)
    return Sample(train_x=train_x, train_y=train_y, test_x=test_x, test_y=test_y)


def visualize_3d(data: Sample, out_path: Path) -> None:
    for x, y, label in ((data.test_x, data.test_y, "test"),
                        (data.train_x, data.train_y, "train")):
        fig = plt.figure()
        ax = fig.add_subplot(111, projection="3d")
        ax.scatter(x[:, 0], x[:, 1], x[:, 2], c=y)
        plt.savefig(out_path / (label + "3d.png"))


def main():
    sample = generate_data()
    visualize_3d(sample, Path("out"))


if __name__ == "__main__":
    main()
