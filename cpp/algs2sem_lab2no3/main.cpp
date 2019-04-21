#include"functions.h"
//TODO: make gtests
//TODO: check with valgrind

int process(std::istream &, std::ostream &);

int main() {

    std::ifstream in;
    in.open("input.txt");
    if (!in) {
        std::cerr << "oops, file not found";
        return 0;
    }
    int res = process(in, std::cout);
    in.close();
    return res;
}


int process(std::istream& in, std::ostream& out) {
    int n;
    out << "enter n (positive integer):" << std::endl;
    in >> n;
    if (n <= 1) {
        out << "moves impossible, field too small";
        return 0;
    }

    std::vector<std::vector<int>> A;
    A.resize(n);

    out << "enter matrix values one by one:" << std::endl;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            int tmp;
            in >> tmp;
            A[i].push_back(tmp);
        }
    }

    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++)
            out << A[i][j] << " ";
        out << std::endl;
    }
    out << std::endl;

    std::vector<std::vector<draughtMove>> P; //P[n-1][n] - path
    P.resize(n-1);
    std::vector<std::vector<int>> T; //T[n][n] - sums
    T.resize(n);
    calcMoves(n, A, T, P);
    printMoves(n, A, P, out);
    printMaxProfitPath(n, A, T, P, out);
    return 0;
}

