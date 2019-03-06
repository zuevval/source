eps = 0.000001;
n = 3;
%A = ones(n).*3+rand(n);
E = eye(n);
b = 1+rand(n,1);
n = 3;
M = zeros(n);
for i = 1:n
    si = 0;
    for j = 1:n
        if j ~= i
            M(i,j) = rand(1);
            si = si + abs(M(i,j));
        end
        M(i,i) = si + abs(rand(1));
    end
end