function [j, X, Y] = trapeziumIntegral(f, a, b, n)
h = (b-a)/(n-1);
X = a:h:b;
Y = f(X);
j=0;
for y=Y
    j = j + y; 
end
j = j*h;
end