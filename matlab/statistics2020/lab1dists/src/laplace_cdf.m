function y = laplace_cdf(x)
b = 1/sqrt(2); % scale parameter
mu = 0; % mean (location parameter)
y = 0.5 + 0.5 .* sign(x-mu) .* (1 - exp(-abs(x - mu)./b));
end