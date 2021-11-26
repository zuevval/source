import numpy as np
import semopy
from semopy.effects import EffectMA, EffectStatic


def example_model():
    ex = semopy.examples.example_article
    desc, data = ex.get_model(), ex.get_data()
    print(desc)
    print(data.head())

    m = semopy.Model(description=desc)
    r = m.fit(data=data, obj="FIML")  # TODO fix in the article: method="FIML": err
    print(r)
    print(m.inspect())

    params = ex.get_params()
    mape = np.mean(semopy.utils.compare_results(m, params))
    print("MAPE: " + str(mape * 100))

    semopy.semplot(mod=m,filename="model.png", plot_covs=True)


def example_generalized_effects():
    ex = semopy.examples.example_article
    desc = ex.get_model()
    data, (k1, k2) = ex.get_data(random_effects=2, moving_average=True)

    ef = [EffectStatic('group', k1), EffectStatic('group', k2), EffectMA('time', 2)]
    m = semopy.ModelGeneralizedEffects(desc, ef)  # TODO example from the article causes type mismatch warning!
    r = m.fit(data)

    params = ex.get_params()
    mape = np.mean(semopy.utils.compare_results(m, params))
    print("MAPE: " + str(mape * 100))


def main():
    example_model()

    #  "C:\Python39\python.exe" -m cProfile -o mgen_out.profile model_generalized_effects.py && "C:\Python39\python.exe" -m tuna mgen_out.profile


if __name__ == "__main__":
    main()
