from pathlib import Path
from typing import Tuple, Sequence, Dict

import matplotlib.pyplot as plt  # type: ignore
import numpy as np  # type: ignore


class Sample:
    train_x: np.array
    train_y: np.array
    test_x: np.array
    test_y: np.array

    train_means: Dict[int, np.array]
    train_variances: Dict[int, np.array]
    class_labels: np.array

    def __init__(self, train_x: np.array, train_y: np.array, test_x: np.array, test_y: np.array):
        self.train_x, self.train_y, self.test_x, self.test_y = train_x, train_y, test_x, test_y
        self.class_labels = np.unique(train_y)
        self.train_means = {i: np.mean(train_x[train_y == i], axis=0) for i in self.class_labels}
        self.train_variances = {i: np.var(train_x[train_y == i], axis=0) for i in self.class_labels}


def generate_data(means: Sequence[Sequence[float]] = ((1, 2, 1), (1, -2, -1)),
                  covariances: Sequence[Sequence[Sequence[float]]] =
                  (((1, 0, 1), (0, 1, 0), (1, 0, 1)),
                   ((1, .5, .5), (.5, 1, 0), (.5, 0, 1))),
                  train_size: int = 300, test_size: int = 100, seed: int = 0) -> Sample:
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


def visualize_3d(data: Sample, out_path: Path, title: str) -> None:
    for x, y, label in ((data.test_x, data.test_y, "test"),
                        (data.train_x, data.train_y, "train")):
        fig = plt.figure()
        ax = fig.add_subplot(111, projection="3d")
        ax.scatter(x[:, 0], x[:, 1], x[:, 2], c=y)
        plt.savefig(out_path / "{}_{}_3d.png".format(label, title))


def main():
    out_path = Path("out")
    good_sample, good_sample_title = generate_data(), "well-separated"
    visualize_3d(data=good_sample, out_path=out_path, title=good_sample_title)
    print(good_sample.train_means)

    bad_means = [[.5] * 3, [-.5] * 3]
    bad_cov = [[[1.5, 0, 0], [0, 1.5, 0], [0, 0, 1.5]]] * 2
    bad_sample, bad_sample_title = generate_data(bad_means, bad_cov), "poorly_separated"
    visualize_3d(data=generate_data(bad_means, bad_cov), out_path=out_path, title=bad_sample_title)

    # TODO well-separated elongated clusters, well-separated independent


if __name__ == "__main__":
    main()
