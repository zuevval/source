from python.stepik_stats.task2_7_8 import laplace_probab

def main():
    n = 900
    print(round(laplace_probab(lo=110, hi=n, n=n, p=.1), 3))

if __name__ == "__main__":
    main()
