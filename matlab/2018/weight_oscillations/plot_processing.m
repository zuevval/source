%pendulm 1. Plot_processing
%k=12.45 T=0.5047
%a. b=0, F=0, psi=0, x0=0, v0=3.5
%b. b=0, F=0, psi=0, x0=2, v0=0
%c. b=0, F=0, psi=0, x0=2, v0=3.5
%d. b=0, F=50000sin(0.5t), psi=0, x0=0, v0=3.5
%e. b=0, F=50000sin(0.5t), psi=0, x0=2, v0=0
%f. b=0, F=50000sin(0.5t), psi=0, x0=2, v0=3.5
figure
subplot(3,1,1)
hold on
grid on
plot(va)
legend('b=0, F=0, psi=0, x0=0, v0=3.5')
title('velocity (free oscillations)')
subplot(3,1,2)
hold on
grid on
plot(vb)
legend('b=0, F=0, psi=0, x0=2, v0=0')
title('')
subplot(3,1,3)
hold on
grid on
plot(vc)
legend('b=0, F=0, psi=0, x0=2, v0=3.5')
title('')

figure
subplot(3,1,1)
hold on
grid on
plot(vd)
legend('b=0, F=50000sin(0.5t), psi=0, x0=0, v0=3.5')
title('velocity (forced oscillations)')
subplot(3,1,2)
hold on
grid on
plot(ve)
legend('b=0, F=50000sin(0.5t), psi=0, x0=2, v0=0')
title('')
subplot(3,1,3)
hold on
grid on
plot(vf)
legend('b=0, F=50000sin(0.5t), psi=0, x0=2, v0=3.5')
title('')

figure
subplot(3,1,1)
hold on
grid on
plot(xa)
legend('b=0, F=0, psi=0, x0=0, v0=3.5')
title('coordinate (free oscillations)')
subplot(3,1,2)
hold on
grid on
plot(xb)
legend('b=0, F=0, psi=0, x0=2, v0=0')
title('')
subplot(3,1,3)
hold on
grid on
plot(xc)
legend('b=0, F=0, psi=0, x0=2, v0=3.5')
title('')

figure
subplot(3,1,1)
hold on
grid on
plot(vd)
legend('b=0, F=50000sin(0.5t), psi=0, x0=0, v0=3.5')
title('coordinate (forced oscillations)')
subplot(3,1,2)
hold on
grid on
plot(xe)
legend('b=0, F=50000sin(0.5t), psi=0, x0=2, v0=0')
title('')
subplot(3,1,3)
hold on
grid on
plot(xf)
legend('b=0, F=50000sin(0.5t), psi=0, x0=2, v0=3.5')
title('')

%g. b=25, F=0, psi=0, x0=2, v0=3.5
%h. b=-2, F=0, psi=0, x0=2, v0=3.5

figure
subplot(2,1,1)
hold on
grid on
plot(xg)
plot(xh)
legend('b=25, F=0, psi=0.4206, x0=0, v0=3.5','b=-2, F=0, psi=-0.03365, x0=0, v0=3.5')
title('coordinate (+damping)')
subplot(2,1,2)
hold on
grid on
plot(vg)
plot(vh)
legend('b=25, F=0, psi=0.4206, x0=0, v0=3.5','b=-2, F=0, psi=-0.03365, x0=0, v0=3.5')
title('velocity (+damping)')