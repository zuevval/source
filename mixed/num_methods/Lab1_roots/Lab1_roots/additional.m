syms x;
y = 1.8.*(x.^2)-sin(10.*x)
vpa(subs(y, x, 0.25))
vpa(subs(y, x, 0.5))
vpa(subs(y, x, 0.375))
vpa(subs(y, x, 0.3125))
vpa(subs(y, x, 0.28125))
vpa(subs(y, x, 0.35))