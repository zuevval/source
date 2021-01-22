import numpy as np


def zero_pad(x, pad):
    """
    Pad with zeros all images of the dataset x. The padding is applied to the height and width of an image,
    as illustrated in Figure 1.

    Argument:
    x -- python numpy array of shape (m, n_H, n_W, n_C) representing a batch of m images
    pad -- integer, amount of padding around each image on vertical and horizontal dimensions

    Returns:
    padded image of shape (m, n_H + 2*pad, n_W + 2*pad, n_C)
    """
    return np.pad(x, ((0, 0), (pad, pad), (pad, pad), (0, 0)))


def conv_single_step(a_slice_prev, w, b):
    """
    Apply one filter defined by parameters W on a single slice (a_slice_prev) of the output activation
    of the previous layer.

    Arguments:
    a_slice_prev -- slice of input data of shape (f, f, n_C_prev)
    w -- Weight parameters contained in a window - matrix of shape (f, f, n_C_prev)
    b -- Bias parameters contained in a window - matrix of shape (1, 1, 1)

    Returns:
    a scalar value, result of convolving the sliding window (W, b) on a slice x of the input data
    """
    return np.sum(w * a_slice_prev + b)  # multiplication in NumPy is element-wise
