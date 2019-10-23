def counting(func):
	if type(func) == 'function':
		class Function:
			ncalls = 0
		res = Function()
		return res
	else:
		func.ncalls += 1
	return func.inner_func

@counting
def f():
	pass

print(f.ncalls)
f()
print(f.ncalls)
