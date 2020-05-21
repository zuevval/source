% for continuous distributions only
function p = outliers_probab(inv_cdf, cdf)
q1 = inv_cdf(.25);
q3 = inv_cdf(.75);
x1 = .5*(5*q1 - 3*q3);
x2 = .5*(5*q3 - 3*q1);
p1 = cdf(x1);
p2 = cdf(x2);
p = 1 - p2 + p1;
end