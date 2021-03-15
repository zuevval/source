from python.stats_multidim.lab2pca.classifier import classify
from python.stats_multidim.lab2pca.dataloader import load_german


def main():
    data = load_german()
    classify(data, "german")


if __name__ == "__main__":
    main()
