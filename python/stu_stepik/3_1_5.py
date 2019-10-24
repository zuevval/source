from enum import Enum
from functools import partial


class Way(Enum):
    MID = 0
    LEFT = 1
    UP = 2
    

def init(rows, cols, gap_penalty=10):
    res = list()
    res.append([-icol * gap_penalty for icol in range(cols + 1)])
    row_appendix = [0.0 for _ in range(cols)]
    for irow in range(1,rows + 1):
        row = [-gap_penalty * irow]
        row.extend(row_appendix)
        res.append(row)
    return res


def get_new_score(up, left, middle,
                  matched, gap_penalty, match, mismatch):
    mid_score = middle + (match * matched + mismatch * int (not matched))
    left_score = left - gap_penalty
    up_score = up - gap_penalty
    if up_score >= max(left_score, mid_score):
        return up_score, Way.UP.value
    if left_score >= max(mid_score, up_score):
        return left_score, Way.LEFT.value
    if mid_score >= max(left_score, up_score):
        return mid_score, Way.MID.value


def get_alignment(top_seq, bottom_seq, came_from):
    # print(top_seq   )
    irow = len(came_from) - 1
    icol = len(came_from[irow]) - 1
    res_top = ''
    res_bottom = ''
    while irow >= 0 and icol >= 0:
        step = came_from[irow][icol]
        if step == Way.UP.value:
            res_top = top_seq[irow] + res_top
            res_bottom = '-' + res_bottom
            irow -= 1
        elif step == Way.MID.value:
            res_top = top_seq[irow] + res_top
            res_bottom = bottom_seq[icol] + res_bottom
            icol -= 1
            irow -= 1
        else:
            res_top = '-' + res_top
            res_bottom = bottom_seq[icol] + res_bottom
            icol -= 1

    if icol >= 0:
        res_top = '-'*(icol+1)+res_top
        res_bottom = bottom_seq[:icol+1] + res_bottom
    if irow >= 0:
        res_bottom = '-'*(irow+1)+res_bottom
        res_top = top_seq[:icol+1] + res_top
    return "{}\n{}".format(res_top, res_bottom)


def align(top_seq, bottom_seq, GapPenalty=10,
          Match=2, Mismatch=-1):
    new_score = partial(get_new_score, gap_penalty=GapPenalty, match=Match, mismatch=Mismatch)
    
    mtx = init(len(top_seq),len(bottom_seq), GapPenalty)
    came_from = []
    for irow in range(1, len(mtx)):
        came_from.append([])
        for icol in range(1, len(mtx[irow])):
            matched = int(top_seq[irow - 1] == bottom_seq[icol - 1])
            middle = mtx[irow - 1][icol - 1]
            left = mtx[irow][icol - 1]
            up = mtx[irow - 1][icol]
            mtx[irow][icol], imax = new_score(up, left, middle, matched)
            came_from[irow - 1].append(imax)
    score = mtx[-1][-1]
    sm = mtx
    #for row in sm:
    #    print(row)

    '''
    for row in sm:
        print(row)
    for row in came_from:
        for col in row:
            if col == Way.LEFT.value:
                print('<', end='')
            elif col == Way.UP.value:
                print('^',end='')
            else:
                print('#',end='')
        print('')
    '''

    aligns = get_alignment(top_seq, bottom_seq, came_from)
    return aligns, score


'''
top_seq = 'GCTTCCTTTTCGCGAGCGT'
bottom_seq = 'AAGATTTTAGATT'
print(align(top_seq, bottom_seq, 2.1393, 4.6378, -3.4524))

top_seq = 'AGTGTCGGCT'
bottom_seq = 'ACTTCTACCCCAGC'
print(align(top_seq, bottom_seq, 1.399, 2.2168, -4.4499))
'''

top_seq = 'GCTTCCTTTTCGCGAGCGT'
bottom_seq = 'AAGATTTTAGATT'
print(align(top_seq, bottom_seq, 2.1393, 4.6378, -3.4524))
