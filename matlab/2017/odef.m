function dydt = odef (t, y)
dydt = zeros(2,1);
dydt(1) = y(2);
dydt(2) = -7*y(2) - 10*y(1)+20;
end