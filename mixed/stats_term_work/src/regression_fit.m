function [b, a, br, ar] = regression_fit(x, y, title_suffix, x_label, y_label)
    figure
    hold on
    title(['linear regression fit: ' title_suffix])
    xlabel(x_label)
    ylabel(y_label)
    plot(x, y, '*')

    % least squares
    mx = mean(x);
    my = mean(y);
    a = (mean(x.*y) - mx*my)/(mean(x.^2) - mx.^2);
    b = my - a*mx;
    y_least_sq = a*x + b;
    plot(x, y_least_sq, 'r')

    % least modules (robust estimate)
    med_x = median(x);
    med_y = median(y);
    rq_xy = 1/numel(x)*sum((sign(x-med_x).*sign(y-med_y)));
    ar = rq_xy*interquartile_diff(y)/interquartile_diff(x);
    br = med_y - ar*med_x;
    y_robust = ar*x + br;
    plot(x, y_robust, 'black')
    
    legend('data', 'least squares', 'least modules')
    
    diff_least_sq = y_least_sq - y;
    h_lsq = chi2gof(diff_least_sq);
    
    diff_robust = y_robust - y;
    h_robust = chi2gof(diff_robust);
end