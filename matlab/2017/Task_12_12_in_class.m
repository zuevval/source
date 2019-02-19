format compact
syms x f(x)
f(x)=cos(x)^2*exp(x);
T1=taylor(f,x,0);
T2=taylor(f,x,0, 'Order', 4);
T3=taylor(f,x,pi);
T4=taylor(f,x,pi, 'Order', 4);
X=0:1:30;
Y=0.*X+0;
Y1=0.*X+pi;
figure
subplot(2,1,1)
hold on
title('Taylor series in point x=0');
fplot(f,'b')
fplot(T1, 'g--')
fplot(T2, 'black--')
plot(0,f(0),'r*');
plot(Y,X,'--');
text(0,3, '(0;1)')
xlim([-1 pi+1])
ylim([0,30])
subplot(2,1,2)
hold on
title('Taylor series in point x=\pi');
fplot(f,'b')
fplot(T3, 'g--')
fplot(T4, 'black--')
plot(pi,f(pi),'r*');
plot(Y1,X,'--');
text(pi,20, '(\pi;e^\pi)')
xlim([-1 pi+1])
ylim([0,30])