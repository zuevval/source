n=2;
X = -1:2/n:1;
Xmid = -1+1/n:2/n:1;
lagrange;
figure
hold on
Y_hermit_dense = 2.*Xdense.^4-4.*Xdense.^2+1;
plot(Xdense, Ydense1);
plot(Xdense, cos(pi.*Xdense), 'color', 'g');
plot(Xdense, Y_hermit_dense, 'color', 'm');
legend('Lagrange','cos(\pi\cdot x)', 'Hermit')