from collections import defaultdict, deque
from typing import DefaultDict, Union, NewType, List, Set

Vertex = NewType('Vertex', Union[int, str])


def sorting(graph: DefaultDict[Vertex, List[Vertex]], root_vertices: Set[Vertex]) -> List[Set[Vertex]]:
    visited: List[Set[Vertex]] = []
    for v in root_vertices:
        visited.append(dfs(v, graph))
    return visited


def dfs(start: Vertex, graph: DefaultDict[Vertex, List[Vertex]]) -> Set[Vertex]:
    q = deque([start])
    visited = set()
    while q:
        v = q.pop()
        for u in graph[v]:
            if u not in visited:
                q.append(u)
                visited.add(u)
    return visited


def dfs_with_repeats(start: Vertex, graph: DefaultDict[Vertex, List[Vertex]]) -> List[Vertex]:
    q = deque([start])
    visited = [start]
    while q:
        v = q.pop()
        for u in graph[v]:
            q.append(u)
            visited.append(u)
    return visited


def test_trivial():
    graph = defaultdict(list)
    graph[0] = []
    graph[1] = [0]
    graph[2] = [1, 0]
    graph[3] = [0]
    print(sorting(graph, {2, 3}))
    assert dfs_with_repeats(2, graph) == [2, 1, 0, 0]
