function y = laplace_cdf(x)
b = 1/sqrt(2); % scale parameter
mu = 0; % mean (location parameter)
if x > mu
    y = 1 - 0.5.*exp(-(x-mu)./b);
else
    y = 0.5.*exp((x-mu)./b);
end
end