%i. b=0, F=500sin(12.45t), psi=0, x0=3.5, v0=2
%i2. b=25, F=500sin(12.45t), psi=0.4206, x0=3.5, v0=2

figure
subplot(2,1,1)
hold on
grid on
plot(xi)
plot(xi2)
legend('b=0, F=500sin(12.45t), psi=0, x0=3.5, v0=2','b=25, F=500sin(12.45t), psi=0.4206, x0=3.5, v0=2')
title('coordinate (resonance)')
subplot(2,1,2)
hold on
grid on
plot(vi)
plot(vi2)
legend('b=0, F=500sin(12.45t), psi=0, x0=3.5, v0=2','b=25, F=500sin(12.45t), psi=0.4206, x0=3.5, v0=2')
title('velocity (resonance)')

%j. b=0, F=500sin(11.4t), psi=0, x0=0, v0=0
%k. b=9, F=500sin(11.4t), psi=0.1514, x0=0, v0=0

figure
subplot(2,1,1)
hold on
grid on
plot(xj)
plot(xk)
legend('b=0, F=500sin(11.4t), psi=0, x0=0, v0=0','b=9, F=500sin(11.4t), psi=0.1514, x0=0, v0=0')
title('coordinate (beats below resonance)')
subplot(2,1,2)
hold on
grid on
plot(vj)
plot(vk)
legend('b=0, F=500sin(11.4t), psi=0, x0=0, v0=0','b=9, F=500sin(11.4t), psi=0.1514, x0=0, v0=0')
title('velocity (beats below resonance)')

%n. b=0, F=500sin(3.1125t), psi=0, x0=0, v0=3.5
%0. b=9, F=500sin(3.1125t), psi=0.1514, x0=0, v0=3.5

figure
subplot(2,1,1)
hold on
grid on
plot(xl)
plot(xm)
legend('b=0, F=500sin(13.4t), psi=0, x0=0, v0=0','b=9, F=500sin(13.4t), psi=0.1514, x0=0, v0=0')
title('coordinate (beats over resonance)')
subplot(2,1,2)
hold on
grid on
plot(vl)
plot(vm)
legend('b=0, F=500sin(3.1125t), psi=0, x0=0, v0=3.5','b=9, F=500sin(13.4t), psi=0.1514, x0=0, v0=0')
title('velocity (beats over resonance)')