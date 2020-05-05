function y = zr(arr)
% Zr = (x_(1)+x_(n))/2 - half sum of extremal values
% assuming `arr` is not empty and already sorted
y = (arr(1) + arr(end))/2;
end