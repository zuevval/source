function y = f(x)
y=sin(1./x)./sin(x.*x-2.*x);function y = f1(x)
y=x.*x-cos(x);function y = f10 (x)
y = @(x) (x).^3+exp(4.*x)-5.5;
endfunction dydx = fun(x, y)
dydx = zeros(1,1);
dydx(1) = (x).^3.*cos(y(1))+0.1;
endfunction dydt = fun1(t, y)
dydt = zeros(5, 1);
dydt(1) = y(2);
dydt(2) = y()
endfunction y = fun2(x)
if x < -1
        y=-1;
    elseif x < 1
        y=x;
    else
        y=1;
    end

end