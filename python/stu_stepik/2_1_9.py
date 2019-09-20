def curry(f, *args):
    def g (*other_args):
        return f(*args, *other_args)
    return g
