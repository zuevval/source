function y = norm_pdf(x, mu, sigma)
if nargin < 2 % if sigma, mu not passed
    sigma = 1;
    mu = 0;
end
y = exp(-.5.*(x-mu).^2)./(sigma*sqrt(2*pi));
end