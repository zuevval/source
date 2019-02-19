function z = twoarg (x, y)
z = @(x,y) (x).^3.*cos(y)+0.1;
end