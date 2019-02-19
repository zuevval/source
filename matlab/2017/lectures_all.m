%mesh(A, A, A)
N=50;
y=randn(50,1);
y2=filter([1 1]/2, 1, y);
figure
hold on
grid on
%plot(y2)
%bar(y2)
stem(y2);
%doc plot 
%searching for "plot" in Help browser
hold off

U=-4:0.1:4
V=-5:0.1:5
[x,y]=meshgrid(U,V)
z=sin(x)+cos(y)
surfl(x,y,z)%? ?????????? ????: ??????????? ??? ??????
%?????????, ????. 
%?n. ??????????? ??????. ?????
t=0:pi*0.01:2*pi;
rho=sin(5*t+0.5*pi);
%  polar(t, rho);

w=0:1:100;
t=0:1:100;
F=sin(w.*t)
[x,y]=meshgrid(w,t);
surfl(x,y,F)%solving non-linear equations in MatLab
syms x;
f=@(x) tan(x);
g=@(x) x;
h=@(x) tan(x)-x;
figure
hold on
fplot(f,[pi/2 2*pi])
fplot(g, [pi/2 2*pi])
fplot( h, [pi/2 2*pi])
axis equal
ylim([-1 8])
xlim([pi/2 2*pi])
%plot (x, g-f)
f='tan(x)-x';
x0=fzero(f,(pi))
x=-10:0.3:10;
hline=x0+x-x;
plot(hline,x, '.k')%vertical line
fsolve(f,pi/2,pi*10)
f=@(x) x;
s=integral(f, 0, 4);
s=integral(f, 0, 4, 'AbsTol', 1e-12)

X = 1:0.1:8;
Y=randn(1, (8-1)/0.1 + 1);
Y=sin(X);
plot(X,Y)
area(X, Y, 'DisplayName', 'Y')
trapz(X, Y) % approximate finite integral via trapezoidal method
Y=-Y;
trapz(X, Y);X=-1:0.01:1;
Y=X.^2+sin(5*X);
figure
subplot(1,2,1);
area(X, Y, 'DisplayName', 'name');
subplot(1,2,2);
stem(X,Y)

%double integral = V under surface
[x,y] = meshgrid(-10:10, -10:10);
z=5*x+sin(10*y);
 figure;
 subplot(1,2,1);
 surf(x,y,z);
 subplot(1,2,2);
 meshz(x,y,z);
%doc integral2
fun = @(x, y)(5*x+sin(10*y));
integral2(fun, -1, 1, -1, 1)
%last 2 arguments are y constraints

%ordinary differential equations
%y'=2t; diapazone [0;5]
tspan = [0 5];
y0 = 0;
fun2 = @(t,y)(2*t);
[t, y] = ode23(fun2, tspan, y0);
figure
plot(t,y,'-o')

%solving van-der-pau task
%invoking vdpi.m from the same directory
meshz(x,y,z);
[t,y]=ode45(@vdp1,[0 20],[2; 0])
% Here arguments mean: t-diapazone - (0-20),
%y0=2, v0=0%Cell arrays
c = {1 2 3}
c{4}='WOW! You can put strings into a cell array';
c(1,3); %an element located in 1st line, 3rd column
c{1:3}; %ouptut: 3 answers
[c{1:3}]; %output: vector

%tables
%load FileName.m %loading .m file
Age = [10; 11; 12; 13; 14];
Height = {180; 200; 170; 195; 190};
RowNames = {'1' '3' '2' '4' '5'};
T = table(Age, Height, 'RowNames', RowNames);
T=sortrows(T, 'RowNames') %sorts rows by increasing of their title
%T2=readtable(filename)
size(T)
T(1:3,:)

%comparing
A=[0 3; -10 8];
B=[1 2; 2 3];
A<B %compares every element
B=magic(10);
c{6} = B;
n = 5;
R = 10*rand(n,n);
tf = 0;
for i = 1:n
    for j = 1:n
        if R(i,j) == 2
            tf = tf+1;
        end
    end
endtspan = [0 5];
y0 = [5 3];
options=odeset('RelTol', 1e-5, 'stats', 'on', 'OutputFcn', @odeplot);
[t y] = ode45(@odef, tspan, y0);
figure
hold on
plot(t, y, '*')
text(2.5, 2.5, 'transition - перемещение')
text(2.5, -1, 'velocity - скорость')

%ode23 works faster
% "tic"-"toc" measures time of calculations
tic, [t, y] = ode23(@odef, tspan, y0); toc
figure
hold on
plot(t, y, '*')
text(2.5, 2.5, 'transition - перемещение')
text(2.5, -1, 'velocity - скорость')

%ode113 can work with matrices with specified mass