function j = integralAndPlot (f, a, b, n)
    [j, X, Y] = trapeziumIntegral(f, a, b, n);
    figure
    hold on
    p1=plot(X, Y, 'r', 'LineWidth', 1.5);
    plot(X, zeros(size(X)), 'r', 'LineWidth', 1.5);
    plot([a a],[0 f(a)], 'r', 'LineWidth', 1.5);
    plot([b b],[0 f(b)], 'r', 'LineWidth', 1.5);
    Xdense = a-0.2:0.01:b+0.2;
    Ydense = f(Xdense);
    p2=plot(Xdense, Ydense, 'b');
    axis([a-0.2 b+0.2 min([0,f(a)-1]) max(f(a),f(b))+1])
    legend([p1, p2], 'figure: j=S(figure)', 'function y=f(x)');
    title(strcat('trapezoidal integral, number of points n=', string(n)));
end