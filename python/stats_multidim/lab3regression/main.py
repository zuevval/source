from pathlib import Path

import matplotlib.pyplot as plt  # type: ignore

import numpy as np  # type: ignore
from scipy import stats


class RegressionModel:
    def __init__(self, x: np.array, y: np.array, title: str):
        self.inv_xx = np.linalg.inv(x.T @ x)
        self.a = self.inv_xx @ x.T @ y
        self.y_hat = x @ self.a
        self.x, self.y, self.name = x, y, title


def visualize_3d(model: RegressionModel, out_path: Path) -> None:
    for color, title in ((model.y, "real"), (model.y_hat, "predicted")):
        fig = plt.figure()
        ax = fig.add_subplot(111, projection="3d")
        ax.scatter(model.x[:, 0], model.x[:, 1], model.x[:, 2], c=color)
        plt.title("linear regression: {}".format(title))
        plt.savefig(out_path / "data_3d_{}.png".format(title))


def build_model(data_dir: Path, out_dir: Path) -> RegressionModel:
    x = np.loadtxt(data_dir / "X.txt")
    y = np.loadtxt(data_dir / "y7.txt")[:,6]
    model = RegressionModel(x, y, "initial")
    print_matrix(model.a.T, var_name="a")

    out_dir.mkdir(exist_ok=True)
    visualize_3d(model=model, out_path=out_dir)

    return model


def print_matrix(a: np.array, var_name: str) -> None:
    print(var_name + " =")
    np.set_printoptions(precision=3)
    print(a)
    print("")  # empty line


def perform_analysis(model: RegressionModel) -> np.array:
    """
    Calculates a set of statistics for a given linear regression model
    @param model: RegressionModel object to be studied
    @return: indices of factors which may be equal to zero (for significance level 0.1)
    """
    n, m = model.x.shape
    sum_errs2 = sum((model.y - model.y_hat) ** 2)
    s2 = sum_errs2 / (n - m)
    print("s^2 = {:.3f}".format(s2))

    cov_a = s2 * model.inv_xx
    print_matrix(cov_a, var_name="cov(a)")

    s_a = np.diag(cov_a) ** .5
    print_matrix(s_a, var_name="standard deviation of `a`")

    ixx_diag = np.array([np.diag(model.inv_xx)])
    corr_a = model.inv_xx / np.sqrt(ixx_diag.T @ ixx_diag)
    print_matrix(corr_a, var_name="corr(a)")

    sum_y2_centered = sum((model.y - np.mean(model.y)) ** 2)
    r2 = 1 - sum_errs2 / sum_y2_centered
    print("R^2 = {:.4f}".format(r2))
    r2n = 1 - (sum_errs2 / (n - m)) / (sum_y2_centered / (n - 1))
    print("R_n^2 = {:.4f}".format(r2n))

    gamma = .95
    quantile = stats.t(n - m).ppf((1 + gamma) / 2)
    a_confidence_intervals = np.array([model.a - s_a * quantile, model.a + s_a * quantile])
    print_matrix(a_confidence_intervals.T,
                 var_name="confidence intervals for `a` with confidence level {}".format(gamma))

    joint_alpha = (1 - gamma) / m
    joint_quantile = stats.t(n - m).ppf((1 + joint_alpha) / 2)
    a_joint_conf_intervals = np.array([model.a - s_a * joint_quantile, model.a + s_a * joint_quantile])
    print_matrix(a_joint_conf_intervals.T,
                 var_name="joint confidence intervals for `a` with confidence {}".format(gamma))

    # testing hypotheses: a_i ?= 0
    zero_hypot_statistics = np.abs(model.a) / s_a
    print_matrix(zero_hypot_statistics, var_name="statistics for hypothesis a_i = 0 (t_alpha={})".format(quantile))
    return (zero_hypot_statistics < quantile).nonzero()[0]


def make_prediction(model: RegressionModel) -> None:
    # exclude the last sample and calculate forecast for it
    incomplete_model = RegressionModel(model.x[:-1, :], model.y[:-1], "incomplete")
    new_x, new_y = model.x[-1, :], model.y[-1]
    new_y_hat = incomplete_model.a @ new_x
    print("prediction for excluded sample: {:.1f}".format(new_y_hat))
    print("answer for excluded sample: y={:.1f} ".format(new_y))

    n, m = incomplete_model.x.shape
    sum_errs2 = sum((model.y - model.y_hat) ** 2)
    s2 = sum_errs2 / (n - m)
    new_y_hat_s = s2 * (new_x.T @ incomplete_model.inv_xx @ new_x + 1)
    print("estimate of variance of excluded sample prediction: {:.2f}".format(new_y_hat_s))

    gamma = 0.95
    quantile = stats.t(n - m).ppf((1 + gamma) / 2)
    print("confidence interval (gamma={}): [{:.1f}, {:.1f}]".format(gamma, new_y_hat - quantile, new_y_hat + quantile))


def main():
    out_dir = Path("out")
    model_init = build_model(Path("data"), out_dir)
    maybezero_ids = perform_analysis(model=model_init)
    make_prediction(model_init)

    models = [(model_init, "None")]
    for factor_id in list(maybezero_ids) + list(np.array([maybezero_ids])):
        reduced_x = np.delete(model_init.x, factor_id, axis=1)
        reduced_model = RegressionModel(reduced_x, model_init.y, "reduced")
        print("\n reduced model: removed feature(s) No. {} \n".format(factor_id))
        perform_analysis(reduced_model)
        make_prediction(reduced_model)
        models.append((reduced_model, str(np.array(factor_id) + 1)))

    model_refined = models[2][0]  # removed feature 4
    model_refined.name = "refined"

    plt.figure()
    t = np.arange(len(model_init.y))
    for model in (model_init, model_refined):
        plt.plot(t, model.y_hat, label="prediction (model: {})".format(model.name))
    plt.plot(model.y, label="ground truth values")
    plt.legend()
    plt.xlabel("index of sample")
    plt.ylabel("response")
    plt.title("responses from different models compared with ground truth values")
    plt.savefig(out_dir / "models_comparison_line.png")

    for model in (model_init, model_refined):
        residuals = model.y - model.y_hat
        plt.figure()
        plt.violinplot(residuals, showmedians=True, vert=False)
        plt.title("residuals distribution")
        plt.yticks([])
        plt.scatter(residuals, np.ones(shape=residuals.shape), c="black")
        plt.savefig(out_dir / "residuals_hist_{}.png".format(model.name))


if __name__ == "__main__":
    main()
