function y = cauchy_pdf(x, mu, gamma)
if nargin < 2 % if sigma, mu not passed
    gamma = 1;
    mu = 0;
end
y = (gamma.^2)./(((x-mu).^2+gamma^2).*pi.*gamma);
end