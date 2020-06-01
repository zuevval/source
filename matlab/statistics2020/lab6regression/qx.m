function y = qx(arr)
% Zq = z_(3/4)-z_(1/4) - interquartile interval
arr = sort(arr)';
n = size(arr, 1); % array length
z_1_4 = arr(ceil(n/4));
z_3_4 = arr(ceil(3*n/4));

% 1.491 for n=20, but when current function used as qx(..)/qx(..), it's
% unimportant
y = (z_3_4 - z_1_4)/1.491; 
end