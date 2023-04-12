#include <omp.h>
#include <iostream>
#include <vector>

void testParallel() {
#pragma  omp parallel default(none) shared(std::cout)
    {
        std::cout << omp_get_thread_num() << " out of " << omp_get_num_threads() << std::endl;
    }
}

void testParallelSingle() {
#pragma omp parallel default(none) shared(std::cout)
#pragma omp single
    {
        std::cout << "single: " << omp_get_thread_num() << " out of " << omp_get_num_threads() << std::endl;
    }
}

void testTasks() { // https://openmp.org/wp-content/uploads/sc13.tasking.ruud.pdf
    for (auto _ = 0; _ < 10; ++_)
#pragma omp parallel default(none) shared(std::cout)
#pragma omp single
    {
        std::cout << "A ";
#pragma omp task default(none) shared(std::cout)
        std::cout << "car ";
#pragma omp task default(none) shared(std::cout)
        std::cout << "race ";
#pragma omp taskwait
        std::cout << "is fun to watch!" << std::endl;
    }
}

void testTasksDepend() {
    int x = 0;
#pragma omp parallel default(none) shared(std::cout, x)
#pragma omp single
    {
#pragma omp task default(none) shared(std::cout, x) depend(inout: x)
        std::cout << x << std::endl; // End Of Line might be printed at the same time or after "x" is incremented

#pragma omp task default(none) shared(std::cout, x)  depend(in: x)
        x++;
    }
}

void testListDependencies() {
    std::vector v{1, 2, 2, 1};
#pragma omp parallel default(none) shared(v, std::cout)
#pragma omp single
    {
        for (int i = 0; i < v.size(); ++i) {
#pragma omp task depend(out: v[i]) default(none) shared(v) firstprivate(i)
            v[i] *= 5;
        }

#pragma omp task depend(iterator(j=0:v.size()), in: v[j]) default(none) shared(v, std::cout)
        std::cout << v[v.size() - 1] << std::endl;
    }
}

int main() {
//    testParallel();  // just prints a mess
//    testParallelSingle();  // a single print
//    testTasks(); // prints "car" and "race" in arbitrary order
//    testTasksDepend();  // prints 0; without dependencies specified, prints 0 or 1
    testListDependencies();
}
