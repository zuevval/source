from Bio.Align import substitution_matrices


def gap_penalty(skipped_acids: int):
    gap_start_penalty = 12
    gap_continuation_penalty = 2
    return gap_start_penalty + (skipped_acids - 1) * gap_continuation_penalty


def calc_score(seq_top: str, seq_bottom: str, skip_char="-") -> int:
    assert len(seq_top) == len(seq_bottom), "only strings of the same length may form a valid alignment"

    subst_mtx = substitution_matrices.load('BLOSUM50')

    result = 0
    skipped_acids: int = 0
    for top, bot in zip(seq_top, seq_bottom):
        if (top, bot) in subst_mtx:
            if skipped_acids > 0:  # gap ended
                result -= gap_penalty(skipped_acids)
            result += subst_mtx[(top, bot)]
            skipped_acids = 0
        else:  # continue or start gap
            assert top == skip_char or bot == skip_char, \
                "invalid alignment: pair is neither in matrix nor contains missed acid"
            skipped_acids += 1
    if skipped_acids > 0:  # if alignment ended within a gap
        result -= gap_penalty(skipped_acids)
    return result


def test_simple():
    top = "GSAQ"
    bot = "NNPE"
    assert abs(calc_score(top, bot) - 2) < 1e-9  # G-N: 0, S-N: 1, A-P: -1, Q-E: 2


def test_with_gap():
    top = "V---D"
    bot = "LQVTG"
    assert abs(calc_score(top, bot) - -16) < 1e-9  # V-L: 1, D-G: -1


def human_to_lupin() -> int:
    top = "GSAQVKGHGKKVADALTNAVAHV---D-DMPNALSALSDLHAHK"
    bot = "NNPELQAHAGKVFKLVYEAAIQLQVTGWVTDATLKNLGSVHVSK"
    return calc_score(top, bot)


def human_to_nematode() -> int:
    top = "GSAQVKGHGKKVADALTNAVAHVDDMPNALSALSD----LHAHK"
    bot = "GSGYLVGDSLTFVDLL--VAQHTADLLAANAALLDEFPQFKAHQ"
    return calc_score(top, bot)


if __name__ == "__main__":
    test_simple()
    test_with_gap()
    print(str(human_to_lupin()) + ": human alpha-globin aligned to lupin leghemoglobin")
    print(str(human_to_nematode()) + ": human alpha-globin aligned to nematode glutathione-s-transferase")
