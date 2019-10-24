def feasible_match(rmap2, rmap1):
    mult = 0.02
    res = abs(sum(rmap1) - sum(rmap2))
    std_dev = sum([(mult*elem)**2 for elem in rmap2])
    res /= std_dev ** 0.5
    return res


def init_align_mtx(nrow, ncol):
    res = [[0] * ncol for _ in range(nrow)]
    for irow in range(nrow):
        res[irow][0] = float('inf')
    for icol in range(ncol):
        res[0][icol] = float('inf')
    res[0][0] = 0
    return res


class ScoreInfo:
    rmap = []
    ref = []
    scores = [[]]  # matrix
    s = 0 # row index
    t = 0  # column index. Need to calculate score[s][t]
    miss_penalty = 0.0
    delta = 0

def score_candidates(sc_info):
    res = []
    for irow in range(max(0, sc_info.s - sc_info.delta), sc_info.s):
        ref = sc_info.ref[irow:sc_info.s]
        for icol in range(max(0, sc_info.t - sc_info.delta), sc_info.t):
            query = sc_info.rmap[icol:sc_info.t]
            hi_sq = feasible_match(ref, query) ** 2
            miss = sc_info.miss_penalty * (sc_info.s + sc_info.t - (irow + icol))
            res.append(hi_sq + miss + sc_info.scores[irow][icol])
    return res


def align(rmap, ref, miss_penalty, delta):
    nrow, ncol = len(ref) + 1, len(rmap) + 1
    sc_info = ScoreInfo
    sc_info.scores = init_align_mtx(nrow, ncol)
    sc_info.miss_penalty, sc_info.delta = miss_penalty, delta
    sc_info.rmap, sc_info.ref = rmap, ref
    for sc_info.s in range(1, nrow):
        for sc_info.t in range(1, ncol):
            candidates = score_candidates(sc_info)
            sc_info.scores[sc_info.s][sc_info.t] = min(candidates)
    return sc_info.scores[nrow-1][ncol-1]


if __name__ == '__main__':
    rmap = [22.98, 2.93, 1.87, 27.14, 10.69, 6.49]
    ref = [23.13, 3.03, 1.78, 27.13, 3.06, 7.29, 23.93]
    miss_penalty = -1
    delta = 2
    print(align(rmap, ref, miss_penalty, delta))