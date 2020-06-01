rng default;
x = -1.8:0.2:2;
y = 2 + 2*x;
y1 = y + randn(size(x));
[b1, a1, br1, ar1] = regression_fit(x, y1, y, 'normal disturbance');

y2 = y1;
y2(1) = y2(1) + 10;
y2(end) = y2(end) - 10;
[b2, a2, br2, ar2] = regression_fit(x, y2, y, 'huge disturbances in 1st and last points');
