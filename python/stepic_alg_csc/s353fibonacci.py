from functools import lru_cache


def fib(n):
    assert n >= 0
    fibs = [0, 1]
    for i in range(2, n + 1):
        fibs.append(fibs[i-1] + fibs[i-2])
    return fibs[n]


def memo(f):
    """
    decorator that creates local map 'cache' for function 'f' that stores its outputs
    :param f: function of one argument - positive integer n
    :return: decorated function
    """
    cache = {}

    def inner(n):
        if n not in cache:
            cache[n] = f(n)
        return cache[n]
    return inner

#  @memo
@lru_cache(maxsize=None)
def fib2(n):
    """
    Fibonacci numbers. Algorithm by Sergey Lebedev (https://github.com/superbobry)
    :param n: index in Fibonacci sequence (fib[0]=fib[1]=1)
    :return: value of Fibonacci[n]
    """
    assert n >= 0
    return n if n <= 1 else fib2(n-1) + fib2(n-2)


def fib3(n):
    f0, f1 = 0, 1
    for i in range(n-1):
        f0, f1 = f1, f0 + f1
    return f1


if __name__ == '__main__':
    print(fib(0))
    print(fib(8))
    print(fib2(300))
    print(fib3(8))
    print(fib3(8000))
