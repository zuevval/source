from pathlib import Path
from pprint import pprint
from typing import List, Union, Tuple
import random


def random_sub_alignment(lines: List[str], length: int) -> Tuple[List[str], List[str]]:
    fasta_comment_symbol = ">"
    result, sub_alignment = [], []
    random_index: Union[int, None] = None
    for line in lines:
        if len(line) and line[0] != fasta_comment_symbol:
            if random_index is None:
                random_index = random.randint(0, len(line) - length)
            result.append(line[random_index:random_index + length])
            sub_alignment.append(line[random_index:random_index + length])
        else:
            result.append(line)
    return result, sub_alignment


def parse_fasta(input_filename: str, output_filename: str, length: int = 30) -> None:
    with open(input_filename) as infile:
        lines = [line.strip() for line in infile.readlines()]
        result, sub_aln = random_sub_alignment(lines, length)
        pprint(sub_aln)
        while input("accept? y/n\n").strip().lower() != "y":
            result, sub_aln = random_sub_alignment(lines, length)
            pprint(sub_aln)
    result = [line + "\n" for line in result]
    out_file_path = Path(output_filename)
    out_file_path.parent.mkdir(parents=True, exist_ok=True)
    with open(out_file_path, "w") as outfile:
        outfile.writelines(result)


def main():
    for file_idx in range(1, 4):
        parse_fasta("data/proteins-aligned.fas", "data/out/proteins-aligned-" + str(file_idx) + ".fas")
        parse_fasta("data/seq-aligned-fixed.fas", "data/out/seq-aligned-" + str(file_idx) + ".fas")


if __name__ == "__main__":
    main()
