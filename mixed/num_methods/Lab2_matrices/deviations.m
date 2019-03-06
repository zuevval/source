Bdev = B;
%deltaB = zeros(n,n);
kB = 0.02;
for i=1:n
    for j=1:n
        t = kB/n; %max deviation of an element
        t = kB*rand(1,1);
        Bdev(i,j) = Bdev(i,j).*(1+kB);
    end
end
deltaB = Bdev-B;
format compact
display(vpa(cond(sym(Bdev), inf)), 'cond(Bdev)');
deltaBNorm = norm(deltaB,inf);