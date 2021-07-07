def fib_remainders_demo(n: int) -> None:
    i_fib, fib_prev, fib = 1, 0, 1
    print()
    k = 6
    print("idx \t  fib " + " ".join(["\t %{}".format(i) for i in range(2,k+1)]))
    while i_fib < n:
        print(("{:02d}: \t {:06d} " + "\t {}" * (k-1)).format(i_fib, fib, *[fib % i for i in range(2,k+1)]))
        i_fib, fib_prev, fib = i_fib + 1, fib, fib_prev + fib


def fib_mod(n: int, m: int) -> int:
    """
    @return: (n-th Fibonacci number) % m
    """
    fib_remainders = [0, 1]
    while len(fib_remainders) < n + 1:
        fib_remainders.append((fib_remainders[-2] + fib_remainders[-1]) % m)
        if fib_remainders[-1] == 1 and fib_remainders[-2] == 0:
            return fib_remainders[n % (len(fib_remainders) - 2)] % m
    return fib_remainders[n]


def main():
    n, m = map(int, input().split())
    print(fib_mod(n, m))


if __name__ == "__main__":
    main()


def test_fib_mod():
    fib_remainders_demo(31)
    assert fib_mod(10, 2) == 1
    assert fib_mod(9, 3) == 1
    assert fib_mod(10, 17) == 4
    assert fib_mod(30, 1) == 0

    assert fib_mod(6, 2) == 0
    assert fib_mod(29, 3) == 2
    assert fib_mod(29, 4) == 1
    assert fib_mod(29, 5) == 4
    assert fib_mod(29, 6) == 5
