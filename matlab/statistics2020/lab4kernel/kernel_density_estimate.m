function kernel_density_estimate(data)
x = -4:0.1:4;
h_norm = 0.337; % optimal bandwidth
for bandwidth = [0.5*h_norm h_norm 2*h_norm]
    kernel = fitdist(data, 'kernel', 'BandWidth', bandwidth);
    y = pdf(kernel, x);
    figure
    hold on
    plot(x,y,'Color','r','LineStyle','-')
end
end