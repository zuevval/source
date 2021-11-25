# GPS: Green seminar, task 2
# https://docs.google.com/document/d/1AFGfhQsG-LE7StH8PpYdPrC13OVDygqB1qYh84q2JTg/edit

import numpy as np
import matplotlib.pyplot as plt


def vis_data():
    parents = np.array([19, 18, 21, 22, 18])
    offspring = np.array([18, 21, 15, 23, 16])
    p_coeffs = np.polyfit(parents, offspring, 1)  # linear regression
    print(p_coeffs)

    plt.figure()
    plt.scatter(x=parents, y=offspring)
    plt.plot(parents, np.poly1d(p_coeffs)(parents), "--k")
    plt.xlabel("parents")
    plt.ylabel("offspring")
    plt.show()


def main():
    vis_data()


if __name__ == "__main__":
    main()
