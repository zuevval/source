function Y = rk2rang (X, f, F, y0, yDeriv0)
g = @(z)(z);
X1 = X(1):h:X(end); %dense net
Y1 = zeros(size(X1));
Y1(1) = y0;
Z1 = zeros(size(X));
Z1(1) = yDeriv0;
for i = 1:1:size(X1, 2)-1
    n1i = f(X1(i), Y1(i));
    n2i = f(X1(i) + h/2, Y1(i) + (h/2)*n1i);
    n3i = f(X1(i) + h/2, Y1(i) + (h/2)*n2i);
    n4i = f(X1(i) + h, Y1(i) + h*n3i);
    dyi = (h/6)*(n1i+2*n2i+2*n3i+n4i);
    Y1(i+1) = Y1(i) + dyi; 
    %Y1(i+1) = Y1(i) + h*f(X1(i), Y1(i)); %simple Euler's method
end
end