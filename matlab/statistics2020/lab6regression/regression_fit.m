function [a, b, ar, br] = regression_fit(x, y, y_ideal, title_suffix)
    figure
    hold on
    title(['linear regression fit: ' title_suffix])
    xlabel('x')
    ylabel('y')
    plot(x, y_ideal, 'g')
    plot(x, y, '*')

    % least squares
    mx = mean(x);
    my = mean(y);
    b = (mean(x.*y) - mx*my)/(mean(x.^2) - mx.^2);
    a = my - b*mx;
    y_least_sq = a*x + b;
    plot(x, y_least_sq, '--r')

    % least modules (robust estimate)
    br = rq(x,y)*qx(y)/qx(x);
    ar = median(y) - br*median(x);
    y_robust = ar*x + br;
    plot(x, y_robust, '--black')
    
    legend('model', 'data', 'least squares', 'least modules')
end