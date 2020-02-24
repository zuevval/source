function y = laplace_pdf(x, mu, b)
if nargin < 2 % if mu, b not passed
    b = 1/sqrt(2);
    mu = 0;
end
y = exp(-abs(x-mu)./b)./(2*b);
end