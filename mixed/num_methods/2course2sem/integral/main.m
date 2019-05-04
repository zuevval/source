%numeric integration
%TODO: compare two intergals
%in one case (where a break exists) Runge estimation
%would be inappropriate

%limits are free to chose, but both intervals should have the same length
%and one should contain the break
f = @(x)(1./(abs(1-x.^2)).^0.5);
a = 0.5;
b= 1.5;
n=4; % n >= 2
%j = integralAndPlot (f, a, b, n)
%jPrecize = integral(f, a, b)

f = @(x)(x.^2-2.*x+3);
%a = -0.5;
%b = 0.5;
%j = integralAndPlot(f, a, b, n)
%jPrecize = integral(f, a, b)
myEps = 0.0001;
J = integralDeviation(myEps, f, a, b)
bar(J)
title(strcat('отклонение интеграла от точного значения, \epsilon =', string(myEps)))
xlabel('k - число элементов разбиения')
ylabel('J-J_{precise} (logarithmic scale)')
integralAndPlot(f, a, b, n)

function J = integralDeviation(Epsilon, f, a, b)
    J = [];
    J(1) = trapeziumIntegral(f, a, b, 2);
    J(2) = trapeziumIntegral(f, a, b, 4);
    i=2;
    n=4;
    while abs(J(i) - J(i-1))*3 > Epsilon
        if i > 50
            break; %assume integral doesn't converge
        end
        i = i + 1;
        n = 2 * n;
        J(i) = trapeziumIntegral(f, a, b, n);
    end
    figure
    hold on
    jPrecise = integral(f, a, b)
    for k=1:1:i
        J(k) = log(J(k) - jPrecise);
    end
end