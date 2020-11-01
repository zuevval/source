import numpy as np
from Bio.Align import substitution_matrices


def scores_pairwise(ref: str, seq: str):
    """
    :return: scores for aligning each reference amino acid to each amino acid of our sequence `seq`
    """
    subst_mtx = substitution_matrices.load('BLOSUM50')
    res = np.empty([len(seq), len(ref)])
    for c_idx, c in enumerate(seq):
        res[c_idx] = [subst_mtx[(r, c)] for r in ref]
    return res


if __name__ == "__main__":
    print(scores_pairwise("VGAHAGEYGA","VNVEEAGG"))
