%mex root_search.c; 
X=-1:0.01:1;
dim=size(X);
Y=zeros(dim);
%Y(1,1)=func(X(1,1));
a=0.1254;
b=-0.0027;
c=-4.7285;
d=-25.0263;
e=-33.0434;
fun1 = @(x)(a.*x.^4+b.*x.^3+c.*x.^2+d.*x+e);
%warning: fun fails on arr input, use element-wise ops
figure
subplot(1,2,1)
title('polynomial')
hold on
grid on
fplot(fun1);
fplot(@(x)(0*x),[-5,10]);
[x1,f1]=fzero(fun1,0);
axis([-5 10 -200 200])

fun2 = @(x)(1.8.*x.^2-sin(10.*x));
lims2=[-1.25,1];
start_points = [-1,-0.5,-0.25,0.25,0.5];
roots_values = zeros(size(start_points));
j=1;
for i = start_points
    roots_values(1,j)=fzero(fun2,i);
    j=j+1;
end

subplot(1,2,2)
hold on
grid on
plot(Y,X,'r');
fplot(fun2,lims2,'b');
fplot(@(x)(0.*x),lims2,'r');
axis([-1.2 1 -1 3])
title('transcendent')