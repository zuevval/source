import pytest
from stu_labs.semester7.sv_search import search_chr, search_chromosome
from .testing_utils import Case, check, visualize

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
    Case(name="no answer (noncontroversial conditions)",
         sv_bounds=[(1, 10), (1, 10), (1, 10), (1, 10)],
         k_conditions_pairs=[(1, 2), (3, 4)],
         l_conditions_pairs=[(1, 3)],
         solution_exists=False),
    Case(name="controversial conditions",
         sv_bounds=[(1, 3), (1, 3), (1, 3), (1, 3), (4, 5)],
         k_conditions_pairs=[(1, 2), (3, 3)],
         l_conditions_pairs=[(1, 2)],
         solution_exists=False),
    Case(name="no constraints",
         sv_bounds=[(2, 5)],
         k_conditions_pairs=[],
         l_conditions_pairs=[]),
    Case(name="K constraints only",
         sv_bounds=[(2, 5), (5, 7)],
         k_conditions_pairs=[(1, 1), (1, 2), (2, 2)],
         l_conditions_pairs=[]),
    Case(name="L constraints only",
         sv_bounds=[(2, 5), (5, 7), (6, 7), (4, 6), (1, 3), (1, 4)],
         k_conditions_pairs=[],
         l_conditions_pairs=[(1, 3), (2, 4), (5, 6)]),
    Case(name="one possible answer",
         sv_bounds=[(1, 2), (2, 7), (9, 11), (12, 15), (12, 14), (7, 11), (9, 15)],
         k_conditions_pairs=[(2, 7), (3, 4)],
         l_conditions_pairs=[(1, 2), (4, 5), (3, 6)])
]


@pytest.mark.parametrize('case', SEARCH_CHR_TEST_CASES, ids=str)
def test_search_chr(case: Case) -> None:
    answer = search_chr(case.sv_bounds, case.k_conditions_pairs, case.l_conditions_pairs)
    check(case, answer)


@pytest.mark.parametrize('case', SEARCH_CHROMOSOME_TEST_CASES, ids=str)
def test_search_chromosome(case: Case) -> None:
    answer = search_chromosome(case.sv_bounds, case.k_conditions_pairs, case.l_conditions_pairs)
    check(case, answer)
    visualize(case, answer, "out/test_search_chromosome.txt")
