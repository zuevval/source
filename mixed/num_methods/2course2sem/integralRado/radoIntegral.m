function j = radoIntegral(f, a0, b0, n)
A1 = 3/2;
A2 = 1/2;
t1 = -1/3;
t2 = 1;
h = (b0-a0)/(n-1);
X = a0:h:b0;
j=0;
format compact
for a = X(1:end-1)
    x1 = (2*a+h)/2 + h*t1/2;
    x2 = a + h; %x2 = b
    j = j + (A1*f(x1) + A2*f(x2))*h/2;
end
%for k = 1:1:(s(2)-1)
%    X(k)
%    x1 = (4/3)*(a0^3/h^2)+(4*a0^2/h+(8/3)*a0+h)*k+(4*a0+(4/3)*h)*k^2+(4/3)*h*k^3
%end