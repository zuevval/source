import matplotlib.pyplot as plt
import numpy as np
from math import cos, sin


def h(omega: float) -> complex:
    return cos(2 * omega) - .5 * cos(omega) - .5 + 1j * (sin(2 * omega) - .5 * sin(omega))


def main():
    plt.figure()
    omegas = np.linspace(0, np.pi)
    hs = np.array([h(omega) for omega in omegas])
    x, y = hs.real, hs.imag
    plt.plot(x, y)
    plt.grid()
    plt.savefig("nyquist_example.png")


if __name__ == "__main__":
    main()
