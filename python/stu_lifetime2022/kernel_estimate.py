def kb_plus(mu: int, q: float, x: float) -> float:
    assert -1 <= q <= 1, f"`q` should be in [-1; 1], but {q} is passed"

    if mu == 0:
        return (2 / (1 + q) ** 3) * (3 * (1 - q) * x + 2 * (1 - q + q ** 2))
    if mu == 1:
        return (12 / (1 + q) ** 4) * (x + 1) * (x * (1 - 2 * q) + (3 * q ** 2 - 2 * q + 1) / 2)
    if mu == 2:
        return (15 / (1 + q) ** 5) * (x + 1) ** 2 * (q - x) * (
                2 * x * (5 * (1 - q) / (1 + q) - 1) + 3 * q - 1 + 5 * (1 - q) ** 2 / (1 + q))
    if mu == 3:
        return 70 / (1 + q) ** 7 * (x + 1) ** 3 * (q - x) ** 2 * (
                2 * x * (7 * (1 - q) / (1 + q) - 1) + 3 * q - 1 + 7 * (1 - q) ** 2 / (1 + q))

    raise ValueError(f"Wrong Mu value: {mu}")


def main():
    print(kb_plus(0, 0, 0.5))
    try:
        kb_plus(4, 0, 0.5)
    except Exception as e:
        print(e)


if __name__ == "__main__":
    main()
