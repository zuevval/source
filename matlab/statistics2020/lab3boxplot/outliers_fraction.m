% `vec` - column vector of real numbers
function D =  outliers_fraction(vec)
n = size(vec, 1);
x_1_4 = vec(floor(0.25*n));
x_3_4 = vec(ceil(0.75*n));
x1 = 0.5*(5*x_1_4 - 3*x_3_4);
x2 = 0.5*(5*x_3_4 - 3*x_1_4);
n_outliers = 0;
for x = vec'
    if (x < x1) || (x > x2)
        n_outliers = n_outliers + 1;
    end
end
D = n_outliers / n;
end