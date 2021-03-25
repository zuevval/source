from pathlib import Path
from typing import Tuple, Sequence, Dict, Callable

import matplotlib.pyplot as plt  # type: ignore
import numpy as np  # type: ignore
import pandas as pd
from scipy.special import erf


class Sample:
    train_x: np.array
    train_y: np.array
    test_x: np.array
    test_y: np.array

    train_means: Dict[int, np.array]
    train_covariances: Dict[int, np.array]
    train_sizes: Dict[int, int]
    class_labels: np.array

    def __init__(self, train_x: np.array, train_y: np.array, test_x: np.array, test_y: np.array):
        self.train_x, self.train_y, self.test_x, self.test_y = train_x, train_y, test_x, test_y
        self.class_labels = np.unique(train_y)
        train_subsamples = {i: train_x[train_y == i] for i in self.class_labels}
        self.train_means = {i: np.mean(train_subsamples[i], axis=0) for i in self.class_labels}
        self.train_covariances = {i: np.cov(train_subsamples[i].T) for i in self.class_labels}
        self.train_sizes = {i: len(train_subsamples[i]) for i in self.class_labels}

    def print_moments(self):
        np.set_printoptions(precision=2)
        print("means:")
        print(self.train_means)
        print("covarinaces:")
        print(self.train_covariances)


def generate_data(means: Sequence[Sequence[float]] = ((1, 3, 1), (1, -3, -1)),
                  covariance: Sequence[Sequence[float]] = ((1, .5, .5), (.5, 1, 0), (.5, 0, 1)),
                  train_size: int = 300, test_size: int = 100, seed: int = 0) -> Sample:
    n_classes = len(means)

    def generate_subsample(n: int) -> Tuple[np.array, np.array]:
        x = np.concatenate(
            [np.random.multivariate_normal(mean=m, cov=covariance, size=n) for m in means])
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


def calc_alpha(sample: Sample) -> Tuple[np.array, float, float]:
    """
    Calculates weights for discriminant function z(x) = alpha_1 x_1 + ... + alpha_p x_p,
    z(x) ?> c <=> x in positive class
    @param sample: two-class sample
    @return: alpha, c, D_U^2 (where D is the Mahalanobis distance between class 0 and class 1)
    """
    n1, n2 = (sample.train_sizes[cls] for cls in sample.class_labels)
    s1, s2 = (sample.train_covariances[cls] for cls in sample.class_labels)
    mu1, mu2 = (sample.train_means[cls] for cls in sample.class_labels)
    p = len(sample.train_x[0])  # number of parameters

    s = ((n1 - 1) * s1 + (n2 - 1) * s2) / (n1 + n2 - 2)
    if isinstance(s, float):
        s = np.array([[s]])
    alpha = np.matmul(np.linalg.inv(s), mu1 - mu2)
    z = np.matmul(alpha, sample.train_x.T)
    xi1, xi2 = np.matmul(alpha, mu1), np.matmul(alpha, mu2)
    c = (xi1 + xi2) / 2
    d2 = (xi1 - xi2) ** 2 / np.var(z)
    du2 = (n1 + n2 - p - 3) * d2 / (n1 + n2 - 3) - p * (1 / n1 + 1 / n2)
    return alpha, c, du2


def linear_classifier_factory(alpha: np.array, c: float, class_labels: np.array) -> Callable[[np.array], np.array]:
    assert len(class_labels) == 2, "only binary classifiers supported"

    def linear_classifier(x: np.array) -> np.array:
        """
        returns class1 if alpha*x >= c, class2 otherwise
        @param x: 2-d np.array: each row is a sample, each column is a variable
        @return: array of class labels
        """
        z = np.matmul(alpha, x.T)
        return np.array([class_labels[0] if z_row >= c else class_labels[1] for z_row in z])

    return linear_classifier


def laplace_function(x: float) -> float:
    return .5 * (1 + erf(x / np.sqrt(2)))


def calc_misclass_probabs(sample: Sample, du2: float) -> Tuple[float, float]:
    """
    Calculate misclassification probabilities for given sample and squared Mahalanobis distance `du2`
    """
    q1, q2 = np.array([sample.train_sizes[cls]
                       for cls in sample.class_labels]) / np.sum(list(sample.train_sizes.values()))
    k = np.log(q2 / q1)
    du = np.sqrt(du2)
    p21 = laplace_function((k - .5 * du2) / du)
    p12 = laplace_function((-k - .5 * du2) / du)
    return p21, p12


def classify(sample: Sample, title: str) -> Tuple[float, float]:
    print("\n--- {} ---".format(title))
    alpha, c, du2 = calc_alpha(sample)
    print("Mahalanobis distance: {}".format(du2))

    classifier = linear_classifier_factory(alpha, c, sample.class_labels)
    test_crosstab = pd.crosstab(classifier(sample.test_x), sample.test_y)
    print("test: contingency table")
    print(test_crosstab)
    cls1, cls2 = sample.class_labels
    nu_21 = test_crosstab[cls2][cls1] / (test_crosstab[cls1][cls1] + test_crosstab[cls2][cls1])
    nu_12 = test_crosstab[cls1][cls2] / (test_crosstab[cls2][cls2] + test_crosstab[cls1][cls2])
    print("Misclassification frequencies: nu_21={}, nu_12={}".format(nu_21, nu_12))

    print("train: contingency table")
    print(pd.crosstab(classifier(sample.train_x), sample.train_y))
    p21, p12 = calc_misclass_probabs(sample, du2)
    print("Misclassification probabilities: p_21={}, p_12={}".format(p21, p12))
    return p21, p12
