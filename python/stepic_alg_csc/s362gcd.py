import random as rand


def test_gcd(gcd, n_iter=10, max_divisor=1024, max_fraction=128):
    for i in range(n_iter):
        c = rand.randint(1, max_divisor)
        a = c * rand.randint(1, max_fraction)
        b = c * rand.randint(1, max_fraction)
        assert gcd(a, a) == gcd(a, 0) == a
        assert gcd(b, b) == gcd(b, 0) == b
        assert gcd(a, 1) == gcd(b, 1) == 1
        d = gcd(a, b)
        assert d >= c
        assert a % d == 0
        assert b % d == 0


def gcd(n, m):
    if m == 0:
        return n
    r = n % m
    if r == 0:
        return m
    return gcd(m, r)


def gcd2(a, b):
    while a and b:  # until a == 0 or b == 0
        a, b = b % a, a
    return max(a, b)  # if a == 0, return b; if b == 0, return a


if __name__ == '__main__':
    test_gcd(gcd)
    test_gcd(gcd2, max_divisor=100000)
