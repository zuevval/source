function y = uniform_cdf(x)
a = -sqrt(3);
b = sqrt(3);
if x < a
    y = 0;
elseif x > b
    y = 1;
else
    y = x ./ (b-a) + 0.5;
end
end