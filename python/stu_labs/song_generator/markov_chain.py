from collections import defaultdict
import random
import re
from typing import List, DefaultDict, Tuple


def words(text: str) -> list:
    # words_list = text.strip().lower().split()
    words_list = text.lower().split()  # TODO compare with/without `strip`. Somehow linebreaks are ignored
    res = [re.sub("[{}?!;:.,]", '', line) for line in words_list]
    """
    :param text: raw text
    :return: 'text' as a list of words without punctuation symbols
    """
    return res


def transition_matrix(words_seq: List[str]) -> DefaultDict[Tuple[str], List[str]]:
    res = defaultdict(list)
    for iword in range(len(words_seq) - 2):  # TODO check what happens if words_seq is of len 1
        key = (words_seq[iword], words_seq[iword + 1])
        value = words_seq[iword + 2]
        res[key].append(value)
    return res


def random_word(words_seq: List[str]):
    return random.choice(words_seq)


def markov_chain(words_seq: List[str], transition_mtx: DefaultDict[Tuple[str], List[str]], maxlen: int) -> list:
    res = [random_word(words_seq), random_word(words_seq)]
    while len(res) < maxlen:
        key = (res[-2], res[-1])
        res.append(random_word(transition_mtx.get(key, words_seq)))
    return res


def snoop_says(filename: str, maxlen: int):
    with open(filename, encoding="UTF-8") as fin:
        txt = fin.read()
        w = words(txt)
        tm = transition_matrix(w)
        generated = markov_chain(w, tm, maxlen)
        print(" ".join(generated))


if __name__ == "__main__":
    snoop_says("short_test.txt", 10)