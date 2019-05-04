f = @(x)(1./(abs(1-x.^2)).^0.5);
a = 0.5;
b= 1.5;
n=10;
%f = @(x)(x.^2-2.*x+3);
%j = radoIntegral(f, a, b, n);
integralDeviation(1e-5, f, a, b)

function J = integralDeviation(Epsilon, f, a, b)
    J = [];
    J(1) = radoIntegral(f, a, b, 2);
    J(2) = radoIntegral(f, a, b, 4);
    i=2;
    n=4;
    while abs(J(i) - J(i-1))*3 > Epsilon
        if i > 22
            break; %assume integral doesn't converge
        end
        i = i + 1;
        n = 2 * n;
        J(i) = radoIntegral(f, a, b, n);
        i
    end
    figure
    hold on
    jPrecise = integral(f, a, b)
    %for k=1:1:i
    %    J(k) = log(J(k) - jPrecise);
    %end
    bar(J)
    title(strcat('отклонение интеграла от точного значения, \epsilon =', string(Epsilon)))
    xlabel('k - число элементов разбиения')
    ylabel('J-J_{precise}')
end