a0 = -1;
b0 = 1;
f = @(x, y)(x.^2 + 2.*x+y./(x+2));
y0 = 1.5; %Y(-1)
F = @(x)((x+2).*(x.^2./2+1));
n = 9; %number of points in Y array
m = 5; %number of iterations
h0 = (b0-a0)/(n-1);
X0 = a0:h0:b0;
Yprecize = F(X0);
Delta = zeros(m,n);
format compact
for i = 1:1:m
    h = (b0-a0)/(n-1);
    Y = rungeKutta(X0,h, f, y0);
    %Y = adams4(X0,h, f, y0);
    Delta(i, :) = Y - Yprecize;
    n = n * 2;
end