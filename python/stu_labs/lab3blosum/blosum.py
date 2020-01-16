"""
BLOSUM matrix - multiple DNA sequences alignment
"""
import os
from typing import List
from collections import defaultdict


def mylog(msg):
    print(msg)


def parse_alignments(filename: str) -> List[str]:
    word_idx = 1  # index of word in each string to be included in result
    res = []
    with open(filename) as fin:
        for line in fin:
            words = line.strip().split()
            if len(words) < word_idx + 1:
                mylog('can\'t parse short line: ' + line + '\n in file' + filename)
                continue
            res.append(words[word_idx])
    return res


def extract_alignments(filepath: str, extension: str) -> List[str]:
    dir_separator = '/'
    file_separator = '.'
    res = []
    for root, dirs, files in os.walk(filepath):
        for filename in files:
            if filename.split(file_separator)[-1] != extension:
                continue
            # if 'filename' ends with '.<extension>'...
            filepath = root + dir_separator + filename
            res.extend(parse_alignments(filepath))
    return res


def align_alignments(alignments: List[str]):
    '''
    'alignments': list of strings of different length
    Makes strings of the same length (=maxlen of initial strings) by
    completing inputs with proper number of <gap_symbol>'s
    '''
    gap_symbol = '-'
    lengths = tuple(map(len, alignments))
    maxlen = max(lengths)
    for idx, strlen in enumerate(lengths):
        diff = maxlen - strlen
        if diff > 0:
            alignments[idx] += (gap_symbol * diff)


def mono_char_col(alignments: List[str], icol: int, max_mismatch: int) -> bool:
    '''
    determines whether a column consists of characters of the same type.
    Another characters in a quantity no more than 'max_mismatch' are allowed.
    '''
    letters_count = defaultdict(int)
    for row in alignments:
        letters_count[row[icol]] += 1
    if max_mismatch >= len(alignments) - max(letters_count.values()):
        return True
    return False


def mono_char_cols(alignments: List[str], max_mismatch:int):
    for col in range(len(alignments[0])):
        print(mono_char_col(alignments, col, max_mismatch))


if __name__ == '__main__':
    alignments = extract_alignments('./alignments/', 'txt')
    align_alignments(alignments)
    mono_char_cols(alignments, 3)
