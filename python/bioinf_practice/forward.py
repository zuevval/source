# Forward algorithm for determining the probability of emission of a given DNA sequence by a given Hidden Markov Model

import copy
import math
from dataclasses import dataclass
from pprint import pprint
from typing import List, Sequence

m_m, m_i, m_d, i_m, i_i, i_d, d_m, d_i, d_d = "M-M", "M-I", "M-D", "I-M", "I-I", "I-D", "D-M", "D-I", "D-D"


@dataclass
class ForwardMatrices:
    fm: Sequence[Sequence[float]]
    fi: Sequence[Sequence[float]]
    fd: Sequence[Sequence[float]]
    probability: float

    def print(self):
        print("\nfm")
        pprint(self.fm)
        print("fd")
        pprint(self.fd)
        print("fi")
        pprint(self.fi)
        print("probability:", self.probability)


def forward(x: str, q: dict, a: dict, e_match: dict, e_insert: dict) -> ForwardMatrices:
    precision = 3  # keep 3 decimals

    a = {key: [elem if elem is not None else 0 for elem in value] for
         key, value in
         a.items()}

    dummy_symbol = "!"
    x = dummy_symbol + x  # indexing from 1

    n_x, n_hmm = len(x), len(a[m_m])
    fd: List[list] = [[None] * n_hmm for _ in range(n_x)]  # variables for deletion
    fi, fm = copy.deepcopy(fd), copy.deepcopy(fd)  # variables for insertion and match

    for i in range(n_x):
        fm[i][0] = fd[i][0] = -float("inf")

    for j in range(n_hmm):
        fm[0][j] = fi[0][j] = -float("inf")

    fm[0][0] = 0

    for i in range(n_x):
        for j in range(n_hmm):
            if j != 0:
                fd_new = math.log(sum((
                    a[m_d][j - 1] * math.exp(fm[i][j - 1]),
                    a[i_d][j - 1] * math.exp(fi[i][j - 1]),
                    a[d_d][j - 1] * math.exp(fd[i][j - 1]),
                )))
                fd[i][j] = round(fd_new, precision)

            if i != 0:
                fi_new = math.log(e_insert[x[i]][j] / q[x[i]]) + math.log(sum((
                    a[m_i][j] * math.exp(fm[i - 1][j]),
                    a[i_i][j] * math.exp(fi[+i - 1][j]),
                    a[d_i][j] * math.exp(fd[i - 1][j]),
                )))
                fi[i][j] = round(fi_new, precision)

            if i != 0 and j != 0:
                fm_new = math.log(e_match[x[i]][j] / q[x[i]]) + math.log(sum((
                    a[m_m][j - 1] * math.exp(fm[i - 1][j - 1]),
                    a[i_m][j - 1] * math.exp(fi[i - 1][j - 1]),
                    a[d_m][j - 1] * math.exp(fd[i - 1][j - 1]),
                )))
                fm[i][j] = round(fm_new, precision)

    probability = math.exp(fm[-1][-1] + fi[-1][-1] + fd[-1][-1])
    return ForwardMatrices(fm=fm, fi=fi, fd=fd, probability=probability)


def test_forward():  # test 3 (modification 5)
    x = "GTAC"
    q = {"A": 0.3, "T": 0.3, "C": 0.2, "G": 0.2}
    a = {
        m_m: [.77, .72, .43, .66, .83],
        m_d: [.14, .14, .30, .17, None],
        m_i: [.14, .14, .27, .17, .17],

        i_m: [.33, .48, .33, .52, .44],
        i_d: [.33, .26, .33, .24, None],
        i_i: [.33, .26, .33, .24, .55],

        d_m: [None, .33, .33, .52, .44],
        d_d: [None, .33, .33, .24, None],
        d_i: [None, .33, .33, .24, .55],
    }
    e_match = {
        "G": [None, .23, .13, .35, .25],
        "T": [None, .51, .51, .17, .25],
        "C": [None, .13, .23, .31, .25],
        "A": [None, .13, .13, .17, .25],
    }
    e_insert = {
        "G": [.25, .25, .20, .25, .25],
        "T": [.25, .25, .20, .25, .25],
        "C": [.25, .25, .20, .25, .25],
        "A": [.25, .25, .40, .25, .25],
    }
    forward(x=x, q=q, a=a, e_match=e_match, e_insert=e_insert).print()


def test_probability():
    x = "GAGGT"
    q = {"A": 0.3, "T": 0.3, "C": 0.2, "G": 0.2}
    a = {
        m_i: [.1, .1, 3 / 9, 1 / 9],
        m_d: [.1, .2, 1 / 9, None],
        m_m: [.8, .7, 5 / 9, 8 / 9],

        i_i: [1 / 3, 1 / 3, .2, .5],
        i_m: [1 / 3, 1 / 3, .6, .5],
        i_d: [1 / 3, 1 / 3, .2, None],

        d_d: [None, 1 / 3, .25, None],
        d_m: [None, 1 / 3, .50, .5],
        d_i: [None, 1 / 3, .25, .5],
    }
    e_match = {
        "A": [None, 1 / 11, .5, 1 / 11],
        "C": [None, 4 / 11, .1, 1 / 11],
        "G": [None, 5 / 11, .1, 4 / 11],
        "T": [None, 1 / 11, .3, 5 / 11],
    }
    e_insert = {
        "A": [.25, .25, 1 / 6, .25],
        "C": [.25, .25, 2 / 6, .25],
        "G": [.25, .25, 2 / 6, .25],
        "T": [.25, .25, 1 / 6, .25],
    }
    forward(x=x, q=q, a=a, e_match=e_match, e_insert=e_insert).print()
