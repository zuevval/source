X = A(1:end, 1);
Y = A(1:end, 2);
Z = A(1:end, 3);
figure
loglog(X,Y)
grid on
title('dependency of k_{1} from cond(A) - logarithmic scale')
figure
loglog(X,Z)
title('dependency of k_{2} from cond(A) - logarithmic scale')
grid on