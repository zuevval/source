format compact

%preparing variables for numerical integration
S=zeros(1,6);
step_x = [1 0.5 0.25 0.125 0.0625 0.03125];

%integration manually using 'rectangular' method(function Sum in separate file)
for i = 1:1:6
    S(1,i)=Sum(step_x(1,i));
end

SumAnal = integral(f01, 0, 10);
display(SumAnal, 'Analytical solution')
display(S, 'Numerical solutions');

figure
hold on
bar(0.03*step_x)
plot(abs(S-SumAnal), '-o')
legend('dx (not to scale)', 'difference between analytical and numerical solutions')