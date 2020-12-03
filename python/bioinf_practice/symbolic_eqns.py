from sympy import *


def main():
    w1, w2, w3, w4, w5, a = symbols("w1 w2 w3 w4, w5, a")

    res = solve([w1 + w2 - a, (w1 - w2) * w2 - a, ], w1, w2, set=True)  # just an example to ensure that everything's OK
    print(res)

    # this has been running for 3 h with no result, so I killed it
    # res = solve([(w1 + w5) * (w1 + w2 + w4 + w5) * (w1 + w2 + w3 + w5) * (w1 + w3 + w4 + w5) - a,
    #              (w2 + w3 + w4) * (w1 + w2 + w4 + w5) * (w1 + w2 + w3 + w5) * w2 - a,
    #              (w2 + w3 + w4) * (w1 + w2 + w3 + w5) * (w1 + w3 + w4 + w5) * w3 - a,
    #              (w2 + w3 + w4) * (w1 + w2 + w4 + w5) * (w1 + w3 + w4 + w5) * w4 - a,
    #              (w1 + w5) * (w1 + w2 + w4 + w5) * (w1 + w3 + w4 + w5) - a,
    #              ], w1, w2, w3, w4, w5, set=True)
    # print(res)


if __name__ == "__main__":
    main()
