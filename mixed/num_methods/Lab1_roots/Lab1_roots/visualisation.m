a=0.1254;
b=-0.0027;
c=-4.7285;
d=-25.0263;
e=-33.0434;
syms x; 
f = (-1)*( a.*x.^4+b.*x.^3+c.*x.^2+d.*x+e);
A=-3.5;
B=4;
lambda=0.039877;
phi=x-lambda*f;
n=6;
line_x=zeros(1,n);
line_y=zeros(1,n);
points=zeros(1,4);
points(1,1)=A;
figure
title('method of simple iterations')
hold on
%%p0=plot([A,A],[0,vpa(subs(phi,A))],'r');
for i=2:1:n
    points(i)=vpa(subs(phi,points(1,i-1)));
end
for i=2:1:n-1
    line_x(1,1)=points(1,i-1);
    line_y(1,1)=points(1,i);
    line_x(1,2)=points(1,i);
    line_y(1,2)=points(1,i);
    line_x(1,3)=points(1,i);
    line_y(1,3)=points(1,i+1);
    p0=plot(line_x(1,1:2),line_y(1,1:2),'r');
    plot(line_x(1,2:3),line_y(1,2:3),'r');
    plot([line_x(1,1) line_x(1,1)],[-5.5 line_y(1,1)],'--r');
    txt = ['x_' num2str(i-2)];
    text(line_x(1,1),-5, txt);
end
phi1 = @(x)(x+lambda.*(a.*x.^4+b.*x.^3+c.*x.^2+d.*x+e));
p1=fplot(phi1,'b');
p2=fplot(@(x)(x),'--g')
axis([-5.5 -1.5 -5.5 -1.5])
legend([p0 p1 p2],'приближение к корню','y=\phi(x)','y=x')
grid on
%legend(p1,'\phi')