from math import comb


def main():
    denominator = comb(52, 6)
    print("3 cards of 2 suits:")
    print("{}/{}".format(comb(4, 2) * comb(13, 3) ** 2, denominator))
    print("<=2 diamonds:")
    print("{}/{}".format(comb(39, 6) + comb(39, 5) * comb(13, 1) + comb(39, 4) * comb(13, 2), denominator))


if __name__ == "__main__":
    main()
