%Using symbolic math toolbox
 format compact
%task 11.2: Linear eqations' system from ex. 2 (6 ex-s...)
syms x1 x2 x3 x4;
eqtns=[5.*x1-3.*x2-4.*x3-15.*x4==6,
    6.*x1+1.*x2+10.*x3+2.*x4==9,
     1.*x1+5.*x2+3.*x3+8.*x4==12,
     -4.*x1+5.*x2-1.*x3+9.*x4==-9];
%solving using "solve"
S = solve(eqtns, [x1 x2 x3 x4]);
%solving with "linsolve"
[A,b]=equationsToMatrix(eqtns, [x1,x2,x3,x4]);
LinS=linsolve(A,b);
disp ('Task 11.2');
display (vpa(S.x1,4), 'x1');
display (vpa(S.x2,4), 'x2');
display (vpa(S.x3,4), 'x3');
display (vpa(S.x4,4), 'x4');
display (vpa(LinS(1,1),4), 'x1 (linsolve)');
display (vpa(LinS(2,1),4), 'x2 (linsolve)');
display (vpa(LinS(3,1),4), 'x3 (linsolve)');
display (vpa(LinS(4,1),4), 'x4 (linsolve)');

% task 11.3: surfaces from Table 10.2
syms x y f(x,y);
f(x,y)=(x.^2+y.^2-1).^2+(x.^2-6*x+y.^2+8).^2;
figure
hold on
title('(x^2+y^2-1)^2+(x^2-6\cdotx+y^2+8)^2')
fsurf(f);
view(-27, 48);

figure
hold on
title('(x^2+y^2-1)^2+(x^2-6\cdotx+y^2+8)^2')
fcontour(f);

figure
hold on
title('(x^2+y^2-1)^2+(x^2-6\cdotx+y^2+8)^2')
fcontour(f, 'Fill', 'on');

%parametric surface plot
syms s t x(s,t) y(s,t) z(s,t)
x(s,t)=sin(s)*sin(t);
y(s,t)=cos(s)*cos(t);
z(s,t)=cos(s)*sin(t);
figure
fsurf(x,y,z);

syms x(t) y(t) z(t) t
x(t)=cos(0.1*t)*sin(10*t);
y(t)=2*cos(10*t);
z(t)=3*t;
figure
hold on
pl1=fplot3(x,y,z,[-10 10], 'b--');
x(t)=cos(0.1*t)*sin(10*t);
y(t)=cos(0.1*t)*cos(10*t);
z(t)=3*t;
pl2=fplot3(x,y,z,[-10,10],'r-');
view(-38, 68);
 
%task 11.4: Actions upon function from ex. 4
disp('Task 11.4');
syms y(x) x
y(x) = x.^3.*atan(x);
eqn= y(x)==0;
roots=solve(eqn,x)
figure
hold on
subplot(1,2,1)
fplot(y)
z=-5:0.01:5;
fz=z.^3.*atan(z);
subplot(1,2,2)
area(z,fz);

%task 11.5: analytical and numerical integral
%of function from ex. 5
disp('task 11.5');
syms x f(x)
f(x) = x.^3-exp(4.*x)+5.^5;
I=int(f(x));
display(I, 'Integral(x^3-exp(4*x)+5^5)');
Sum=int(f(x), x, 0, 1);
display(Sum, "Integral from 0 to 1");
 
%task 11.6: Analytical differential from 6th
disp('task 11.6');
syms x y(x) Dy;
eq = x^3*cos(y)+0.1==diff(y,x);
cond = [y(0)==0.4];
d = dsolve(eq, cond, x);
display(d, 'Differential ()');


%from 6th
%eq = x.^3.*cos(y)+0.1==diff(y,x);
%cond = [y(0)==0.4];
%d = dsolve(eq, cond, x);

%task 11.7
syms t x(t) a b c d
eqn = a*diff(x,t,2)+b*diff(x,t)+c*x+d==0;
Dx = diff(x,t);
D2x = diff(x,t,2);
cond = [Dx(0)==3.14, x(0)==0];
h(t) = subs(dsolve(eqn,cond), [a,b,c,d], [1,2,3,4]);
figure
hold on
fplot(h);
fplot(diff(h, t));

%task 11.8 (functions from ex 8.3, 8.4 (modified))
syms x f(x) g(x)
f(x) = piecewise(x<-pi, x+pi, x<pi, 0, 'Otherwise', x-pi);
figure
fplot(f)
ylim ([-4, 4]);
g(x)=piecewise(x<=0,exp(x),x<=pi,1-cos(x-pi/2),x<=4.24,exp(x-pi));
figure
fplot(g)

%task 11.9: minimal value of function from task 10.2
disp('task 11.9')
syms x y(x) dy(x) d2y(x)
y(x) = x^x;
dy(x) = diff(y(x));
d2y(x) = diff(dy(x));
x0=solve(dy(x)==0)
%checking that second derivative is positive in x0
disp(vpa(d2y(x0), 2));

%task 11.10. Taylor series
T1=taylor(f, x, 0.1, 'Order', 6);
T2=taylor(f, x, 0.1, 'Order', 5);
T3=taylor(f, x, 0.1, 'Order', 4);
figure
hold on
fplot(y, 'r', 'LineWidth', 1.5)
fplot(T1, 'black--')
fplot(T2, 'b--')
fplot(T1, 'g--')
ylim([-1 10])
title 'taylor series in point x=0.1'

T4=taylor(f, x, 10, 'Order', 6);
T5=taylor(f, x, 10, 'Order', 5);
T6=taylor(f, x, 10, 'Order', 4);
figure
hold on
title 'taylor series in point x=10'
fplot(y, 'r', 'LineWidth', 1.5)
fplot(T4, 'black--')
fplot(T5, 'b--')
fplot(T6, 'g--')
ylim([-10 80]);
xlim([0 20])

%task 11.11 (determinant is positive)
disp('task 11.11');
syms k
M=sym([1, k, 3; 2, 4, 2*k; 4, -2, k]);
f(k)=det(M);
roots=solve(f(k)==0)
inpoints=solve(f(k)>0);
display(vpa(inpoints, 4), "points inside intervals");

figure
fplot(f)