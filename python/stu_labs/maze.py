import queue
'''
Find the way out of a maze
and print it step-by-step.
The maze n*m is given in a text file
symbols:
# - wall
<space> - empty cell
* - starting point (must be only one)
'''

from enum import Enum
class cell_t (Enum):
	EMPTY = ' '
	WALL = '#'
	START = '*'
	PATH = 'o'
	VISITED = 'x'

class maze:
	field = []
	nrows = 0
	ncols = 0
	startx = -1
	starty = -1


def read_maze (filename):
	res = maze()
	with open (filename) as fin:
		for line_i, line in enumerate(fin):
			maze.field.append(list(line.strip()))
			if res.starty == -1:
				res.startx = line_i
				res.starty = line.find((cell_t.START.value))
	print('res.startx = '+ str(res.startx) + ' , res.starty= ' + str(res.starty))
	# TODO check whether all lines are of the same length
	# TODO check whether starting point is singular
	res.nrows = len(res.field)
	res.ncols = len(res.field[0])
	return res

def find_path(mz):
	q = queue.Queue()
	q.put([mz.startx, mz.starty])
	while not q.empty():
		point = q.get()
		on_border = point[0] == 0 or point[1] == 0
		on_border |= (point[0] == mz.nrows - 1)
		on_border |= (point[1] == mz.ncols - 1)
		if on_border:
			print(point)
			break
		next_points = []
		next_points.append([point[0]+1,point[1]])
		next_points.append([point[0]-1,point[1]])
		next_points.append([point[0],point[1]-1])
		next_points.append([point[0],point[1]+1])
		deadend = True
		for next in next_points:
			if mz.field[next[0]][next[1]] == cell_t.EMPTY.value:
				#  mark cell as part of path
				mz.field[next[0]][next[1]] = cell_t.PATH.value
				#  push cell into queue to visit later
				q.put(next)
				#  point is not a dead end
				deadend = False
		if deadend:
			#mark cell as visited
			mz.field[point[0]][point[1]] = cell_t.VISITED.value

def print_maze(mz):
	pass

mz = read_maze('maze1.txt')
find_path(mz)

for row in mz.field:
	for elem in row:
		print(elem, end = "")
	print('')

