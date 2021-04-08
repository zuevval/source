import sympy as sp
import numpy as np
import array_to_latex as alt


def print_mtx(mtx: np.array, title: str) -> None:
    print("\n{}".format(title))
    alt.to_ltx(mtx, frmt="{:.4f}")


def retrieve_p(res: tuple) -> np.array:
    for res_p11, res_p12, res_p22 in res[1]:
        if res_p11 < 0:
            continue
        p = np.array([[res_p11, res_p12], [res_p12, res_p22]]).astype(float)
        if np.linalg.det(p) > 0:
            return p


def main():
    p11, p12, p22 = sp.symbols("p11 p12 p22")
    res = sp.solve([-16 * p12 ** 2 + 8 * p12 + 1,
                    p11 + 4 * p22 - 16 * p12 * p22,
                    2 * p12 - 16 * p22 ** 2 + 1 / 4], p11, p12, p22, set=True)
    p = retrieve_p(res)
    print_mtx(p, "p")

    b = np.array([[0], [1]])
    k = 16 * b.T @ p
    print_mtx(k, "k")

    x0 = np.array([[1], [9]])
    j_min = x0.T @ p @ x0
    print("j_min={:.4f}".format(float(j_min)))


if __name__ == "__main__":
    main()
