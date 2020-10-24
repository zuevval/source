from typing import List, Tuple

import pytest
from dataclasses import dataclass

from .sv_search import search_chr, search_chromosome


@dataclass
class Case:
    name: str
    sv_bounds: List[Tuple[int, int]]
    k_conditions_pairs: List[Tuple[int, int]]
    l_conditions_pairs: List[Tuple[int, int]]
    indices_start_from_1: bool = True
    solution_exists: bool = True

    def __str__(self) -> str:
        return 'sv test / {}'.format(self.name)


SEARCH_CHR_TEST_CASES = [
    Case(name="basic", sv_bounds=[(0, 2), (1, 9), (2, 4), (7, 8)],
         k_conditions_pairs=[(0, 1), (2, 3)],
         l_conditions_pairs=[(0, 2)],
         indices_start_from_1=False)
]

SEARCH_CHROMOSOME_TEST_CASES = [
    Case(name="basic",
         sv_bounds=[(1, 3), (2, 10), (3, 5), (8, 9)],
         k_conditions_pairs=[(1, 2), (3, 4)],
         l_conditions_pairs=[(1, 3)]),
    Case(name="no answer",
         sv_bounds=[(1, 10), (1, 10), (1, 10), (1, 10)],
         k_conditions_pairs=[(1, 2), (3, 4)],
         l_conditions_pairs=[(1, 3)],
         solution_exists=False),
    Case(name="controversial conditions",
         sv_bounds=[(1, 3), (1, 3), (1, 3), (1, 3), (4, 5)],
         k_conditions_pairs=[(1, 2), (3, 3)],
         l_conditions_pairs=[(1, 2)],
         solution_exists=False)
]


def check_conditions(case: Case, chr_id: int) -> None:
    min_possible_id = 1 if case.indices_start_from_1 else 0
    max_possible_id = max(right_bound for _, right_bound in case.sv_bounds)
    if not case.indices_start_from_1:
        max_possible_id -= 1
    assert min_possible_id <= chr_id <= max_possible_id
    sv_truth_list = [True if l_bound <= chr_id <= r_bound else False for l_bound, r_bound in case.sv_bounds]
    if case.indices_start_from_1:
        sv_truth_list.insert(0, False)  # add dummy zeroth value
    for ak, bk in case.k_conditions_pairs:
        assert sv_truth_list[ak] or sv_truth_list[bk]
    for al, bl in case.l_conditions_pairs:
        assert not (sv_truth_list[al] and sv_truth_list[bl])


def check(case: Case, answer: int) -> None:
    if case.solution_exists:
        check_conditions(case, answer)
    else:
        assert answer == -1


@pytest.mark.parametrize('case', SEARCH_CHR_TEST_CASES, ids=str)
def test_search_chr(case: Case) -> None:
    answer = search_chr(case.sv_bounds, case.k_conditions_pairs, case.l_conditions_pairs)
    check(case, answer)


@pytest.mark.parametrize('case', SEARCH_CHROMOSOME_TEST_CASES, ids=str)
def test_search_chromosome(case: Case) -> None:
    answer = search_chromosome(case.sv_bounds, case.k_conditions_pairs, case.l_conditions_pairs)
    check(case, answer)
