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


def forward(x: str, q: dict, a: dict, e_match: dict, e_insert: dict) -> ForwardMatrices:
    precision = 3  # keep 3 decimals

    a_log = {key: [round(math.log(elem), precision) if elem is not None else 0 for elem in value] for
             key, value in
             a.items()}

    dummy_symbol = "!"
    x = dummy_symbol + x  # indexing from 1

    n_x, n_hmm = len(x), len(a[m_m])
    fd: List[list] = [[None] * n_hmm for _ in range(n_x)]  # variables for deletion
    fi, fm = copy.deepcopy(fd), copy.deepcopy(fd)  # variables for insertion and match

    for i in range(n_x):
        fm[i][0] = fd[i][0] = 0

    for j in range(n_hmm):
        fm[0][j] = fi[0][j] = 0

    for i in range(n_x):
        for j in range(n_hmm):
            if j != 0:
                fd_new = sum((
                    fm[i][j - 1] + a_log[m_d][j - 1],
                    fi[i][j - 1] + a_log[i_d][j - 1],
                    fd[i][j - 1] + a_log[d_d][j - 1],
                ))
                fd[i][j] = round(fd_new, precision)

            if i != 0:
                fi_new = math.log(e_insert[x[i]][j] / q[x[i]]) + sum((
                    fm[i - 1][j] + a_log[m_i][j],
                    fi[i - 1][j] + a_log[i_i][j],
                    fd[i - 1][j] + a_log[d_i][j],
                ))
                fi[i][j] = round(fi_new, precision)

            if i != 0 and j != 0:
                fm_new = math.log(e_match[x[i]][j] / q[x[i]]) + sum((
                    fm[i - 1][j - 1] + a_log[m_m][j - 1],
                    fi[i - 1][j - 1] + a_log[i_m][j - 1],
                    fd[i - 1][j - 1] + a_log[d_m][j - 1],
                ))
                fm[i][j] = round(fm_new, precision)

    probability = math.exp(fm[-1][-1])
    return ForwardMatrices(fm=fm, fi=fi, fd=fd, probability=probability)


def test_forward_borodovskiy():
    x = "GCCAG"
    q = {"A": 0.3, "T": 0.3, "C": 0.2, "G": 0.2}
    a = {
        m_m: [.82, .55, .8, .9],
        m_d: [.09, .18, .1, None],
        m_i: [.09, .27, .1, .1],

        i_m: [.33, .6, .33, .5],
        i_d: [.33, .2, .33, None],
        i_i: [.33, .2, .33, .5],

        d_m: [None, .33, .5, .5],
        d_d: [None, .33, .25, None],
        d_i: [None, .33, .25, .5],
    }
    e_match = {
        "A": [None, .25, .55, .08],
        "C": [None, .08, .09, .33],
        "G": [None, .58, .18, .5],
        "T": [None, .08, .18, .08],
    }
    e_insert = {
        "A": [.25, .17, .25, .25],
        "C": [.25, .5, .25, .25],
        "G": [.25, .17, .25, .25],
        "T": [.25, .17, .25, .25],
    }
    result = forward(x=x, q=q, a=a, e_match=e_match, e_insert=e_insert)

    print("fm")
    pprint(result.fm)
    print("fd")
    pprint(result.fd)
    print("fi")
    pprint(result.fi)
    print("probability:", result.probability)
