"""
input: matrix containing 0 and 1.
We may move step-by-step between cells which contain '1'
Island is a set of interconnected cells
Task: compute the quantity of islands
"""

from enum import Enum
from dataclasses import dataclass

class cell_t(Enum):
	ISLAND = 1
	WATER = 0
	VISITED = -1

@dataclass
class Coord:
	irow: int
	icol: int

def possible_neighbours(maze, coord):
		"""
		return all neighbours in 'maze'
		"""
		res = []
		irow = coord.irow
		icol = coord.icol

		if irow > 0 : #  assume all rows of the same length
			res.append(Coord(irow - 1, icol))
		if coord.irow + 1 < len(maze):
			res.append(Coord(irow + 1, icol))
		if icol > 0:
			res.append(Coord(irow, icol - 1))
		if icol + 1 < len(maze[irow]):
			res.append(Coord(irow, icol + 1))
		return res

def read_mtx (filename):
	res = []
	with open(filename) as fin:
		for line in fin:
			row = [int(irow) for irow in line.strip()]
			print(row)
			res.append(row)
	return res

def bfs(maze, start):
	"""
	breadth first search in integer matrix 'maze'
	starting point is (start.irow, start.icol)
	marks all visited cells as cell_t.VISITED
	"""
	stack = [start]
	while stack:
		cell = stack.pop()
		maze[cell.irow][cell.icol] = cell_t.VISITED.value
		for nbr in possible_neighbours(maze, cell):
			if maze[nbr.irow][nbr.icol] == cell_t.ISLAND.value:
				stack.append(nbr)

def count_islands(mtx):
	count_isl = 0
	for irow, row  in enumerate(mtx):
		for icol in range(len(row)):
			if mtx[irow][icol] == cell_t.ISLAND.value:
				count_isl += 1
				bfs(mtx, Coord(irow, icol))
	return count_isl

mtx = read_mtx("input.txt")
print(count_islands(mtx))

