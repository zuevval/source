from kernel_estimate import kx_factory


def test_kx_factory():
    kx = kx_factory(mu=1, x=.5, bandwidth=lambda _: 1, r=10)
    print(kx(5))
