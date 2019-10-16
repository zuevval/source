def decorator(*args):
	print("decorator")
	for arg in args:
		print("arg: "+arg)
	def real_decorator(func):
		print("real_decorator")
		def wrapper(*args, **kwargs):
			print("wrapper:start")
			func(*args,**kwargs)
			print("wrapper:end")
		return wrapper
	return real_decorator


print("___________________________")
print("define func1 with decorator")
print("___________________________")

@decorator("decorator called via @")
def func1(str):
	print("func1")
	print("str: " + str)


print("___________________________")
print("call decorator's result directly  (pass decorated func1)")
print("___________________________")

decorator("decorator called directly")(func1("hello func1"))
