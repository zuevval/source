%exercise 1
A=10.*rand(10,10);
adim = size(A);
for i=1:1:adim(1,1)
    for j = 1:1:adim(1,2)
    t = A(i,j);
    while(t~=fix(t))
        t = 10.*t;
    end
        if rem(t,2) == 0
            A(i,j)=2;
        end
    end
end
%note: double values are stored with up to 15 chars in mantissa
for i = 1:1:adim(1,1)
    A(i,i) = 1;
end
display(A);

%exercise 2
step = 0.01;
X=-4:step:4
dim = size(X);
Y = zeros(dim);
for i = 1:1:dim(1,2)
    if step*i-4 < -pi/2
        Y(1,i) = sin(X(1,i));
    elseif step*i-4 < pi/2
        Y(1,i) = 2*X(1,i)/pi;
    else
        Y(1,i) = 1;
    end
end
figure
subplot(2, 1, 1)
plot(X,Y)
axis([-4 4 -1.5 1.5]);
subplot(2,1,2)

prompt = 'Type in X value:'
x1 = input(prompt)

flag = false;
if x1<-4 || x1 > 4
    display('error, x exceeds given diapasone');
elseif x1 < -pi/2
    Axis = [-4 -pi/2 -1.5 1.5];
    flag = true;
elseif x1 < pi/2
    Axis = [-pi/2 pi/2 -1.5 1.5];
    flag = true;
else
    Axis = [pi/2 4 -1.5 1.5];
    flag = true;
end
if flag == true
    plot(X,Y)
   axis (Axis);
end

%exercise 3
X=-pi/2:0.02:pi/2
num = size(X);
Y=zeros(num);
for i=1:1:num(1,2)
    if X(1,i) < -1
        Y(1,i)=-1;
    elseif X(1,i) < 1
        Y(1,i)=X(1,i);
    else
        Y(1,i)=1;
    end
end
figure
hold on
grid on
plot(X,Y)
axis([-pi/2 pi/2 -1.5 1.5])

%ex 4 (table)
load('conditionals_table.m', '-mat', 'T');
display(T);
%histogram of our transcripts' identification numbers
figure
hold on
grid on
title('transcritp ID');
histogram(str2double(table2array(T(:,2))));

%additonal task
T_add=table(X',Y', 'VariableNames', {'X', 'Y'});
T_add = T_add(30:40, :)
