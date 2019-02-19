%1
A=[1 2 3 4 5; 
   6 7 8 9 10;
   11 12 13 14 15;
   16 17 18 19 20;
   21 22 23 24 25]
B=[26 27 28 29 30;
    31 32 33 34 35;
    36 37 38 39 40;]
C=[41 42 43;
    44 45 46;
    47 48 49;
    50 51 52;
    53 54 55]
D=[56 57 58 59 60]
E=[61; 62; 63; 64; 65]
%2
I=rand(1,1);
J=rand(1,1);
I=fix(4.9*I)+1;
J=fix(4.9*J)+1;
I1=rand(1,1);
J1=rand(1,1);
I1=fix(4.9*I1)+1;
J1=fix(4.9*J1)+1;
I2=rand(1,1);
J2=rand(1,1);
I2=fix(2.9*I2)+1;
J2=fix(4.9*J2)+1;
I3=rand(1,1);
J3=rand(1,1);
I3=fix(4.9*I3)+1;
J3=fix(2.9*J3)+1;
a=A(I1,J1)
b=B(I2,J2)
c=C(I3,J3)
%3
a1=A(:,2)
a2=A(3,:)
a3=A(2:4,4)
a4=A(4,2:5)
a5=A(2:4,3:5)
Temp=A;
for t=3:1:4;
    Temp(t,:)=Temp(t+1,:);
end;
A=Temp(1:4,:)
Temp=A;
for t=2:1:4;
    Temp(:,t)=Temp(:,t+1);
end;
A=Temp(:,1:4)
Temp=A;
    Temp(:,2)=Temp(:,4);
A=Temp(:,1:2)
Temp=A;
    Temp(2,:)=Temp(4,:);
A=Temp(1:2,:)
A=[1 2 3 4 5; 
   6 7 8 9 10;
   11 12 13 14 15;
   16 17 18 19 20;
   21 22 23 24 25];
B=[26 27 28 29 30;
    31 32 33 34 35;
    36 37 38 39 40;];
C=[41 42 43;
    44 45 46;
    47 48 49;
    50 51 52;
    53 54 55]
D=[56 57 58 59 60];
E=[61; 62; 63; 64; 65];
%4
U1=cat(2,A,C,E);
U1=cat(2,A,E,C);
U1=cat(2,C,E,A);
U2=cat(1,A,B,D);
%5
Mul1=A*E
Div1=A(:,1)./E
Div2=A(:,J)./E
Mul2=A(I,:).*D
Div3=A(I,:)./D
%6
A=[1 2 3 4 5; 
   6 7 8 9 10;
   11 12 13 14 15;
   16 17 18 19 20;
   21 22 23 24 25];
Temp=A;
A=A^3
A=Temp;
A=A^(-3)
A=Temp;
A=A^1.5
A=Temp;
A=A^(-1.5)
A=A.^3
A=Temp;
A=A.^(-3)
A=Temp;
A=A.^1.5
A=Temp;
A=A.^(-1.5)
%7
A=Temp;
A=A'
A=Temp;
A=inv(A)
A=Temp;
m=1;
for i=1:1:5
    for j=1:1:5
        m=m*A(i,j);
    end
end
m
s=1;
for i=1:1:5
    for j=1:1:5
        s=s+A(i,j);
    end
end
A=Temp;
    p=poly(A)
%8
Sqrt=sqrt(A)
Sqrt=sqrt(B)
Sqrt=sqrt(C)
Sqrt=sqrt(D)
Sqrt=sqrt(E)
 
Exp=exp(A)
Exp=exp(B)
Exp=exp(C)
Exp=exp(D)
Exp=exp(E)
 
Log=log(A)
Log=log(B)
Log=log(C)
Log=log(D)
Log=log(E)
[A_N, A_M]=size(A)
[B_N, B_M]=size(B)
[C_N, C_M]=size(C)
[D_N, D_M]=size(D)
[E_N, E_M]=size(E)

%9
F_eye=eye(4,4)
F_ones=ones(4,4)
F_zeros=zeros(4,4)
F_magic=magic(6)
F_rand=rand(4,4)
 
%10
M16=magic(6)
Di=diag(M16,0)
DiT=ones(1,6);
diag(M16)=[1; 1; 1; 1; 1; 1];

%task 2.14
A=[4 7 6 -19;
   5 9 12 3;
   4 -3 1 -8;
   2 5 9 10];
B=[10; 12; -14; 22];
X=A\B %Returns A*X=B

%task 3.14
x=0:0.1:1;
y=0:0.1:1;
[X,Y]=meshgrid(x,y);
%syms x; f = taylor(log(1+x)); latex(f)
Z=exp(-X.*Y)+1;
y0=0.4;
figure
hold on
grid on
view(150,50);
surfl(X,Y,Z)
diff(exp(-x.*y)+1)

%task5.14
syms x; solve('x^2 -cos(x)','x')
x=0:0.1:1;
plot(x,x.^2 -cos(x))

%task 6.1
x=-10:0.1:10;
t=x';
y=[sin(t) cos(t)]; %making a matrix depending on x
figure
hold on
grid on
plot(x, y(:, 1))
plot(x, y(:, 2))
[a, b]=size(x)
B=1:1:b;
figure
plot(B, sin(t)) %making a plot (index - x(index))

%task 6.2
figure
hold on
grid on
plot(x, y(:, 1), 'xg')
plot(x, y(:, 2), '*m')
y=[exp(t) exp(-t)];
figure
hold on
grid on
plot(x, y(:, 1), '--y')
plot(x, y(:, 2), '.r')
y=[t -t];
figure
hold on
grid on
plot(x, y(:, 1), 'c')
plot(x, y(:, 2), 'w')
y=[t t-3 t-6 t-9 t+3 t+4];
figure
hold on
grid on
plot(x, y(:, 1), 'pc')
plot(x, y(:, 2), 'hk')
plot(x, y(:, 3), '>c')
plot(x, y(:, 4), '^c')
plot(x, y(:, 5), 'Oc')
plot(x, y(:, 6), 'sc')

%task 6.3
x=0:1:30;
f=log(x);
figure
bar(x,f)

%task 6.4
f=sin(x);
figure
stairs(x,f)

%task 6.5
y=erf(x);
f=rand(size(x));
errorbar(x,y,f)

%task 6.6
figure
x=0:0.1:6.24;
f=sin(x)-(cos(x)).^2;
polar(x,f)

%task 6.7
figure
x=logspace(0,5);
grid on
loglog(x,-exp(x.^2))

x=-10:0.1:10;
figure
grid on
semilogy(x, -exp(x.^2))

%task 6.8
x=-10:0.1:10;
y=randn(size(x));
figure
grid on
histogram(y)

%task 9
x=-5:0.1:5;
y=-5:0.1:5;
[X,Y]=meshgrid(x,y);
Z=X.^2+Y.^2;
C=-Z;
figure
mesh(x,y,Z);
figure
mesh(x,y,Z,C); 
%uses info from C to set a color of each point
figure
mesh(Z)
C=Z.*sin(X)*cos(Y);
figure
mesh(Z,C)

%task 6.10
figure
peaks(50);
%returns 50*50 Gaussian distribution of [x,y]

figure
surf(x,y,Z,C);%task 5.10
X = 2.6:0.05:3.0;
Y = X.^3 - exp(4.*X)+5*10^5; %making an array to build a plot

f='(x)^3-exp(4*x)+5*10^5';
x0=fzero(f,(2.6)) % one way to solve
x00=fsolve(f,(2.6)) %another way to solve

figure
hold on
subplot(2,1,1)
plot(X, Y)
subplot(2,1,2)
fplot(f, [2.6 3.0]) % another way to make a plot
%here result looks untrustworthy%task 4.10
fun = @(x)(x).^3.*atan(x)
X=0:0.003:sqrt(3);
Y=fun(X);
trapz(X, Y)
quad(fun, 0, sqrt(3), 'AbsTol', 0.003)
%var 10
%integrals
%21.10.2017
%functions in files f10.m, twoarg.m
%function f10 was taken from task 5
format compact

%figure
%fplot(f10, [2.6 3.0])
integral(f10, 2.6, 3.0)
X=2.6:0.05:3;
Y=(X).^3+exp(4.*X)-5.5;
figure
area(X, Y)
trapz(X, Y)
integral(f10, 2.6, 3.0)

%numerical double integral
X=-1:0.05:1;
Y=X;
[x, y] = meshgrid(X, Y);
z = (x).^3.*cos(y)+0.1;
%getting rid of negative part
z1 = 0.5.*abs(z)+0.5.*z;
%"zero" plane
z0=0.*x+0.*y;
figure
hold on
mesh(x, y, z);
S1=surf(x,y,z0);
S1.FaceAlpha = 0.4;
S1.FaceColor = 'r';
S1.EdgeColor = 'none';
view(-35,24);
integral2(twoarg, -1, 1, -1, 1)

%differential
%analytical
%syms x y(x)
%eqn = diff(y,x)==x^3*cos(y);
%Dy = diff(y,x);
%cond = [y(0)==1, Dy(0)==0];
%f1=dsolve(eqn, cond);

%display(f1, 'analytical solution')

%numerical
tic;
[X1 Y1] = ode45(@fun, [0 1], 1);
toc_ode45=toc;
tic;
[X2 Y2] = ode113(@fun, [0 1], 1);
toc_ode113=toc;
tic;
[X3 Y3] = ode23(@fun, [0 1], 1);
toc_ode23=toc;
figure
c = categorical({'ode45', 'ode113', 'ode23'});
bar(c, [toc_ode45, toc_ode113, toc_ode23]);
t=table(X1, Y1)

figure
plot(X1,Y1, 'b-o');
plot(X2,Y2, 'r-o');
plot(X3,Y3, 'm-o');

function dydx = fun(x, y)
dydx = zeros(1,1);
dydx(1) = (x).^3.*cos(y(1))+0.1;
end

function z = twoarg (x, y)
z = @(x,y) (x).^3.*cos(y)+0.1;
end

function y = f10 (x)
y = @(x) 0.5.*abs((x).^3+exp(4.*x)-5.5)+0.5.*((x).^3+exp(4.*x)-5.5);
end%tabbing
format compact
%task 1a
a=0.05;
b=0.06;
X=0.2:0.15:0.95;
y=@(x)(acos(x.^2-b.^2)./asin(x.^2-a.^2));
Y=y(X);
figure
hold on
title('acos(x^2-b^2)/asin(x^2-a^2)')
plot(X,Y);

%task 1b
X = [0.15, 0.26, 0.37, 0.48, 0.56];
Y=y(X);
figure
plot(X,Y);

%task 2
X2=[22.0, 24.0, 27.0, 30.0 31.0 35.0 40.0];
Y2=[1.24, 1.37, 1.46, 1.26 1.66 1.84 1.99];
figure
hold on
title('task 2');
plot(X2,Y2,'o');

%task 3
f = @(x)(x.^x);
[x,y]=fminbnd(f,0.1, 1.0);
X3=0.1:0.01:1;
Y3=f(X3);
figure
hold on
title('x^x');
plot(X3,Y3);
plot(x,y,'*r');
display('task 3')
display(x, 'x_min=');
display(y, 'y_min=');

%task 4
f = @(x)((x(1).^2+x(2).^2-1).^2+(x(1).^2-6.*x(1)+x(2).^2+8));
M0=[2,2]; %starting point
[xmin, ymin]=fminsearch(f,M0);
display('task 4');
display(xmin, '[x_min, y_min]=');
display(ymin, 'min(f(x,y))=');

%drawing 3d-plot
f = @(x,y)((x.^2+y.^2-1).^2+(x.^2-6.*y+y.^2+8));
X4=-10:0.1:10;
Y4=X4;
[x4, y4]=meshgrid(X4, Y4);
z4=f(x4,y4);
figure
surf(x4,y4,z4);