from .classifier import laplace_function


def test_laplace_function():
    abs_tol = 1e-3
    assert abs(laplace_function(0) - .5) < abs_tol
    assert abs(laplace_function(.10) - (.07966 + .5)) < abs_tol
