%M = 10.*rand(10,10)-5;
%save('matrix_for_polynomial.m', 'M');
%to change contents of file matrix_for_polynomial,
%disable comments for first two lines
load('matrix_for_polynomial.m', '-mat', 'M');
p = poly(M)
X=-12.5:0.1:10;
Y=polyval(p,X);
figure
hold on
grid on
plot(X,Y)
%defining arrays of roots to show on the plot
Roots = roots(p);
roots_quantity = size (Roots);
YRoots = zeros(roots_quantity(1,1), 1);
%trying to get rid of complex roots
for i = 1:roots_quantity(1,1)
    if imag(Roots(i,1))==0
       plot(Roots(i,1), YRoots(i,1), '*')
    end
end