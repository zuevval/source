function Y = adams4(X, h, f, y0)
%X is vector of watch points, X = a:h0:b, h >= h0, h0/h in N (last - adviceable)
%e. g. suppose X = [-1 0 1], h = 0.5
%then you calculate solution Y1 on net X1 = [-1 -0.5 0 0.5 1]
%and output values Y only corresponding X points
X1 = X(1):h:X(end); %dense net
Y1 = zeros(size(X1));
Y1(1) = y0;
for i = 1:1:3 %boosting with RungeKutta
    n1i = f(X1(i), Y1(i));
    n2i = f(X1(i) + h/2, Y1(i) + (h/2)*n1i);
    n3i = f(X1(i) + h/2, Y1(i) + (h/2)*n2i);
    n4i = f(X1(i) + h, Y1(i) + h*n3i);
    dyi = (h/6)*(n1i+2*n2i+2*n3i+n4i);
    Y1(i+1) = Y1(i) + dyi; 
    %Y1(i+1) = Y1(i) + h*f(X1(i), Y1(i)); %simple Euler's method
end

for i = 4:1:size(X1, 2)-1
    f1 = f(X1(i), Y1(i));
    f2 = f(X1(i-1), Y1(i-1));
    f3 = f(X1(i-2), Y1(i-2));
    f4 = f(X1(i-3), Y1(i-3));
    dyi = (h/24)*(55*f1-59*f2+37*f3-9*f4);
    Y1(i+1) = Y1(i) + dyi; 
    %Y1(i+1) = Y1(i) + h*f(X1(i), Y1(i)); %simple Euler's method
end

sX = size(X, 2);
sX1 = size(X1, 2);
delta = round(sX1 / sX);
Y = zeros(size(X));

for i = 1:1:sX
    if delta*i <= sX1
        Y(i) = Y1(delta*(i-1)+1);
    else
        disp('out of bounds')
    end
    disp(delta)
end
end