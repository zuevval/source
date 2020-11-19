"""
Feng-Doolitle progressive multiple sequence alignment. Constructing a guide tree
see Durbin et Al, p. 145 (paragraph 6.4, Progressive alignment methods)

Usage: see `test_guide_tree.py/test_build_guide_tree`
"""
from typing import Tuple, Union

import numpy as np  # type:ignore


def distances(s: np.array, s_rand: np.array) -> np.array:
    assert s.shape == s_rand.shape, "input dimensions mismatch"
    s_max = np.zeros(shape=s.shape)
    d = np.zeros(shape=s.shape)
    for i in range(len(s)):
        for j in range(i + 1, len(s)):
            s_max[i, j] = 0.5 * (s[i, i] + s[j, j])
        d[i, i] = 0
        i_range = np.s_[i, i + 1:]
        d[i_range] = [-np.log(x) for x in (s[i_range] - s_rand[i_range]) / (s_max[i_range] - s_rand[i_range])]
    return d


def join_two(old_d: np.ndarray,
             old_var_names: np.array, new_var_name: Union[str, int]) -> Tuple[np.array, np.array, int, int]:
    # finding indices of two elements to join
    min_element, min_i, min_j = np.inf, -1, -1
    for i in range(len(old_d)):
        for j in range(i + 1, len(old_d)):
            if old_d[i, j] < min_element:
                min_element, min_i, min_j = old_d[i, j], i, j

    # appending new element - a joint of two
    names = np.append(old_var_names, [new_var_name])
    d = np.zeros((len(old_d) + 1, len(old_d) + 1))
    d[:-1, :-1] = old_d
    for idx in range(len(d) - 1):
        d_i = d[min_i, idx] if min_i < idx else d[idx, min_i]
        d_j = d[min_j, idx] if min_j < idx else d[idx, min_j]
        d[idx, -1] = .5 * (d_i + d_j)

    # removing old 2 elements
    indices_to_join = [min_i, min_j]
    d = np.delete(np.delete(d, indices_to_join, axis=0), indices_to_join, axis=1)
    names = np.delete(names, indices_to_join)

    return d, names, old_var_names[min_i], old_var_names[min_j]


def build_guide_tree(s: np.array, s_rand: np.array):
    var_names = np.array(list(range(1, len(s) + 1)))
    d = distances(s, s_rand)

    np.set_printoptions(precision=3)
    print("\n--- Constructing a guide tree using the clustering algorithm ---")
    print("initial variables:")
    print(var_names)
    print(d)
    for new_var in range(len(s) + 1, 2 * len(s)):
        d, var_names, joined1, joined2 = join_two(d, var_names, new_var)
        print("joined {} and {} into {}".format(joined1, joined2, new_var))
        print(var_names)
        print(d)
