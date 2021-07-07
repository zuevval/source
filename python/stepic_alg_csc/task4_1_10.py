import sys
from typing import Sequence, Iterator, Tuple


def fractional_knapsack(knapsack_capacity: int, values_and_weights: Sequence[Tuple[int, int]]) -> int:
    # 5.3.3 - the same using `heapq.heapify` (it's better when there are a lot of items and small knapsack )
    order = sorted([(value / weight, weight) for value, weight in values_and_weights], reverse=True)

    acc = 0
    for v_per_w, w in order:
        if w >= knapsack_capacity:
            acc += v_per_w * knapsack_capacity
            break
        acc += v_per_w * w
        knapsack_capacity -= w
    return acc


def main(use_stdin: bool):
    with sys.stdin if use_stdin else open("practice5_3_data/knapsack.txt") as fin:
        # input() # slower than `sys.stdin`, but many advantages for interactive input
        reader: Iterator = (tuple(map(int, line.split())) for line in fin)
        _, knapsack_capacity = next(reader)
        values_and_weights = list(reader)
    opt_value = fractional_knapsack(knapsack_capacity, values_and_weights)
    print("{:.3f}".format(opt_value))


if __name__ == "__main__":
    main(use_stdin=False)


def test_fractional_knapsack():
    for capacity, v_and_w, expected_ans in [
        (0, [(60, 20)], 0),
        (25, [(60, 20)], 60),
        (25, [(60, 20), (0, 100)], 60),
        (25, [(60, 20), (50, 50)], 60 + 5)
    ]:
        assert fractional_knapsack(capacity, v_and_w) == expected_ans
