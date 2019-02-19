m1=30;
m2=3.6;
b1=1200;
b2=10;
%b1=0;
%b2=0;
c1=4650;
c2=400;

A=[m1  0;0  m2];
C=[c1 -c2;-c2 c2]; 
format compact
H=inv(A)*C
[V, D] = eig(H)
K = sqrt(D)
U1=V(:,1)/V(1,1)
U2=V(:,2)/V(1,2)

%figure
%hold on
%grid on
%plot(scope_x);
%legend('mass 1', 'mass 2')
%title('Position')