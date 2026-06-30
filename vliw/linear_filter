def linear_filter(*xs):
    """
    Input: first word N (length of array), then N values of X.
    Output: N values of Y where Y[i] = 3*X[i] + 2*X[i-1] + X[i-2]
    with X[-1] = X[-2] = 0
    (so Y[0] = 3*X[0], Y[1] = 3*X[1] + 2*X[0]).
    """
    n = xs[0]
    x = list(xs[1 : n + 1])

    result = []
    for i in range(n):
        x_i = x[i]
        x_i1 = x[i - 1] if i >= 1 else 0
        x_i2 = x[i - 2] if i >= 2 else 0
        y_i = 3 * x_i + 2 * x_i1 + x_i2
        result.append(y_i)

    return result


assert linear_filter(0) == []
assert linear_filter(1, 5) == [15]
assert linear_filter(2, 5, 10) == [15, 40]
assert linear_filter(3, 1, 2, 3) == [3, 8, 14]
assert linear_filter(5, 1, 2, 3, 4, 5) == [3, 8, 14, 20, 26]
