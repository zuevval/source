from dataclasses import dataclass
from typing import List, Tuple, Sequence


@dataclass
class DirectedEdge:
    v_from: int
    v_to: int
    cost: int


class PriorityQueue:
    heap: List[DirectedEdge]
    n: int

    @staticmethod
    def right_child(i: int) -> int:
        return 2 * i

    @staticmethod
    def left_child(i: int) -> int:
        return 2 * i + 1

    @staticmethod
    def parent(i: int) -> int:
        return i // 2

    def sift_down(self, i: int) -> None:
        min_elem_idx = i
        l, r = self.left_child(i), self.right_child(i)
        if l < self.n and self.heap[l].cost < self.heap[min_elem_idx].cost:
            min_elem_idx = l
        if r < self.n and self.heap[r].cost < self.heap[min_elem_idx].cost:
            min_elem_idx = r
        if i != min_elem_idx:
            self.heap[min_elem_idx], self.heap[i] = self.heap[i], self.heap[min_elem_idx]
            self.sift_down(min_elem_idx)

    def sift_up(self, i: int) -> None:
        p = self.parent(i)
        while i > 0 and self.heap[p].cost > self.heap[i].cost:
            self.heap[p], self.heap[i] = self.heap[i], self.heap[p]
            i, p = p, self.parent(p)

    def insert(self, elem: DirectedEdge):
        self.heap.append(elem)
        self.sift_up(self.n)
        self.n += 1

    def extract_min(self) -> DirectedEdge:
        result = self.heap[0]
        self.heap[0] = self.heap[self.n - 1]
        self.n -= 1
        if self.n > 1:
            self.sift_down(0)
        return result

    def change_priority(self, i, p):
        raise NotImplementedError  # TODO video: 09-nov-2020, time: 51:50

    def __init__(self, edges: Sequence[DirectedEdge]):
        self.heap = []
        self.n = 0
        for edge in edges:
            self.insert(edge)


def prim(edges: Sequence[DirectedEdge]) -> int:
    """
    Prim's algorithm for finding a Minimum Spanning Tree
    :param edges: graph in a form of directed weighted edges, weights - non-negative integers
    :return: cost of MST or -1 if it is impossible
    """
    raise NotImplementedError  # TODO


def test_priority_queue():
    # test static methods
    assert PriorityQueue.parent(5) == 2
    assert PriorityQueue.left_child(3) == 7
    assert PriorityQueue.right_child(3) == 6

    edges = [
        DirectedEdge(0, 1, 10),
        DirectedEdge(1, 2, 20),
        DirectedEdge(2, 0, 15),
    ]
    p = PriorityQueue(edges)
    assert p.extract_min().cost == 10
    assert p.extract_min().cost == 15
    assert p.extract_min().cost == 20
