function [b, a, br, ar] = regression_fit(x, y, y_ideal, title_suffix)
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
    y_least_sq = b*x + a;
    plot(x, y_least_sq, '--r')

    % least modules (robust estimate)
    ar = rq(x,y)*qx(y)/qx(x);
    br = median(y) - ar*median(x);
    y_robust = br*x + ar;
    plot(x, y_robust, '--black')
    
    legend('model', 'data', 'least squares', 'least modules')
end