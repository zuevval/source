from random import uniform, seed


def is_valid_triangle(x, y):
    x, y = min(x, y), max(x, y)
    a, b, c = x, y - x, 1 - y
    return a + b >= c and a + c >= b and b + c >= a


def has_long_middle(x, y):
    return abs(x - y) >= .5


def main():  # it's just a rough estimate, a test
    n = 20000
    seed(0)
    n_triangles = n_long_middle = 0
    for _ in range(n):
        x = uniform(0, 1)
        y = uniform(0, 1)
        n_triangles += int(is_valid_triangle(x, y))
        n_long_middle += int(has_long_middle(x, y))
    print(n_triangles / n)
    print(n_long_middle / n)


if __name__ == "__main__":
    main()
