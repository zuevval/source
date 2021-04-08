from pathlib import Path

import matplotlib.pyplot as plt  # type: ignore

import numpy as np  # type: ignore
import array_to_latex as a2l  # pip install array-to-latex
from matplotlib import colors
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


def build_model(data_dir: Path, out_dir: Path) -> RegressionModel:
    x = np.loadtxt(data_dir / "X.txt")
    y = np.loadtxt(data_dir / "y.txt")
    model = RegressionModel(x, y)
    print_latex(model.a.T, var_name="a")

    out_dir.mkdir(exist_ok=True)
    visualize_3d(model=model, out_path=out_dir)

    return model


def print_latex(a: np.array, var_name: str) -> None:
    print(var_name + " =")
    a2l.to_ltx(a, frmt="{:.3f}")
    print("")  # empty line


def perform_analysis(model: RegressionModel) -> RegressionModel:
    """
    Calculates a set of statistics for a given linear regression model
    @param model: RegressionModel object to be studied
    @return: a new, reduced model with filtered factors (for significance level 0.1)
    """
    n, m = model.x.shape
    sum_errs2 = sum((model.y - model.y_hat) ** 2)
    s2 = sum_errs2 / (n - m)
    print("s^2 = {:.3f}".format(s2))

    cov_a = s2 * model.inv_xx
    np.set_printoptions(precision=3)
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
    print_latex(a_confidence_intervals.T, var_name="confidence intervals for `a` with confidence level {}".format(gamma))

    tau = np.sqrt(m / (1 - gamma))
    a_joint_conf_intervals = np.array([model.a - s_a * tau, model.a + s_a * tau])
    print_latex(a_joint_conf_intervals.T, var_name="joint confidence intervals for `a` with confidence {}".format(gamma))

    # testing hypotheses: a_i ?= 0
    zero_hypot_statistics = np.abs(model.a) / s_a
    print_latex(zero_hypot_statistics, var_name="statistics for hypothesis a_i = 0 (t_alpha={})".format(quantile))

    # building a new model
    x_reduced = model.x[:, zero_hypot_statistics > quantile]
    model_reduced = RegressionModel(x=x_reduced, y=model.y)
    return model_reduced


def make_prediction(model: RegressionModel) -> None:
    # exclude the last sample and calculate forecast for it
    incomplete_model = RegressionModel(model.x[:-1, :], model.y[:-1])
    new_x, new_y = model.x[-1, :], model.y[-1]
    new_y_hat = incomplete_model.a @ new_x
    print("prediction for excluded sample: {:.3f}".format(new_y_hat))
    print("answer for excluded sample: y={:.3f} ".format(new_y))

    n, m = incomplete_model.x.shape
    sum_errs2 = sum((model.y - model.y_hat) ** 2)
    s2 = sum_errs2 / (n - m)
    new_y_hat_s = s2 * (new_x.T @ incomplete_model.inv_xx @ new_x + 1)
    print("estimate of variance of excluded sample prediction: {:.3f}".format(new_y_hat_s))


def main():
    out_dir = Path("out")
    model = build_model(Path("data"), out_dir)
    reduced_model = perform_analysis(model=model)
    print("\n reduced model: \n")
    perform_analysis(reduced_model)

    make_prediction(model)
    make_prediction(reduced_model)

    plt.figure()
    t = np.arange(len(model.y))
    bar_width = .35
    plt.bar(t, model.y_hat - model.y, bar_width, label="$ \hat y - y $ (all features)")
    plt.bar(t + bar_width, reduced_model.y_hat - model.y, bar_width, label="$ \hat y - y $ (reduced features)")

    plt.legend()
    plt.xlabel("index of sample")
    plt.ylabel("deviation")
    plt.title("deviations of linear regression models")
    plt.savefig(out_dir / "models_comparison.png")


if __name__ == "__main__":
    main()
