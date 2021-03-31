import matplotlib.pyplot as plt

import numpy as np
from pathlib import Path


def hj(omega: float):
    jw = 1j * omega
    return (0.01 * jw + 1) / (jw * (jw ** 2 + 16) * (0.008 * jw + 1) * (0.04 * jw + 1))


class Ac:
    """
    alpha closed | this could be implemented with an array, but named variables are more readable
    """
    a0 = 8
    a1 = 3000
    a2 = 2628
    a3 = 4800
    a4 = 40025
    a5 = 2500


def lienard_chipart():
    g = np.array(
        [[Ac.a1, Ac.a3, Ac.a5, 0, 0],
         [Ac.a0, Ac.a2, Ac.a4, 0, 0],
         [0, Ac.a1, Ac.a3, Ac.a5, 0],
         [0, Ac.a0, Ac.a2, Ac.a4, 0],
         [0, 0, Ac.a1, Ac.a3, Ac.a5]])
    for i in (2, 4):
        print("delta_{}".format(i))
        print(np.linalg.det(g[:i, :i]))


def alpha_closed(omega: float) -> complex:
    jw = 1j * omega
    return Ac.a0 * jw ** 5 + Ac.a1 * jw ** 4 + Ac.a2 * jw ** 3 + Ac.a3 * jw ** 2 + Ac.a4 * jw + Ac.a5


def mikhailov(img_dir: Path) -> None:
    omegas = [i / 10 for i in range(1000)]
    alphas = [alpha_closed(omega) for omega in omegas]
    x = [a.real for a in alphas]
    y = [a.imag for a in alphas]
    plt.plot(x, y)

    plt.grid()
    plt.xlabel("$ \Re \left[\\alpha_{closed}(j \omega) \\right] $")
    plt.ylabel("$ \Im \left[\\alpha_{closed}(j \omega)\\right] $")
    plt.title("Mikhailov plot")
    plt.savefig(img_dir / "mikhailov.png")

    plt.xlim(-0.5 * 10 ** 9, 0.3 * 10 ** 10)
    plt.ylim(-0.5 * 10 ** 7, 0.5 * 10 ** 8)
    plt.savefig(img_dir / "mikhailov_near0.png")

    plt.xlim(-1000, 900000)
    plt.ylim(-0.5 * 10 ** 4, 0.9 * 10 ** 5)
    plt.savefig(img_dir / "mikhailov_near_near0.png")

    plt.xlim(-1000, 10000)
    plt.ylim(-0.5 * 10 ** 4, 0.9 * 10 ** 5)
    plt.savefig(img_dir / "mikhailov_near_near_near0.png")


def h_open(omega: float) -> complex:
    jw = 1j * omega
    return 25 * (jw + 100) / (8 * jw * (jw ** 2 + 16) * (jw + 12.5) * (jw + 25))


def nyquist(img_dir: Path) -> None:
    n_points = 40
    omegas1 = np.linspace(.1, 3.98, num=n_points)
    omegas2 = np.concatenate((np.linspace(4.02, 8, n_points),
                              np.linspace(8, 25, n_points),
                              np.linspace(25, 200, n_points)))
    hs1, hs2 = (np.array([h_open(omega) for omega in omegas]) for omegas in (omegas1, omegas2))
    (hs1_x, hs1_y), (hs2_x, hs2_y) = ((hs.real, hs.imag) for hs in (hs1, hs2))

    ts1 = np.linspace(0, -np.pi / 2, n_points)
    arch1_radius = 1.5
    arch1_x, arch1_y = arch1_radius * np.cos(ts1), arch1_radius * np.sin(ts1)

    t2_start = np.arctan(hs1_y[-1] / hs1_x[-1])
    ts2 = np.linspace(t2_start + np.pi, t2_start, n_points)
    arch2_radius = np.sqrt(hs1_y[-1] ** 2 + hs1_x[-1] ** 2)
    (arch2_x, arch2_y) = arch2_radius * np.cos(ts2), arch2_radius * np.sin(ts2)

    x = np.concatenate((arch1_x, hs1_x, arch2_x, hs2_x))
    y = np.concatenate((arch1_y, hs1_y, arch2_y, hs2_y))
    plt.figure()
    plt.plot(x, y)
    for i in (10, 30, 39, 78, 90, 105, 120):
        plt.arrow(x[i], y[i], x[i + 1] - x[i], y[i + 1] - y[i], shape='full', lw=0, length_includes_head=True,
                  head_width=.1)
    plt.scatter(x=[-1], y=[0], s=40, c="red")

    plt.axis("equal")
    plt.grid()
    plt.xlabel("$ \Re \left[H(p) \\right] $")
    plt.ylabel("$ \Im \left[H(p)\\right] $")
    plt.title("Nyquist plot")
    plt.savefig(img_dir / "nyquist.png")


def main():
    img_dir = Path("img")
    img_dir.mkdir(exist_ok=True)
    lienard_chipart()
    mikhailov(img_dir)
    nyquist(img_dir)


if __name__ == "__main__":
    main()
