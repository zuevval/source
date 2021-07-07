from typing import List


def max_terms(n: int) -> List[int]:
    term = 1
    terms = []
    while n > 2 * term:
        terms.append(term)
        n -= term
        term += 1
    terms.append(n)
    return terms


def main():
    n = int(input())
    terms = max_terms(n=n)
    print(len(terms))
    print(*terms)


def test_max_terms():
    cases = [(1, 1), (6, 3), (10, 4), (25, 6)]
    for n, expected_k in cases:
        terms = max_terms(n)
        assert len(terms) == expected_k
        assert sum(terms) == n


if __name__ == "__main__":
    main()
