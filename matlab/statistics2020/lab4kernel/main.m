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
    {'Poisson distribution ($\lambda=10$)', poisson_data}};

subplots = {};
for dist = dists_info
    figure
    for i = 1:size(volumes,2)
        subplots{end+1} = subplot(size(volumes, 2),1, i);
        hold on
        title(strcat(dist{1,1}{1,1},...
        sprintf(', sample size = %d', volumes(i))),'interpreter','latex');
        yyaxis left
        ecdf(dist{1,1}{1,2}{1,i})
        ylabel('empirical CDF')
        yyaxis right
        if numel(dist{1,1}) >= 3
            fplot(dist{1,1}{1,3}, 'r')
        else
            x_poiss_cdf = 2:0.1:20;
            y_poiss_cdf = poisscdf(x_poiss_cdf, 10);
            plot(x_poiss_cdf, y_poiss_cdf, 'r');
        end
        ylabel('CDF')
    end
end

dists_info2 = {...
    {'Cauchy distribution ($\mu=0, \sigma=1$)', cauchy_data, @(x)(cauchy_pdf(x))}...
    {'Uniform distribution ($a=-\sqrt{3}, b=\sqrt{3}$)', uniform_data, @(x)(uniform_pdf(x))}...
    {'Gaussian distribution ($\mu=0, \sigma=1$)', norm_data, @(x)(norm_pdf(x))}...
    {'Laplace distribution ($\mu = 0, b=\frac{1}{\sqrt{2}})$', laplace_data, @(x)(laplace_pdf(x))}...
    {'Poisson distribution ($\lambda=10$)', poisson_data, @(x)(poisspdf(x,10)), 'discrete'}};
subplots = {};
for dist = dists_info2
    for i = 1:size(volumes,2)
        dist_title = strcat(dist{1,1}{1,1},...
        sprintf(', sample size = %d', volumes(i)));
        if size(dist{1,1}, 2) >= 4 % if discrete
            discrete = true;
        else
            discrete = false;
        end
        kernel_density_estimate(dist{1,1}{1,2}{1,i}, dist_title,...
            dist{1,1}{1,3}, discrete)
    end
end