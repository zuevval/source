addpath('../lab1dists/src')
%clear

rng default; % For reproducibility
volumes = [20, 60, 100]; % sizes of samples
norm_data{size(volumes,2)} = [];
cauchy_data{size(volumes,2)} = [];
laplace_data{size(volumes,2)} = [];
uniform_data{size(volumes,2)} = [];
poisson_data{size(volumes,2)} = [];
for i = 1:size(volumes,2)
    norm_data{i} = sort(normrnd(0,1,volumes(i),1));
    cauchy_data{i} = sort(trnd(1,volumes(i),1));
    uniform_data{i} = sort(2*sqrt(3).*((rand(volumes(i),1) - .5)));
    laplace_data{i} = sort(inv_laplace_cdf(rand(volumes(i),1)));
    poisson_data{i} = sort(poissinv(rand(volumes(i),1),10));
end

dists_info = {...
    {'Cauchy distribution ($\mu=0, \sigma=1$)', cauchy_data, @(x)tcdf(x, 1)}...
    {'Uniform distribution ($a=-\sqrt{3}, b=\sqrt{3}$)', uniform_data, @(x)(uniform_cdf(x))}...
    {'Gaussian distribution ($\mu=0, \sigma=1$)', norm_data, @(x)normcdf(x)}...
    {'Laplace distribution ($\mu = 0, b=\frac{1}{\sqrt{2}})$', laplace_data, @(x)laplace_cdf(x)}...
    {'Poisson distribution ($\lambda=10$)', poisson_data, @(x)(poisscdf(x,10)), 'discrete'}};

subplots = {};
for dist = dists_info
    figure
    for i = 1:size(volumes,2)
        subplots{end+1} = subplot(size(volumes, 2),1, i);
        hold on
        title(strcat(dist{1,1}{1,1},...
        sprintf(', sample size = %d', volumes(i))),'interpreter','latex');
        yyaxis left
        ylabel('empirical pdf')
        % TODO plot empirical cdf
        yyaxis right
        fplot(dist{1,1}{1,3}, 'r')
        ylabel('CDF')
    end
end

for i = 1:size(volumes, 2)
    % TODO plot pdf
    % TODO make titles
    % TODO make 3 subplots (for 3 bandwidths)
    % TODO plot for other distributions
    kernel_density_estimate(cauchy_data{i})
end