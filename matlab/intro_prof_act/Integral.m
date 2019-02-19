format compact

%drawing plot that depicts our method of integrating
X=0:0.1:10;
Y=tan(sin(X).^2);
figure
bar(X,Y)
grid on

%definite integral

%preparing variables for numerical integration
S=zeros(1,6);
step_x = [1 0.5 0.25 0.125 0.0625 0.03125];

%integration manually using 'rectangular' method(function Sum in separate file)
for i = 1:1:6
    S(1,i)=Sum(step_x(1,i));
end

%calculating integral analytically for comparison
SumAnal = integral(f01, 0, 10);
display(SumAnal, 'Analytical solution')
display(S, 'Numerical solutions');

%making a plot that shows that the smaller is the step, the closer is the
%result to analytical solution
figure
hold on
bar(0.03*step_x);
plot(abs(S-SumAnal), '-o');
legend('dx (not to scale)', 'difference between analytical and numerical solutions');