function y = quadrant_corrcoef(mtx)
col1 = mtx(:,1);
col2 = mtx(:,2);
med1 = median(col1);
med2 = median(col2);
y = mean(sign(col1-med1) .* sign(col2-med2));
end