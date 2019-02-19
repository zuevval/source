%Lecture with R.L.
%searching the function's root manually
%Integrating manually
x=0:0.1:10;
llim=0;
rlim=10;
mid=(llim+rlim)./2;
fmid=tan((sin(mid))^2);
frlim=tan(sin(rlim)^2);
fllim=tan(sin(llim)^2);
delta=10e-3;
while abs(fmid)>delta
    if (fmid*frlim<0)
        llim=mid;
    else
        rlim=mid;
    end
    mid=(rlim+llim)/2;
    fmid=tan(sin(mid)^2);
    frlim=tan(sin(rlim)^2);
end
Y=tan(sin(x));
figure
plot(x,Y)
grid on

function y = f01(x)
y = tan(sin(x));
end
