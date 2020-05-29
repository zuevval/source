function kernel_density_estimate(data, data_title, data_pdf, discrete)
x = -4:0.1:4;
h_norm = 0.337; % optimal bandwidth
bandwidths = [0.5*h_norm h_norm 2*h_norm];
subplots = {};
figure
for i = 1:size(bandwidths, 2)
    kernel = fitdist(data, 'kernel', 'BandWidth', bandwidths(i));
    y = pdf(kernel, x);
    subplots{end+1} = subplot(size(bandwidths, 2),1, i);
    hold on
    
    % kernel density estimate
    yyaxis left
    ylabel('KDE')
    plot(x,y,'Color','b','LineStyle','-')
    title(strcat(data_title,sprintf(', bandwidth = %.3f', bandwidths(i))),...
        'interpreter','latex')
    % probability density function
    yyaxis right
    ylabel('PDF')
    if discrete
        x = 1:20;
        y = data_pdf(x);
        plot(y, '*');
    else
        fplot(data_pdf, 'r')
    end
end
end