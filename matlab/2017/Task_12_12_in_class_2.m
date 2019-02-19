%task 11.9: minimal value of function from task 10.2
disp('task 11.9')
syms x y(x) dy(x) d2y(x)
y(x) = x^x;
dy(x) = diff(y(x));
d2y(x) = diff(dy(x));
x0=solve(dy(x)==0)
%checking that second derivative is positive in x0
display(vpa(d2y(x0), 2), '2nd derivative in x0');

figure
hold on
title('x^x')
fplot(y)
plot(x0,y(x0),'*')
xlim([0 1])
ylim([0 1])
text(double(x0), double(f(x0))-0.6, 'e\^-1,e\^(exp(-1))\cdot cos^2(e\^(-1))')