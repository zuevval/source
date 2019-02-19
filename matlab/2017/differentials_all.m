y0 = [0 0 0 0];
tspan = [0 3];
[t y] = ode45(@(t,y)diff(t,y), tspan, y0)

function dy = diff (t,y)
dy = zeros(2,1);
dy(1) = y(2);
dy(2) = y(3);
dy(3) = y(4);
dy(4) = -5.*y(4)+3.*y(1).*y(3)-(y(1)).^2+20;
endx0 = [0 3.14 1];
tspan = [0 5];
a = 1;
b = 2;
c = 3;
d = 4;
[t, x] = ode45(@(t,x)dif(t,x, a,b,c,d),tspan, x0);
figure
hold on
plot(t, x(:,1))
plot(t,x(:,2))
text(2.5, -1.2, 'transition')
text(2.5, 0.4, 'velocity')

function dxdt = dif(t,x, a,b,c,d)
%a*d2x+b*dx+cx+d=0 - initial equation
dxdt = zeros(3,1);
dxdt(1) = x(2);
dxdt(2) = -1/a.*(b.*x(2)+c.*x(1)+d);
endx0 = [0 1 2];
tspan = [-4 4];
omega_0=10;
beta=0.5;
h=3;
omega = (omega_0.^2-beta.^2)^0.5;
[t, x] = ode45(@(t,x)dif(t,x, omega_0, omega, beta, h),tspan, x0)
figure
hold on
T=-4:0.01:4;
F=-h.*cos(omega.*T);
subplot(2,1,1)
plot(T, F);
legend('F(t)');
subplot(2,1,2)
plot(t,x(:,2))
legend('v(t)');
%legend('v(t)');
%text(2.5, -1.2, 'transition')
%text(2.5, 0.4, 'velocity')

function dxdt = dif(t,x, omega_0, omega, beta, h)
dxdt = zeros(3,1);
dxdt(1) = x(2);
dxdt(2) = -2.*beta.*x(2)-(omega_0.^2).*x(1)+h.*cos(omega.*t(1));
end