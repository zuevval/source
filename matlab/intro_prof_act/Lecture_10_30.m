M = 10*rand(5,5)-5;
p = poly(M)
X=-10:0.1:10;
Y=polyval(p,X);
figure
hold on
grid on
plot(X,Y)
%defining arrays of roots to show on plot
Roots = roots(p)
roots_quantity = size (Roots)
Yb = zeros(roots_quantity(1,1), 1)
%trying to get rid of complex roots
for i = 1:roots_quantity(1,1)
    if imag(Roots(i,1))==0
       plot(Roots(i,1), Yb(i,1), '*')
    end
end
%plot(b, Yb, '*')

%for i = 0:16    
%end
%M = [M M]