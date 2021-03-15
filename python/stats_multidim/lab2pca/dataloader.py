import numpy as np

from python.stats_multidim.lab2pca.classifier import Sample


def load_german() -> Sample:
    with open("data/german.data-numeric") as infile:
        lines = infile.readlines()
    rows = []
    for line in lines:
        rows.append([int(number) for number in line.strip().split()])
    rows = np.array(rows)
    rows = rows[rows[:, -1].argsort()]

    n = len(rows)
    test_fraction = .3
    second_class_fraction = np.bincount(rows[:, -1])[-1] / n
    first_class_fraction = 1 - second_class_fraction

    test_indices = np.concatenate((np.arange(int(first_class_fraction * test_fraction * n)),
                                   np.arange(
                                       int(n * (first_class_fraction + second_class_fraction * (1 - test_fraction))),
                                       n)))
    test_rows = rows[test_indices]
    train_rows = rows[~np.isin(np.arange(n), test_indices)]
    train_x, train_y = train_rows[:, :-1], train_rows[:, -1]
    test_x, test_y = test_rows[:, :-1], test_rows[:, -1]

    return Sample(train_x=train_x, train_y=train_y, test_x=test_x, test_y=test_y)
