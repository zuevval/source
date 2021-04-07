from pathlib import Path

import matplotlib.pyplot as plt  # type: ignore

import numpy as np  # type: ignore


def visualize_3d(x: np.array, y: np.array, a: np.array, out_path: Path) -> None:
    for color, title in ((y, "real"), (x @ a, "predicted")):
        fig = plt.figure()
        ax = fig.add_subplot(111, projection="3d")
        ax.scatter(x[:, 0], x[:, 1], x[:, 2], c=color)
        plt.title("linear regression: {}".format(title))
        plt.savefig(out_path / "data_3d_{}.png".format(title))


def reg_lsq(x: np.array, y: np.array) -> np.array:
    # least squares coefficients for linear regression
    return np.linalg.inv(x.T @ x) @ x.T @ y


def main():
    data_dir = Path("data")
    x = np.loadtxt(data_dir / "X.txt")
    y = np.loadtxt(data_dir / "y.txt")
    a = reg_lsq(x=x, y=y)
    print(a)

    out_path = Path("out")
    out_path.mkdir(exist_ok=True)
    visualize_3d(x=x, y=y, a=a, out_path=out_path)


if __name__ == "__main__":
    main()
