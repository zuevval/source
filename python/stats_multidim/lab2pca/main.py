from typing import Dict, List

from pathlib import Path

from python.stats_multidim.lab2pca.classifier import classify
from python.stats_multidim.lab2pca.dataloader import load_german
from python.stats_multidim.lab2pca.pca import pca, cut_components, plot_explained_variance, normalize, MisclassProbab, \
    plot_misclass_probabs, plot_two_prcomps


def main():
    out_path = Path("out")
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


if __name__ == "__main__":
    main()
