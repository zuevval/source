import time
from s353fibonacci import fib3


def timed(f, *args, n_iter=100):
    accum = 0
    for i in range(n_iter):
        t0 = time.perf_counter()
        f(*args)
        t1 = time.perf_counter()
        accum += (t1-t0)
    return accum / n_iter


if __name__ == '__main__':
    print(timed(fib3, 800))

