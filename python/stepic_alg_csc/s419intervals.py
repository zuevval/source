"""
Given a set of intervals, find a minimum set of points
so that each interval contains at least 1 point
input: n intervals [l; r]
output: set of points
"""
from typing import List, Tuple


def min_points(intervals: List[Tuple[int, int]]) -> List[int]:
    if not intervals:
        return []
    intervals.sort(key=lambda x: x[1])  # sort by right ends
    points = [intervals[0][1]]  # right end of the first interval
    while intervals:
        interval = intervals.pop(0)
        if interval[0] <= points[-1]:
            continue
        points.append(interval[1])
    return points


def test1():
    set_intervals = [(1, 3), (2, 4)]
    set_points = min_points(set_intervals)
    assert len(set_points) == 1
    assert set_points[0] == 3


def test2():
    set_intervals = [(2, 4), (1, 5), (3, 4), (3, 6), (2, 7), (5, 7), (3, 7)]
    set_points = min_points(set_intervals)
    assert len(set_points) == 2
    assert set_points[0] == 4
    assert set_points[1] == 7


if __name__ == "__main__":
    n = int(input().strip())
    intervals = []
    for _ in range(n):
        intervals.append(tuple(int(num) for num in input().strip().split()))
    points = min_points(intervals)
    print(len(points))
    for point in points:
        print(point, end=" ")
