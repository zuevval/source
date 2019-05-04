m=3;
n=5;
%f=@(x)(cos(pi.*x));
f=@(x)(1./(1+25.*x.^2));
range = [-1, 1];
X = range(1):0.01:range(2);
dim = size(X);
Y = zeros(5,dim(2));
Y(1,:) = f(X);
% figure
% hold on
% grid on
% plot(X, Y(1,:));
% for h = 2:5
    % [A, maxDev, maxDevMid, X1] = smallestSq(f, m, n, range, 10^(h-2));
    % for i=1:1:dim(2)
        % for j=1:1:m
            % pow = j-1;
            % Y(h,i) = Y(h,i)+A(j,1).*X(1,i).^pow;
        % end
    % end
    % plot(X, Y(h,:));
% end

% plot(X1, f(X1),'*r')
% plot(X1(2), f(X1(2)),'ob')
% %plot(X1(4), f(X1(4)),'ob')

% t = strcat('метод наименьших квадратов (m=',string(m), ', ');
% t = strcat(t, 'n=', string(n),')');
% title(t);
% %axis([range(1,:),-0.5,1.5]);
% legend('f(x)=1/(1+25x^2)', 'approximation (\rho_k = 1 \forall k)','approximation (\rho_1 = 10)', 'approximation (\rho_1 = 100)', 'approximation (\rho_1  = 1000)', '(x_i,y_i)')
% %legend('f(x)=cos(\pi\cdot x)', 'approximation (\rho_k = 1 \forall k)','approximation (\rho_1 = \rho_3 = 10)', 'approximation (\rho_1 = \rho_3 = 100)', 'approximation (\rho_1 = \rho_3 = 1000)', '(x_i,y_i)')

D = zeros(3);
i=1;
for  n = [5, 7, 10, 13, 15] 
   j=1;
   for m = [2, 3, 4, 5]
       [A, mDev, mDevMid] = smallestSq(f,m,n, range);
       D(i,j) = mDev;
	   % for k=1:1:dim(2)
	       % for s=1:1:m
	           % pow = s-1;
               % Y(i+j,k) = Y(i+j,k)+A(s,1).*X(1,k).^pow;
           % end
        % end
		% plot(X, Y(i+j,:));
       j=j+1;
   end
   i=i+1;
end
n = [5, 7, 10, 13, 15]
m = [2, 3, 4, 5]
[N,M] = meshgrid(n,m);
figure
axes1 = axes('Parent',figure);
hold (axes1, 'on');
mesh(M, N,D')
%zticks([0 0.25 0.5 0.75 1])
% zticklabels({'R = 0','R = 0.25','R=0.5', 'R=0.75', 'R=1'})
yticks([5 10 15])
yticklabels({'N = 5','N = 10','N=15'})
xticks([2 3 4 5])
xticklabels({'M = 2','M = 3','M=4','M=5'})
%title('максимальное отклонение f(x)=cos(\pi\cdot x) на [-1;1]: \rho_k=1 \forall k')
%title('макс. откл. P_m(x) от f(x)=1/(1+25x^2) на [-1;1]: if(x_k\in[-0.5;0.5])\rho_k=0.5')
% title('макс. откл. P_m(x) от f(x)=cos(\pi\cdot x) на [-1;1]: \rho_k=1 \forall k')
%title('макс. откл. P_m(x) от f(x)=cos(\pi\cdot x) на [-1;1]: if(x_k \in [-0.5;0.5])\rho_k=0.5')
%title('макс. откл. P_m(x) от f(x)=1/(1+25x^2) на [-1;1]: \rho_k=1 \forall k')
title('сумма квадратов отклонения S, f(x)=1/(1+25x^2), x \in [-1;1]')
%title('сумма квадратов отклонения S, f(x)=cos(\pi\cdot x), x \in [-1;1]')
view(axes1,[34 42]);
function [A, maxDev, maxDevMid]  = smallestSq(f, m, n, range)
% f is function handle
% n is a number of points in a net
% m-1 is a power of polynomial
coef = range(1,2)-range(1,1);
X = range(1,1):coef/(n-1):range(1,2);
Rho = ones(1,n);
%Rho(2) = rho_1;
%Rho(4) = rho_1;
for i = 1:n
    if X(i)< -0.5 || X(i) > 0.5 %X(i)> -0.5 && X(i) < 0.5
        %Rho(i) = 0.5;
    end
end
Rho
Y = f(X);
B = zeros(m,m);
F=zeros(m,1);
for i = 1:1:m
    pow = i-1;
    for k=1:1:n
        F(i,1)=F(i,1)+Rho(k)*Y(k)*X(k)^pow;
    end
    for j=1:1:m
        if j+i<=m+1 && i>1
            B(i, j) = B(i-1, j+1);
            continue;
        end
        pow = (i-1)+(j-1);
        for k=1:1:n
            B(i,j) = B(i,j)+ Rho(k)*X(k)^pow;
        end
    end
end
A = linsolve(B,F);

%deviation calculations
Yapprox=zeros(1,n);
for i=1:1:n
    for j=1:1:m
        pow = j-1;
        Yapprox(1,i) = Yapprox(1,i)+A(j,1).*X(1,i).^pow;
    end
end
Xmid = zeros(1,n-1);
for i = 1:1:n-1
    Xmid(1,i) = 0.5*(X(1,i)+X(1,i+1));
end
Ymid = f(Xmid);
YmidApprox = zeros(1,n-1);
for i=1:1:n-1
    for j=1:1:m
        pow = j-1;
        YmidApprox(1,i) = YmidApprox(1,i)+A(j,1).*Xmid(1,i).^pow;
    end
end
maxDev = sum((Yapprox-Y).^2);
maxDevMid = max(YmidApprox-Ymid);
end