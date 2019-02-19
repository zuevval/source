P=zeros(11, 50);
K=zeros(1,50);
x=(0:1:10)';
for i=1:50
    k=10*rand;
    K(1,i)=k;
    P(:,i)=k.*power(x,2);
end
net=feedforwardnet(3);
[net,tr]=train(net,P,K);
% save nn1 net
p=8.90673.*power(x,2);
Y=sim(net,p);
disp(Y);