D = -diag(diag(M));
D = D^(-1);
M1 = D*M;
b1 = D*b;
linsolve(M1,b1)
C = M1+E;
g = -b1;
nC = norm(C, inf);
eps1 = (1-nC)/nC*eps;
xk = g;
xk1 = C*xk+g;
while abs(xk - xk1) > eps1
    xk = xk1;
    xk1 = C*xk+g;
end
format compact
display(xk1, 'xk1')
linsolve(M,b)