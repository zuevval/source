from fractions import Fraction


def main():  # this is in fact a computationally costly approach, using Chebyshev's theorem would have been better
    days_in_year = 365
    for p_coinc in (Fraction(2, 3), Fraction(4, 5)):
        n, p_diff = 1, 1

        while 1 - p_diff < p_coinc:
            p_diff *= Fraction(days_in_year - n, days_in_year)
            n += 1

        print("probability of coincidence of two birthdays: {}".format(p_coinc))
        print("n_min: {}".format(n))


if __name__ == "__main__":
    main()
