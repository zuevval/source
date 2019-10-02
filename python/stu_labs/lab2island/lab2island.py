"""
input: matrix containing 0 and 1.
We may move step-by-step between cells which contain '1'
Island is a set of interconnected cells
Task: compute the quantity of islands
"""
"""
TODO rename 'i', 'j' (var names must be meaningful)
Explanation: I'm used to Java, where naming iterator as a single char is
a good practice (unlike in dynamically typed Python, where we have no cue
to which is the type of variable)
"""

from enum import Enum

class cell_t(Enum):
	ISLAND = 1
	WATER = 0
	VISITED = -1

class Maze:
	field = []
	def possible_neighbours(self, coord):
		"""
		return all neighbours in 'self.field'
		"""
		res = []
		i = coord.i
		j = coord.j

		if i > 0 : #  assume all rows of the same length
			res.append(Coord(i - 1, j))
		if coord.i + 1 < len(self.field):
			res.append(Coord(i + 1, j))
		if j > 0:
			res.append(Coord(i, j - 1))
		if j + 1 < len(self.field[i]):
			res.append(Coord(i, j + 1))
		return res

class Coord:
	i = 0
	j = 0
	def __init__(self,i,j):
		self.i = i
		self.j = j

def read_mtx (filename):
	res = Maze()
	with open(filename) as fin:
		for line in fin:
			row = [int(i) for i in line.strip()]
			print(row)
			res.field.append(row)
	return res

def bfs(maze, start):
	"""
	breadth first search in integer matrix 'maze.field'
	starting point is (start.i, start.j)
	marks all visited cells as cell_t.VISITED
	"""
	stack = []
	stack.append(start)
	while stack:
		cell = stack.pop()
		maze.field[cell.i][cell.j] = cell_t.VISITED.value
		for nbr in maze.possible_neighbours(cell):
			if maze.field[nbr.i][nbr.j] == cell_t.ISLAND.value:
				stack.append(nbr)

def count_islands(mtx):
	count = 0
	for i, row  in enumerate(mtx.field):
		for j in range(len(row)):
			if mtx.field[i][j] == cell_t.ISLAND.value:
				count += 1
				bfs(mtx, Coord(i, j))
	return count
mtx = read_mtx("input.txt")
print(count_islands(mtx))

