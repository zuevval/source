import numpy as np
from scipy.stats import norm
from scipy import integrate


def response(heritability: float, pheno_sd: float, proportion: float) -> float:
    dist = norm(loc=0, scale=pheno_sd)
    boundary = dist.ppf(1 - proportion)
    s = integrate.quad(lambda x: x * dist.pdf(x), boundary, np.inf)[0]
    return s * heritability / proportion


def main():
    for heritability, sigma_sq, p in (
            (.37, 10.7, .25),
            (.37, 10.7, .5),
            (.37, 10.7, .75),
            (.18, 1.7, .1),
            (.22, 4.3, .3)
    ):
        sigma = np.sqrt(sigma_sq)
        print("h^2:{}, var_pheno: {}, p: {}".format(heritability, sigma_sq, p))
        print(response(heritability=heritability, pheno_sd=sigma, proportion=p))


if __name__ == "__main__":
    main()
