from collections import defaultdict
from enum import Enum
from dataclasses import dataclass
from typing import List, DefaultDict, Set, Tuple


class ConditionType(Enum):
    K = 'a or b'
    L = 'not (a and b)'


@dataclass
class Condition:
    _cond_type: ConditionType
    a_idx: int  # index of variable `a` in sv_truth_list
    b_idx: int

    def is_true(self, sv_truth_list: List[bool]):
        assert self.a_idx < len(sv_truth_list) and self.b_idx < len(sv_truth_list), "index out of bounds"
        if self._cond_type == ConditionType.K:
            return sv_truth_list[self.a_idx] or sv_truth_list[self.b_idx]
        return not (sv_truth_list[self.a_idx] and sv_truth_list[self.b_idx])


def search_chromosome(sv_bounds: List[Tuple[int, int]], k_conditions_pairs: List[Tuple[int, int]],
                      l_conditions_pairs: List[Tuple[int, int]]) -> int:
    n_svs = len(sv_bounds)  # assuming that enumeration starts from 0
    n_chromosomes = max(interval[1] for interval in sv_bounds) + 1  # assuming that enumeration starts from 0
    conditions = [Condition(ConditionType.K, a_i, b_i) for a_i, b_i in k_conditions_pairs]
    conditions.extend([Condition(ConditionType.L, a_i, b_i) for a_i, b_i in l_conditions_pairs])
    n_conditions = len(conditions)
    sv_affects_conditions: DefaultDict[int, Set[int]] = defaultdict(set)
    for cond_idx, cond in enumerate(conditions):
        for sv_idx in [cond.a_idx, cond.b_idx]:
            sv_affects_conditions[sv_idx].add(cond_idx)
    sv_starts: DefaultDict[int, List[int]] = defaultdict(list)
    sv_stops: DefaultDict[int, List[int]] = defaultdict(list)
    for sv_idx, sv_interval in enumerate(sv_bounds):
        sv_starts[sv_interval[0]].append(sv_idx)
        sv_stops[sv_interval[1] + 1].append(sv_idx)
    sv_truth_list = [True if idx in sv_starts[0] else False for idx in range(n_svs)]

    true_conditions = [c.is_true(sv_truth_list) for c in conditions]
    n_true_conditions = sum(true_conditions)
    if n_true_conditions == n_conditions:
        return 0  # chromosome 0 is a possible answer
    for chr_idx in range(1, n_chromosomes):
        for sv_start_idx in sv_starts[chr_idx]:
            sv_truth_list[sv_start_idx] = True
        for sv_stop_idx in sv_stops[chr_idx]:
            sv_truth_list[sv_stop_idx] = False
        recalc_cond_ids = set()
        for sv_idx in [*sv_starts[chr_idx], *sv_stops[chr_idx]]:
            recalc_cond_ids = recalc_cond_ids.union(sv_affects_conditions[sv_idx])
        for cond_idx in recalc_cond_ids:
            new_cond_value = conditions[cond_idx].is_true(sv_truth_list)
            if new_cond_value is True and not true_conditions[cond_idx]:
                n_true_conditions += 1
            if new_cond_value is False and true_conditions[cond_idx]:
                n_true_conditions -= 1
            true_conditions[cond_idx] = new_cond_value
        if n_true_conditions == n_conditions:
            return chr_idx
    return -1


def main():
    sv_bounds = [(0, 2), (1, 9), (2, 4), (7, 8)]
    k_conditions_pairs = [(0, 1), (2, 3)]
    l_conditions_pairs = [(0, 2)]
    print(search_chromosome(sv_bounds, k_conditions_pairs, l_conditions_pairs))


if __name__ == "__main__":
    main()
