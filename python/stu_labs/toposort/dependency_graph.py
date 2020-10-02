from typing import DefaultDict, List, Union

from .sorting import Vertex, dfs_with_repeats


class DependencyGraph:
    def __init__(self, graph=DefaultDict[Vertex, List[Vertex]], root_vertices: Union[List[Vertex], None] = None):
        if root_vertices is None:
            root_vertices = set()
        self.graph, self.root_vertices = graph, root_vertices

    def add(self, v: Vertex, dependencies: Union[List[Vertex], None] = None):
        assert v not in self.graph, "could not add vertex: already in the graph"
        if dependencies is None:
            dependencies = []
        for u in dependencies:
            if u in self.root_vertices:
                self.root_vertices.pop(u)
        self.root_vertices.add(v)

    def get_ordered(self, v: Vertex):
        assert v in self.graph, "graph does not contain this vertex"
        return reversed(dfs_with_repeats(v, self.graph))
