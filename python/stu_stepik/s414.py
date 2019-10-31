import math
from collections import defaultdict


def get_ktuples(rmap, k):
    ktuples = defaultdict(list)
    for idx in range(0, len(rmap)-k + 1):
        ktuple = tuple(rmap[idx:idx+k])
        ktuples[ktuple].append(idx)
    return ktuples

def feasible_match(rmap1, rmap2):
    mult = 0.02
    res = sum(rmap1) - sum(rmap2)
    if res < 0:
        res *= -1
    std_dev = sum([(mult*elem)**2 for elem in rmap2])
    res /= math.sqrt(std_dev)
    return res

def get_locations(ref, query):
    ktuples = defaultdict(list)
    for k in range(len(query)-2,len(query)+1):
        morektuples = get_ktuples(ref,k)
        for key, value in morektuples.items():
            ktuples[key].append(value)
    #print(ktuples)
    c_sigm = 3
    res = set()
    for ktup in ktuples:
        #print(feasible_match(ktup, query))
        #print(ktup)
        #print(ktuples[ktup])
        if feasible_match(ktup, query) <= c_sigm:
            for offsets in ktuples[ktup]:
                #print((offset, len(ktup)))
                for offset in offsets:
                    res.add((offset, len(ktup)))
    return sorted(res)


def align(rmap, ref, miss_penalty, delta):
    print(get_locations(ref, rmap))

if __name__ == '__main__':
    rmap = [22.98, 2.93, 1.87, 27.14, 10.69, 6.49]
    ref = [23.13, 3.03, 1.78, 27.13, 3.06, 7.29, 23.93]
    align(rmap, ref, 0, 0)