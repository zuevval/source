from typing import Dict, List

from pathlib import Path

from python.stats_multidim.lab2pca.classifier import classify, generate_data, visualize_3d
from python.stats_multidim.lab2pca.dataloader import load_german
from python.stats_multidim.lab2pca.pca import pca, cut_components, plot_explained_variance, normalize, MisclassProbab, \
    plot_misclass_probabs, plot_two_prcomps


def process_synthetic(out_path: Path) -> None:
    good_sample, good_sample_title = generate_data(), "well-separated"

    bad_means = [[.5] * 3, [-.5] * 3]
    bad_cov = [[1.5, 0, 0], [0, 1.5, 0], [0, 0, 1.5]]
    bad_sample, bad_sample_title = generate_data(bad_means, bad_cov), "poorly_separated"

    for sample, title in ((good_sample, good_sample_title), (bad_sample, bad_sample_title)):
        classify(sample=sample, title=title)
        visualize_3d(data=sample, out_path=out_path, title=title)

    (good_pca, _, _), (bad_pca, _, _) = pca(good_sample), pca(bad_sample)
    for sample, title in ((good_pca, good_sample_title), (bad_pca, bad_sample_title)):
        classify(sample=sample, title=title + "_pca")
        plot_two_prcomps(sample=sample, out_path=out_path, title=title)


def process_german(out_path: Path) -> None:
    data_raw = load_german()
    data_normalized = normalize(data_raw)
    misclass_probabs: Dict[str, List[MisclassProbab]] = {}
    n_components_range = range(1, 6)
    for data, title in ((data_raw, "german"), (data_normalized, "german_normalized")):
        misclass_probabs[title] = []
        classify(data, title=title)
        data_pcomp, s, _ = pca(data)
        for leave_components in n_components_range:
            p21, p12 = classify(cut_components(data_pcomp, leave_components=leave_components),
                                "{} with PCA: {} principal components".format(title, leave_components))
            misclass_probabs[title].append(MisclassProbab(p12=p12, p21=p21))

        plot_explained_variance(s, out_path=out_path, title=title)
        plot_two_prcomps(data_pcomp, out_path=out_path, title=title)
    plot_misclass_probabs(list(n_components_range), misclass_probabs, out_path=out_path)


def main():
    out_path = Path("out")
    process_synthetic(out_path=out_path)
    process_german(out_path=out_path)


if __name__ == "__main__":
    main()
