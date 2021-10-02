# https://towardsdatascience.com/structural-equation-modeling-dca298798f4d

import pandas as pd
import semopy


def main():
    data = pd.read_csv("towardsdatascience/SemData.csv")
    model_spec = """
    JobPerf =~ ClientSat + SuperSat + ProjCompl # latent =~ measured1 + ...
    Social =~ PsychTest1 + PsychTest2
    Intellect =~ YrsEdu + IQ
    Motivation =~ HrsTrn + HrsWrk
    JobPerf ~ Social + Intellect + Motivation # latent1 ~ latent2 + ...
    
    # measured1 ~~ measured2
    """
    model = semopy.Model(model_spec)
    model.fit(data=data)
    print(model.inspect())


if __name__ == "__main__":
    main()
    # "C:\Python39\python.exe" -m cProfile -o out.profile towardsdatascience.py && "C:\Python39\python.exe" -m tuna out.profile # `snakeviz` may be used instead of `tuna`

