function y = ztr(arr)
% assuming `arr` is a sorted column vector
n = size(arr, 1);
r = floor(n ./ 4);
y = 1./(n-2*r) .* sum(arr(r + 1: n - r));
end
