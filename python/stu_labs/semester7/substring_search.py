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

def prefix_fun(s: str):  # naive prefix function (O(n^3))
    n = len(s)
    p = [0] * n
    for i in range(2, n):
        for k in range(i):
            if s[:k] == s[i - k:i]:
                p[i] = k
    return p


def prefix_fun2(s: str):
    n = len(s)
    p = [0] * n
    for i in range(2, n):
        k = p[i - 1]
        while k > 0 and s[k] != s[i]:
            k = p[k - 1]
        if s[i] == s[k]:
            k += 1
        p[i] = k
    return p


def find3(p, text):  # Knuth-Morris-Pratt # TODO
    yet_unused_symbol = "#"
    print(prefix_fun2(p + yet_unused_symbol + text))


def test_prefix_fun():
    assert prefix_fun("abcabcd") == [0, 0, 0, 0, 1, 2, 3]
    find3("cd", "abcabcd")


def my_timeit(f: Callable[[None], Any]):
    t = timeit(f, number=1000)
    print("average execution time: " + str(t))


def main():
    p = random_string(10, 0)
    text = random_string(10 ** 4, 1) + p

    my_timeit(lambda: find1(p, text))
    my_timeit(lambda: find2(p, text))
    my_timeit(lambda: find3(p, text))


if __name__ == "__main__":
    main()
