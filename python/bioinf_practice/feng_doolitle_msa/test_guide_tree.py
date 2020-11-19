from typing import Tuple
import numpy as np

from .guide_tree import distances, join_two, build_guide_tree


def prepare_data_a() -> Tuple[np.array, np.array]:
    s = np.array([
        [262, 31, 44, 13],
        [0, 287, 15, 16],
        [0, 0, 222, 45],
        [0, 0, 0, 215]
    ])
    s_rand = np.array([
        [0, -66.94, -80.28, -70.48],
        [0, 0, -82.86, -72.52],
        [0, 0, 0, -37.85],
        [0, 0, 0, 0]
    ])

    return s, s_rand


def prepare_expected_distances_a() -> np.array:
    return np.array([
        [0, 1.25, 0.95, 1.3],
        [0, 0, 1.23, 1.3],
        [0, 0, 0, 1.13],
        [0, 0, 0, 0]
    ])


def prepare_data_b():
    s = np.array([
        [277, 4, 37, -4],
        [0, 294, 3, 9],
        [0, 0, 238, 24],
        [0, 0, 0, 232]
    ])
    s_rand = np.array([
        [0, -101.65, -78.64, -75.04],
        [0, 0, -81.38, -75.12],
        [0, 0, 0, -45.83],
        [0, 0, 0, 0]
    ])
    return s, s_rand


def test_distances():
    s, s_rand = prepare_data_a()
    d_expected = prepare_expected_distances_a()
    d = distances(s, s_rand)
    assert (np.abs(d_expected - d) < 0.02).all()


def test_join_two():
    names = np.array([1, 2, 3, 4])  # variable names
    d = prepare_expected_distances_a()
    d1_expected = np.array([
        [0, 1.3, 1.24],
        [0, 0, 1.215],
        [0, 0, 0]
    ])
    new_var_name = 5
    d1, names1, joined_var1, joined_var2 = join_two(d, names, new_var_name)
    assert (np.abs(d1_expected - d1) < 0.02).all()
    assert (names1 == np.array([2, 4, new_var_name])).all()


def test_build_guide_tree():
    for s, s_rand in prepare_data_a(), prepare_data_b():
        build_guide_tree(s, s_rand)
