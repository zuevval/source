from math import factorial, exp


def main():
    lam = .0001 * 100_000
    p_le6 = sum(lam ** k / factorial(k) for k in range(6)) * exp(-lam)
    print(round(1 - p_le6, 3))


if __name__ == "__main__":
    main()
