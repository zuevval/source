"""
documentation in MAIN
"""

def doc(func):
	"""
	decorator for 'func'
	prints name, doc and module
	"""
	print(__name__)
	print(__doc__) #  documentation in MAIN (if __name__ == "main")
	print(func.__doc__)
	print(func.__name__)
	return func

@doc
def f():
	"f: prints 'f' to standard output"
	print("f")

f()


