"""
Continuous Knapsack: given a list of items with cost 'ci' and weight 'wi'
find combination of items (maybe only parts of them) that maximizes
a total cost but doesn't exceed a particular total weight ('capacity') of a knapsack
output: a total cost of items in a knapsack
"""
from typing import List, Tuple


def knapsack(items: List[Tuple[int, int]]) -> float:
    return .0


if __name__ == "__main__":
    n, capacity = tuple(int(x) for x in input().split())
    items_list = [tuple(int(x) for x in input().split()) for _ in range(n)]
    print(knapsack(items_list))
