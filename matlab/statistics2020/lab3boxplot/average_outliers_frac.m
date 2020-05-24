% `data` is a 2-dim cell array of column vectors
% computes average along second axis of `data`
function [y, Dy] = average_outliers_frac(data)
outliers_frac = zeros(size(data));
for i = 1:size(data, 1)
    for j = 1:size(data, 2)
        outliers_frac(i, j) = outliers_fraction(data{i, j});
    end
end
y = mean(outliers_frac, 2);
Dy = var(outliers_frac, 0, 2);
end