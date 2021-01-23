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
    Apply one filter defined by parameters w on a single slice (a_slice_prev) of the output activation
    of the previous layer.

    Arguments:
    a_slice_prev -- slice of input data of shape (f, f, n_C_prev)
    w -- Weight parameters contained in a window - matrix of shape (f, f, n_C_prev)
    b -- Bias parameters contained in a window - matrix of shape (1, 1, 1)

    Returns:
    a scalar value, result of convolving the sliding window (w, b) on a slice x of the input data
    """
    return np.sum(w * a_slice_prev + b)  # multiplication in NumPy is element-wise


def conv_forward(a_prev, weights, b, hparameters):
    """
    Implements the forward propagation for a convolution function

    Arguments:
    a_prev -- output activations of the previous layer, numpy array of shape (m, n_H_prev, n_W_prev, n_C_prev)
    weights -- Weights, numpy array of shape (f, f, n_C_prev, n_C)
    b -- Biases, numpy array of shape (1, 1, 1, n_C)
    hparameters -- python dictionary containing "stride" and "pad"

    Returns:
    z -- conv output, numpy array of shape (m, n_H, n_W, n_C)
    cache -- cache of values needed for the conv_backward() function
    """
    (m, n_H_prev, n_W_prev, n_C_prev) = a_prev.shape
    (f, _, _, n_C) = weights.shape
    stride, pad = hparameters["stride"], hparameters["pad"]

    # Compute the dimensions of the CONV output volume using the formula given above. Hint: use int() to floor
    n_H = (n_H_prev + 2 * pad - f) // stride + 1
    n_W = (n_W_prev + 2 * pad - f) // stride + 1

    z = np.zeros((m, n_H, n_W, n_C))
    a_prev_pad = zero_pad(a_prev, pad)

    for i in range(m):  # loop over the batch of training examples
        for h in range(n_H):  # loop over vertical axis of the output volume
            horiz_start = h * stride
            horiz_end = horiz_start + f
            for w in range(n_W):  # loop over horizontal axis of the output volume
                vert_start = w * stride
                vert_end = vert_start + f
                # Use the corners to define the (3D) slice of a_prev_pad
                a_slice_prev = a_prev_pad[i, horiz_start:horiz_end, vert_start:vert_end, :]
                for c in range(n_C):  # loop over channels (= #filters) of the output volume
                    # Convolve the (3D) slice with the correct filter w and bias b, to get back one output neuron
                    z[i, h, w, c] = conv_single_step(a_slice_prev, weights[:, :, :, c], b[:, :, :, c])

    # Save information in "cache" for the backprop
    cache = (a_prev, weights, b, hparameters)
    return z, cache


def pool_forward(a_prev: np.array, hparameters: dict, mode: str = "max"):
    """
    Implements the forward pass of the pooling layer

    Arguments:
    a_prev -- Input data, numpy array of shape (m, n_H_prev, n_W_prev, n_C_prev)
    hparameters -- python dictionary containing "f" and "stride"
    mode -- the pooling mode you would like to use, defined as a string ("max" or "average")

    Returns:
    a -- output of the pool layer, a numpy array of shape (m, n_h, n_w, n_c)
    cache -- cache used in the backward pass of the pooling layer, contains the input and hparameters
    """

    # Retrieve dimensions from the input shape
    (m, n_H_prev, n_W_prev, n_C_prev) = a_prev.shape

    # Retrieve hyperparameters from "hparameters"
    f = hparameters["f"]
    stride = hparameters["stride"]

    # Define the dimensions of the output
    n_h = 1 + (n_H_prev - f) // stride
    n_w = 1 + (n_W_prev - f) // stride
    n_c = n_C_prev

    # Initialize output matrix `a`
    a = np.zeros((m, n_h, n_w, n_c))

    for i in range(m):  # loop over the training examples
        for h in range(n_h):  # loop on the vertical axis of the output volume
            horiz_start = h * stride
            horiz_end = horiz_start + f
            for w in range(n_w):  # loop on the horizontal axis of the output volume
                vert_start = w * stride
                vert_end = vert_start + f
                for c in range(n_c):  # loop over the channels of the output volume
                    a_slice_prev = a_prev[i, horiz_start:horiz_end, vert_start:vert_end, c]
                    if mode == "max":
                        a[i, h, w, c] = np.max(a_slice_prev)
                    elif mode == "average":
                        a[i, h, w, c] = np.average(a_slice_prev)

    # Store the input and hparameters in "cache" for pool_backward()
    cache = (a_prev, hparameters)
    return a, cache
