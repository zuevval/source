# TODO not working, fix wrong calculations & implement for sequnces with length > length of lists in dictionaries

from dataclasses import dataclass
from pprint import pprint
from typing import Dict, List, Optional
from numpy.ma import log


@dataclass
class VMatchParams:
    e_Mj_Xi: float
    q_Xi: float
    v_Mj1_i1: float  # v^M_{j-1}(i-1)
    v_Ij1_i1: float  # v^I_{j-1}(i-1)
    v_Dj1_i1: float  # v^D_{j-1}(i-1)
    a_Mj1Mj: float  # a_{M_{j-1} M_j}
    a_Ij1Mj: float  # a_{I_{j-1} M_j}
    a_Dj1Mj: float  # a_{D_{j-1} M_j}


def v_match(p: VMatchParams) -> float:
    return log(p.e_Mj_Xi / p.q_Xi) + max(p.v_Mj1_i1 + log(p.a_Mj1Mj),
                                         p.v_Ij1_i1 + log(p.a_Dj1Mj),
                                         p.v_Dj1_i1 + log(p.a_Ij1Mj))


@dataclass
class VInsertionParams:
    e_Ij_Xi: float
    q_Xi: float
    v_Mj_i1: float  # v^M_j(i-1)
    v_Ij_i1: float  # v^I_j(i-1)
    v_Dj_i1: float  # v^D_j(i-1)
    a_MjIj: float  # a_{M_j I_j}
    a_IjIj: float  # a_{I_j I_j}
    a_DjIj: float  # a_{D_j I_j}


def v_insertion(p: VInsertionParams) -> float:
    return log(p.e_Ij_Xi / p.q_Xi) + max(p.v_Mj_i1 + log(p.a_MjIj),
                                         p.v_Ij_i1 + log(p.a_IjIj),
                                         p.v_Dj_i1 + log(p.a_DjIj))


@dataclass
class VDeletionParams:
    v_Mj1_i: float  # v^M_{j-1}(i)
    v_Ij1_i: float  # v^I_{j-1}(i)
    v_Dj1_i: float  # v^D_{j-1}(i)
    a_Mj1Dj: float  # a_{M_{j-1} D_j}
    a_Ij1Dj: float  # a_{I_{j-1} D_j}
    a_Dj1Dj: float  # a_{D_{j-1} D_j}


def v_deletion(p: VDeletionParams) -> float:
    if p.a_Mj1Dj == p.a_Dj1Dj == p.a_Ij1Dj == 0:
        return -float("inf")
    return max(p.v_Mj1_i + log(p.a_Mj1Dj),
               p.v_Ij1_i + log(p.a_Ij1Dj),
               p.v_Dj1_i + log(p.a_Dj1Dj))


def compact(matrix: List[List[float]]):
    return [["{:.3f}".format(x) for x in row] for row in matrix]


def viterbi(x: str, q: Dict[str, float], a: Dict[str, List[float]], e_match, e_insert):
    # initialization
    n = len(x)
    v_m = [[0] + [-float("inf")] * (n - 1)] + [[-float("inf")] + [None] * (n - 1) for _ in range(n - 1)]
    v_i = [[-float("inf")] + [None] * (n - 1)] + [[0] + [None] * (n - 1) for _ in range(n - 1)]
    v_d: List[List[Optional[float]]] = [[-float("inf")] + [0] * (n - 1)] + [[None] * n for _ in range(n - 1)]
    x = "_" + x  # dummy zeroth value
    pprint(v_m)
    pprint(v_i)
    pprint(v_d)
    pprint(x)

    for i in range(1, n):
        xi = x[i]
        vi_params = VInsertionParams(e_Ij_Xi=e_insert[xi][0],
                                     q_Xi=q[xi],
                                     v_Mj_i1=v_m[0][i - 1],
                                     v_Ij_i1=v_i[0][i - 1],
                                     v_Dj_i1=v_d[0][i - 1],
                                     a_MjIj=a["MiIi"][0],
                                     a_IjIj=a["IiIi"][0],
                                     a_DjIj=a["DiIi"][0])
        v_i[0][i] = v_insertion(vi_params)
    pprint(v_i)
    for j in range(1, n):
        vd_params = VDeletionParams(v_Mj1_i=v_m[j - 1][0],
                                    v_Ij1_i=v_i[j - 1][0],
                                    v_Dj1_i=v_d[j - 1][0],
                                    a_Mj1Dj=a["MiDi1"][j - 1],
                                    a_Ij1Dj=a["IiDi1"][j - 1],
                                    a_Dj1Dj=a["DiDi1"][j - 1])
        v_d[j][0] = v_deletion(vd_params)
    pprint(v_d)

    for i in range(1, n):
        xi = x[i]
        for j in range(1, n):
            vi_params = VInsertionParams(e_Ij_Xi=e_insert[xi][j],
                                         q_Xi=q[xi],
                                         v_Mj_i1=v_m[j][i - 1],
                                         v_Ij_i1=v_i[j][i - 1],
                                         v_Dj_i1=v_d[j][i - 1],
                                         a_MjIj=a["MiIi"][j],
                                         a_IjIj=a["IiIi"][j],
                                         a_DjIj=a["DiIi"][j])
            pprint(vi_params)
            v_i[j][i] = v_insertion(vi_params)
            vd_params = VDeletionParams(v_Mj1_i=v_m[j - 1][i],
                                        v_Ij1_i=v_i[j - 1][i],
                                        v_Dj1_i=v_d[j - 1][i],
                                        a_Mj1Dj=a["MiDi1"][j - 1],
                                        a_Ij1Dj=a["IiDi1"][j - 1],
                                        a_Dj1Dj=a["DiDi1"][j - 1])
            v_d[j][i] = v_deletion(vd_params)
            vm_params = VMatchParams(e_Mj_Xi=e_match[xi][j],
                                     q_Xi=q[xi],
                                     a_Mj1Mj=a["MiMi1"][j - 1],
                                     a_Ij1Mj=a["IiMi1"][j - 1],
                                     a_Dj1Mj=a["DiMi1"][j - 1],
                                     v_Mj1_i1=v_m[j - 1][i - 1],
                                     v_Ij1_i1=v_i[j - 1][i - 1],
                                     v_Dj1_i1=v_d[j - 1][i - 1])
            v_m[j][i] = v_match(vm_params)

    pprint(compact(v_m))
    pprint(compact(v_d))
    pprint(compact(v_i))


def main():
    x = "GCCA"
    q = {"A": 0.3, "T": 0.3, "C": 0.2, "G": 0.2}
    a = {
        "MiIi": [1 / 11, 3 / 11, 1 / 10, 1 / 10],  # M_i -> I_{i+1}
        "MiDi1": [1 / 11, 2 / 11, 1 / 10, 0],  # M_i -> D_{i+1}
        "MiMi1": [9 / 11, 6 / 11, 8 / 10, 9 / 10],  # M_i -> M_{i+1}
        "IiIi": [1 / 3, 1 / 5, 1 / 3, 1 / 2],  # I_i -> I_i
        "IiMi1": [1 / 3, 3 / 5, 1 / 3, 1 / 2],
        "IiDi1": [1 / 3, 1 / 5, 1 / 3, 0],
        "DiDi1": [0, 1 / 3, 1 / 4, 0],
        "DiMi1": [0, 1 / 3, 1 / 2, 1 / 2],
        "DiIi": [0, 1 / 3, 1 / 4, 1 / 2],
    }
    e_match = {
        "A": [0, 1 / 4, 6 / 11, 1 / 12],
        "C": [0, 1 / 12, 1 / 11, 1 / 3],
        "G": [0, 7 / 12, 2 / 11, 1 / 2],
        "T": [0, 1 / 12, 2 / 11, 1 / 12],
    }
    e_insert = {
        "A": [1 / 4, 1 / 6, 1 / 4, 1 / 4],
        "C": [1 / 4, 3 / 6, 1 / 4, 1 / 4],
        "G": [1 / 4, 1 / 6, 1 / 4, 1 / 4],
        "T": [1 / 4, 1 / 6, 1 / 4, 1 / 4],
    }
    viterbi(x=x, q=q, a=a, e_match=e_match, e_insert=e_insert)


if __name__ == "__main__":
    main()
