function R = ellips_r(x1, y1, sigma1, sigma2)
radiuses = sqrt((x1./sigma1).^2 + (y1./sigma2).^2);
R = max(radiuses);
end