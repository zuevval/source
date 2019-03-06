n = 10;
%No = 0;
f_no = exp(-No);
B = zeros(n);
for i = 1:n
    for j = i:n
        B(i,j) = 1 + 0.5*rand(1,1);
    end
end
for i = 1:n
        B(i,i) = exp(i/n.*No)./exp(No);%generate some bad matrix;
end
disp(vpa(cond(sym(B), inf)))
for i = 1:100
    W=(ones(n,n)+0.5.*rand(n,n));
    W=W./norm(W);
    H=eye(n)-2*(W*W');
    B=H*B*H';
end
for i=1:n
    for j=1:n
        %B(i,j)=B(i,j)*10;
    end
end
format compact
display(No, 'No - affects cond of B');
display(vpa(cond(sym(B), inf)), 'cond(B)');