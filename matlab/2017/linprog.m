options = optimoptions('linprog','Algorithm','interior-point');
f = [-108 -140];
A = [0.8 0.5;
    0.2 0.4;
    0.01 0.1];
b = [800, 600, 120];
Aeq = [0 0];
beq = 0;
lb = [0 0];
ub = [];
[x, min] = linprog(f, A, b);
display(string(x), 'exercise 3. Answer');

X = [0:0.1:1000];
%note: minuses in front of coefficients are cancelled by each other
Fun = min/f(1,2)-f(1,1)/f(1,2).*X;
Normal = f(1,2)/f(1,1).*X;
Constr1 = b(1,1)/A(1,2)-A(1,1)/A(1,2).*X;
Constr2 = b(1,2)/A(2,2)-A(2,1)/A(2,2).*X;
Constr3 = b(1,3)/A(3,2)-A(3,1)/A(3,2).*X;
LBX = 0.*X+lb(1,1);
LBY = 0.*X+lb(1,2);
figure
title 'exercise 3'
hold on
axis equal
pl1 = plot(X, Fun);
pl2 = plot(X, Constr1, 'g');
plot(X, Constr2, 'g');
plot(X, Constr3, 'g');
pl3 = plot(X, LBX, 'c');
plot(LBY, X, 'c')
delta = 0.1;
i = 1;
while(abs(Fun(i)-Normal(i)) > delta)
    plot(X(1,i), Normal(1,i), 'ro')
    i=i+1;
end
legend([pl1, pl2, pl3],'function', 'constraints', 'bounds');
%plot(X,Normal)options = optimoptions('linprog','Algorithm','interior-point');
%exercise 1
f = [3 1 2];
A = [-1, -1, -1;
    -2, -1, 1];
b = [-1 1];
Aeq = [1, -1, 1];
beq = 0;
lb = [0, 0, 0];
ub = [1, 1, 1];
[x, fval] = linprog(f, A, b, Aeq, beq, lb, ub);
display(x);

%exercise 2
f = [-3000 -2000];
A = [1, 2;
    2, 1];
b = [6, 8];
Aeq = [0 0];
beq = 0;
lb = [0 0];
ub = [2 2];
[x, min] = linprog(f, A, b, Aeq, beq, lb, ub);
display(x, 'exercise 2. Answer');

%graphical solution
X = [0:0.03:4];
%note: minuses in front of coefficients are cancelled by each other
Fun = min/f(1,2)-f(1,1)/f(1,2).*X;
Normal = f(1,2)/f(1,1).*X;
Constr1 = b(1,1)/A(1,2)-A(1,1)/A(1,2).*X;
Constr2 = b(1,2)/A(2,2)-A(2,1)/A(2,2).*X;
LBX = 0.*X+lb(1,1);
UBX = 0.*X+ub(1,1);
LBY = 0.*X+lb(1,2);
UBY = 0.*X+ub(1,2);
figure
title 'exercise 2'
hold on
axis equal
pl1 = plot(X, Fun);
pl2 = plot(X, Constr1, 'g');
plot(X, Constr2, 'g')
pl3 = plot(X, LBX, 'c');
plot(X, UBX, 'c')
plot(LBY, X, 'c')
plot(UBY, X, 'c')
delta = 0.1;
i = 1;
while(abs(Fun(i)-Normal(i)) > delta)
    plot(X(1,i), Normal(1,i), 'ro')
    i=i+1;
end
legend([pl1, pl2, pl3],'function', 'constraints', 'bounds');

%exercise 3
f = [-108 -140];
A = [0.8 0.5;
    0.2 0.4;
    0.01 0.1];
b = [800, 600, 120];
Aeq = [0 0];
beq = 0;
lb = [0 0];
ub = [];
[x, min] = linprog(f, A, b);
display(string(x), 'exercise 3. Answer');

X = [0:0.1:1000];
%note: minuses in front of coefficients are cancelled by each other
Fun = min/f(1,2)-f(1,1)/f(1,2).*X;
Normal = f(1,2)/f(1,1).*X;
Constr1 = b(1,1)/A(1,2)-A(1,1)/A(1,2).*X;
Constr2 = b(1,2)/A(2,2)-A(2,1)/A(2,2).*X;
Constr3 = b(1,3)/A(3,2)-A(3,1)/A(3,2).*X;
LBX = 0.*X+lb(1,1);
LBY = 0.*X+lb(1,2);
figure
title 'exercise 3'
hold on
axis equal
pl1 = plot(X, Fun);
pl2 = plot(X, Constr1, 'g');
plot(X, Constr2, 'g');
plot(X, Constr3, 'g');
pl3 = plot(X, LBX, 'c');
plot(LBY, X, 'c')
delta = 0.1;
i = 1;
while(abs(Fun(i)-Normal(i)) > delta)
    plot(X(1,i), Normal(1,i), 'ro')
    i=i+1;
end
legend([pl1, pl2, pl3],'function', 'constraints', 'bounds');

%exercise 4
f = [-5 -7];
A = [2 3];
b = [60];
Aeq = [0 0];
beq = 0;
lb = [0 0];
ub = [18 18];
[x, min] = linprog(f, A, b, Aeq, beq, lb, ub);
display(x, 'exercise 4. Answer');

%graphical solution
X = [0:0.1:20];
%note: minuses in front of coefficients are cancelled by each other
Fun = min/f(1,2)-f(1,1)/f(1,2).*X;
Normal = f(1,2)/f(1,1).*X;
Constr = b(1,1)/A(1,2)-A(1,1)/A(1,2).*X;
LBX = 0.*X+lb(1,1);
UBX = 0.*X+ub(1,1);
LBY = 0.*X+lb(1,2);
UBY = 0.*X+ub(1,2);
figure
title 'exercise 4'
hold on
axis equal
pl1 = plot(X, Fun);
pl2 = plot(X, Constr, 'g');
pl3 = plot(X, LBX, 'c');
plot(X, UBX, 'c')
plot(LBY, X, 'c')
plot(UBY, X, 'c')
delta = 0.1;
i = 1;
while(abs(Fun(i)-Normal(i)) > delta)
    plot(X(1,i), Normal(1,i), 'ro')
    i=i+1;
end
legend([pl1, pl2, pl3],'function', 'constraints', 'bounds');

%exercise 5
f = [-4, -2, -4, -3];
A = [10, 20, 15, 18;
    0, 5, 8, 17;
    15, 18, 12, 20;
    8, 12, 11, 10];
b = [250 40 100 80];
Aeq = [0 0 0 0];
beq = 0;
lb = [0 0 0 0];
ub = [];
intcon = [1 2 3 4];
x = intlinprog(f, intcon, A, b, Aeq, beq, lb, ub);
display(x, 'exercise 5. Answer')

%exercise 6
f = [-33, -39, -36, -43];
A = [0.9 1.1, 0.7, 1.3;
    1.2, 1.5, 0.9, 1.1;
    1.3, 1.5, 0.9, 1.2];
b = [70, 55, 35];
Aeq = [0, 0, 0, 0];
beq = 0;
lb = [0, 0, 0, 0];
ub = [87, 67, 110 45];
intcon = [1, 2, 3, 4];
x = intlinprog(f, intcon, A, b, Aeq, beq, lb, ub);
display(x, 'exercise 6. Answer')