function [b, a, br, ar] = log_regression_fit(x, y, title_suffix)
    x = log(x);
    y = log(y);
    
    [b, a, br, ar] = regression_fit(x, y, title_suffix);
    
    xlabel('x, logarithmic scale')
    ylabel('y, logarithmic scale')
    
    x_ticks = xticks;
    x_ticks = x_ticks(2:2:end);
    xticks(x_ticks);
    x_labels{numel(x_ticks)} = '';
    for i =1:numel(x_ticks)
        x_labels{i} = num2str(exp(x_ticks(1,i)), '%10.1e');
    end
    xticklabels(x_labels);
    
    y_ticks = yticks;
    y_labels{numel(y_ticks)} = '';
    for i =1:numel(y_ticks)
        y_labels{i} = num2str(exp(y_ticks(1,i)), '%10.1e');
    end
    yticklabels(y_labels);
end