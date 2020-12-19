import copy
import math
from dataclasses import dataclass
from pprint import pprint
from typing import List, Sequence

m_m, m_i, m_d, i_m, i_i, i_d, d_m, d_i, d_d = "M-M", "M-I", "M-D", "I-M", "I-I", "I-D", "D-M", "D-I", "D-D"


@dataclass
class ViterbiMatrices:
    vm: Sequence[Sequence[float]]
    vi: Sequence[Sequence[float]]
    vd: Sequence[Sequence[float]]


def viterbi(x: str, q: dict, a: dict, e_match: dict, e_insert: dict) -> ViterbiMatrices:
    precision = 3  # keep 3 decimals

    a_log = {key: [round(math.log(elem), precision) if elem is not None else -float("inf") for elem in value] for
             key, value in
             a.items()}

    x = "-" + x  # indexing from 1, e. g. x="AGC" -> "-AGC" => x[1]="A"

    n_x, n_hmm = len(x), len(a[m_m])
    vd: List[list] = [[None] * n_hmm for _ in range(n_x)]  # Viterbi variables for deletion
    vi, vm = copy.deepcopy(vd), copy.deepcopy(vd)  # Viterbi variables for insertion and match

    vm[0][0] = 0
    vi[0][0] = vd[0][0] = -float("inf")
    for i in range(1, n_x):
        vm[i][0] = vd[i][0] = -float("inf")

    for j in range(1, n_hmm):
        vm[0][j] = vi[0][j] = -float("inf")

    for i in range(n_x):
        for j in range(n_hmm):
            if j != 0:
                vd_new = max(
                    vm[i][j - 1] + a_log[m_d][j - 1],
                    vi[i][j - 1] + a_log[i_d][j - 1],
                    vd[i][j - 1] + a_log[d_d][j - 1],
                )
                vd[i][j] = round(vd_new, precision)

            if i != 0:
                vi_new = math.log(e_insert[x[i]][j] / q[x[i]]) + max(
                    vm[i - 1][j] + a_log[m_i][j],
                    vi[i - 1][j] + a_log[i_i][j],
                    vd[i - 1][j] + a_log[d_i][j],
                )
                vi[i][j] = round(vi_new, precision)

            if i != 0 and j != 0:
                vm_new = math.log(e_match[x[i]][j] / q[x[i]]) + max(
                    vm[i - 1][j - 1] + a_log[m_m][j - 1],
                    vi[i - 1][j - 1] + a_log[i_m][j - 1],
                    vd[i - 1][j - 1] + a_log[d_m][j - 1],
                )
                vm[i][j] = round(vm_new, precision)

    return ViterbiMatrices(vm=vm, vi=vi, vd=vd)


def test_viterbi_borodovskiy():
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
    result = viterbi(x=x, q=q, a=a, e_match=e_match, e_insert=e_insert)

    print("vm")
    pprint(result.vm)
    print("vd")
    pprint(result.vd)
    print("vi")
    pprint(result.vi)

    expected = ViterbiMatrices(
        vm=[
            [0, None, None, None],
            [None, +0.866, -3.662, -3.291],
            [None, -4.210, -0.530, -1.041],
            [None, -5.095, -0.836, -0.252],
            [None, -5.247, -0.125, -2.381],
            [None, -5.291, -3.014, +0.569]
        ],
        vd=[
            [None, None, None, None],
            [None, -3.293, -0.849, -2.235],
            [None, -4.179, -1.136, -2.523],
            [None, -5.065, -1.829, -3.139],
            [None, -6.355, -4.007, -2.427],
            [None, -7.241, -5.779, -3.313]
        ],
        vi=[
            [None, None, None, None],
            [-2.185, -3.679, -4.680, -5.373],
            [-3.070, +0.473, -2.012, -2.705],
            [-3.956, -0.220, -2.299, -2.993],
            [-5.247, -2.397, -3.321, -2.737],
            [-6.132, -4.169, -2.204, -2.897]
        ]
    )
    acceptable_err = 5 * 1e-2

    for i in range(len(expected.vm)):
        for j in range(len(expected.vm[0])):
            for mtx, expected_mtx in ((result.vm, expected.vm), (result.vd, expected.vd), (result.vi, expected.vi)):
                if expected_mtx[i][j] is not None:
                    assert abs(expected_mtx[i][j] - mtx[i][j]) < acceptable_err
