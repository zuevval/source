from pathlib import Path
from typing import List, Tuple, Union
from dataclasses import dataclass


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


def check_conditions(case: Case, chr_id: int) -> bool:
    min_possible_id = 1 if case.indices_start_from_1 else 0
    max_possible_id = max(right_bound for _, right_bound in case.sv_bounds)
    if not case.indices_start_from_1:
        max_possible_id -= 1
    assert min_possible_id <= chr_id <= max_possible_id
    sv_truth_list = [True if l_bound <= chr_id <= r_bound else False for l_bound, r_bound in case.sv_bounds]
    if case.indices_start_from_1:
        sv_truth_list.insert(0, False)  # add dummy zeroth value
    res = True
    for ak, bk in case.k_conditions_pairs:
        res &= sv_truth_list[ak] or sv_truth_list[bk]
    for al, bl in case.l_conditions_pairs:
        res &= not (sv_truth_list[al] and sv_truth_list[bl])
    return res


def check(case: Case, answer: int) -> None:
    if case.solution_exists:
        assert check_conditions(case, answer)
    else:
        assert answer == -1


def stringify(x: int) -> str:
    """ assuming x < 100 for pretty formatting"""
    res = str(x) + "|"
    if x < 10:
        res = "0" + res
    return res


def visualize(case: Case, answer: int, out_filename: Union[str, Path, None] = None) -> None:
    assert case.indices_start_from_1, "we visualize only sets of SV where indices start from 1"
    max_chr_idx = max(stop for _, stop in case.sv_bounds)
    lines: List[str] = [
        "\n--- " + str(case) + " ---",
        "   " + "".join(["▓▓|" if check_conditions(case, idx) else "  |" for idx in
                         range(1, max_chr_idx + 1)]) + " -> possible answers",
        "   " + "".join([stringify(idx) for idx in range(1, max_chr_idx + 1)]) + " -> chromosome index"
    ]
    for sv_idx, sv in enumerate(case.sv_bounds):
        sv_idx += 1
        lines.append(stringify(sv_idx) + "".join(
            ["██|" if sv[0] <= idx <= sv[1] else "  |" for idx in range(1, max_chr_idx + 1)]))
    if answer < 1:
        lines.append("answer: impossible")
    else:
        lines.append("ans" + "  |" * (answer - 1) + "▒▒|")
    lines.append("K conditions (a or b):   " + str(case.k_conditions_pairs))
    lines.append("L conditions (not(a&b)): " + str(case.l_conditions_pairs))

    if out_filename:
        out_filename = Path(out_filename)
        out_filename.parent.mkdir(exist_ok=True)
        with open(str(out_filename), "a", encoding="utf-8") as file_out:
            file_out.writelines([line + "\n" for line in lines])
    else:
        for line in lines:
            print(line)


if __name__ == "__main__":
    visualize(Case(name="basic",
                   sv_bounds=[(1, 3), (2, 10), (3, 5), (8, 9)],
                   k_conditions_pairs=[(1, 2), (3, 4)],
                   l_conditions_pairs=[(1, 3)]), answer=4, out_filename="out/visualize_example.txt")
