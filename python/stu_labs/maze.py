'''
Find the way out of a maze
and print it step-by-step.
The maze n*m is given in a text file
symbols:
# - wall
<space> - empty cell
* - starting point (must be only one)
'''
'''
TODO - teacher's comments:
1. make class 'point'
2. split code into blocks - next_points(point), on_board(point)
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
	print('start = '+ str(res.startx) + ', ' + str(res.starty))
	# TODO check whether all lines are of the same length
	# TODO check whether starting point is singular
	res.nrows = len(res.field)
	res.ncols = len(res.field[0])
	return res

def print_field(field):
	for row in field:
		for elem in row:
			print(elem, end = "")
		print('')
	print('')

def find_path(mz):
	st = [] # stack
	st.append([mz.startx, mz.starty])
	while st:
		point = st.pop()
		#  mark cell as a part of path
		mz.field[point[0]][point[1]] = cell_t.PATH.value
		print_field(mz.field)

		on_border = point[0] == 0 or point[1] == 0
		on_border |= (point[0] == mz.nrows - 1)
		on_border |= (point[1] == mz.ncols - 1)
		if on_border:
			print('end = ' + str(point[0]) + ',' + str(point[1]))
			break

		next_points = []
		next_points.append([point[0]+1,point[1]])
		next_points.append([point[0]-1,point[1]])
		next_points.append([point[0],point[1]-1])
		next_points.append([point[0],point[1]+1])

		for next in next_points:
			if mz.field[next[0]][next[1]] == cell_t.EMPTY.value:
				#  push cell into stack to visit later
				st.append(next)

mz = read_maze('maze1.txt')
find_path(mz)
