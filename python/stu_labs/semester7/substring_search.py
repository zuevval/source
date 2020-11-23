import random
from timeit import timeit
from typing import Callable, Any


def random_string(n: int, seed: int = 0) -> str:
    random.seed(seed)
    return "".join(random.choice("AGTC") for _ in range(n))


def find1(p, text):
    for ind in range(len(text) - len(p) + 1):
        t = text[ind: ind + len(p)]
        if p == t:
            return ind


def find2(p, text):
    for ind_t in range(len(text) - len(p) + 1):
        for ind_p in range(len(p)):
            if p[ind_p] != text[ind_t + ind_p]:
                break
        else:
            return ind_t


# def rabin_karp(p, text):
#     h = my_hash(p) # O(p)
#     for ind_t in range(len(text) - len(p) + 1):
#         ht = rehash(state)
#         if ht == hp:
#            ...

def my_timeit(f: Callable[[None], Any]):
    t = timeit(f, number=1000)
    print("average execution time: " + str(t))


def main():
    p = random_string(10, 0)
    text = random_string(10 ** 4, 1) + p

    my_timeit(lambda: find1(p, text))
    my_timeit(lambda: find2(p, text))


if __name__ == "__main__":
    main()
