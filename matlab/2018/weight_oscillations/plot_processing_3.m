%l. b=0, F=500sin(13.4t), psi=0, x0=0, v0=0
%m. b=9, F=500sin(13.4t), psi=0.1514, x0=0, v0=0

figure
subplot(2,1,1)
hold on
grid on
plot(xn)
plot(xo)
legend('b=0, F=500sin(3.1125t), psi=0, x0=0, v0=3.5','b=9, F=500sin(3.1125t), psi=0.1514, x0=0, v0=3.5')
title('coordinate (biharmonic)')
subplot(2,1,2)
hold on
grid on
plot(vn)
plot(vo)
legend('b=0, F=500sin(3.1125t), psi=0, x0=0, v0=3.5','b=9, F=500sin(3.1125t), psi=0.1514, x0=0, v0=3.5')
title('velocity (biharmonic)')