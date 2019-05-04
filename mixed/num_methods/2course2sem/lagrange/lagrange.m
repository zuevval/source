%n is messed up
%n = 5;
%X = -1:2/n:1;
%Xmid = -1+1/n:2/n:1;
Y1 = cos(pi.*X);
Y2 = 1./(1+25.*(X.^2));
Ymid1 = cos(pi.*Xmid); %points between the net points
Ymid2 = 1./(1+25.*(Xmid.^2));
len1 = size(Y1);
len2 = size(Ymid1);
Lnmid1 = zeros(1,len2(1,2));
Lnmid2 = Lnmid1;
for s= 1:1:len2(1,2) %should be =n
    for i = 1:1:len1(1,2) %should be =(n+1)
        t = 1;
        for j = 1:1:len1(1,2)
            if i==j; continue; end
            t = t*(Xmid(1,s) - X(1,j));
            t = t/(X(1,i)-X(1,j));
        end
        Lnmid1(1,s) =Lnmid1(1,s) + t*Y1(i);
        Lnmid2(1,s) =Lnmid2(1,s) + t*Y2(i);
    end
end
R1 = Lnmid1 - Ymid1;
R2 = Lnmid2 - Ymid2;

Xdense = -1:0.01:1;
len3 = size(Xdense);
Ydense1 = zeros(1,len3(1,2));
Ydense2 = Ydense1;
for s= 1:1:len3(1,2)
    for i = 1:1:len1(1,2) %should be =(n+1)
        t = 1;
        for j = 1:1:len1(1,2)
            if i==j; continue; end
            t = t*(Xdense(1,s) - X(1,j));
            t = t/(X(1,i)-X(1,j));
        end
        Ydense1(1,s) =Ydense1(1,s) + t*Y1(i);
        Ydense2(1,s) =Ydense2(1,s) + t*Y2(i);
    end
end