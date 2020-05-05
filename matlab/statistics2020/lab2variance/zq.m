function y = zq(arr)
% Zq = (z_(1/4)+z_(3/4))/2 - half sum of quartiles
% assuming `arr` is not empty and already sorted
n = size(arr, 1); % array length
z_1_4 = arr(ceil(n/4));
z_3_4 = arr(ceil(3*n/4));
y = (z_1_4 + z_3_4)/2;
end