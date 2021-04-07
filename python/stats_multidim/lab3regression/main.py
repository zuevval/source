from pathlib import Path

import matplotlib.pyplot as plt  # type: ignore

import numpy as np  # type: ignore
import array_to_latex as a2l  # pip install array-to-latex
from scipy import stats


class RegressionModel:
    def __init__(self, x: np.array, y: np.array):
        self.inv_xx = np.linalg.inv(x.T @ x)
        self.a = self.inv_xx @ x.T @ y
        self.y_hat = x @ self.a
        self.x, self.y = x, y


def visualize_3d(model: RegressionModel, out_path: Path) -> None:
    for color, title in ((model.y, "real"), (model.y_hat, "predicted")):
        fig = plt.figure()
        ax = fig.add_subplot(111, projection="3d")
        ax.scatter(model.x[:, 0], model.x[:, 1], model.x[:, 2], c=color)
        plt.title("linear regression: {}".format(title))
        plt.savefig(out_path / "data_3d_{}.png".format(title))


def build_model() -> RegressionModel:
    data_dir = Path("data")
    x = np.loadtxt(data_dir / "X.txt")
    y = np.loadtxt(data_dir / "y.txt")
    model = RegressionModel(x, y)

    out_path = Path("out")
    out_path.mkdir(exist_ok=True)
    visualize_3d(model=model, out_path=out_path)

    return model


def print_latex(a: np.array, var_name: str) -> None:
    print(var_name + " =")
    a2l.to_ltx(a, frmt="{:.3f}")
    print("")  # empty line


def calc_statistics(model: RegressionModel) -> None:
    n, m = model.x.shape
    sum_errs2 = sum((model.y - model.y_hat) ** 2)
    s2 = sum_errs2 / (n - m)
    print("s^2 = {:.3f}".format(s2))

    cov_a = s2 * model.inv_xx
    np.set_printoptions(precision=3)
    print("cov(a) = ")
    print_latex(cov_a, var_name="cov(a)")

    s_a = np.diag(cov_a) ** .5
    print_latex(s_a, var_name="standard deviation of `a`")

    ixx_diag = np.array([np.diag(model.inv_xx)])
    corr_a = model.inv_xx / np.sqrt(ixx_diag.T @ ixx_diag)
    print_latex(corr_a, var_name="corr(a)")

    sum_y2_centered = sum((model.y - np.mean(model.y)) ** 2)
    r2 = 1 - sum_errs2 / sum_y2_centered
    print("R^2 = {:.4f}".format(r2))
    r2n = 1 - (sum_errs2 / (n - m)) / (sum_y2_centered / (n - 1))
    print("R_n^2 = {:.4f}".format(r2n))

    gamma = .9
    quantile = stats.t(n - m).ppf((1 + gamma) / 2)
    a_confidence_intervals = np.array([model.a - s_a * quantile, model.a + s_a * quantile])
    print_latex(a_confidence_intervals, var_name="confidence intervals for `a`")


def main():
    model = build_model()
    calc_statistics(model=model)


if __name__ == "__main__":
    main()
