function y = uniform_pdf(x, a, b)
if nargin < 2 % if a, b not passed
    a = -sqrt(3);
    b = sqrt(3);
end

y = (a <= x & x <= b) .* ones(size(x)) ./ (b-a);
end