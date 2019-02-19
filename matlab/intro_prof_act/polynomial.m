load('matrix_for_polynomial.m', '-mat', 'M');
p = poly(M);
X=-12.5:0.1:10;
Y=polyval(p,X);
figure
hold on
grid minor
plot(X,Y)
k = 1e10;
axis ([-12.5 8 -k +0.5*k])
%defining arrays of roots to show on the plot
Roots = roots(p);
roots_quantity = size (Roots);
YRoots = zeros(roots_quantity(1,1), 1);
%trying to get rid of complex roots
for i = 1:roots_quantity(1,1)
    if imag(Roots(i,1))==0
       pl1 = plot(Roots(i,1), YRoots(i,1), '*r');
    end
end

%same for the derivative of p
p1=polyder(p);
Roots1 = roots(p1)
roots_quantity1 = size (Roots1);
YRoots1 = polyval(p, Roots1);
%trying to get rid of complex roots
for i = 1:roots_quantity1(1,1)
    if imag(Roots1(i,1))==0
       pl2 = plot(Roots1(i,1), YRoots1(i,1), 'or');
    end
end

%once again for the second derivative
p2=polyder(p1);
Roots2 = roots(p2)
roots_quantity2 = size (Roots2);
YRoots2 = polyval(p, Roots2);
%trying to get rid of complex roots
for i = 1:roots_quantity2(1,1)
    if imag(Roots2(i,1))==0
       pl3 = plot(Roots2(i,1), YRoots2(i,1), 'sg');
    end
end

legend([pl1, pl2, pl3],'roots', 'exteremal points', 'roots of 2nd derivative');


Y1=polyval(p1, X);
figure
hold on
pl40=plot(X, Y1);
for i = 1:roots_quantity1(1,1)
    if imag(Roots1(i,1))==0
       pl4 = plot(Roots1(i,1), 0, 'or');
    end
end
title('first derivative');
legend([pl40, pl4], 'first derivative', 'roots');

Y2=polyval(p2, X);
figure
hold on
pl50=plot(X, Y2);
for i = 1:roots_quantity2(1,1)
    if imag(Roots2(i,1))==0
       pl5 = plot(Roots2(i,1), 0, 'sg');
    end
end
title('second derivative');
legend([pl50, pl5], 'second derivative', 'roots');