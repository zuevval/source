addpath('../lab1dists/src')
%clear

rng default; % For reproducibility
volumes = [20, 100]; % sizes of samples
num_iter = 1000;
norm_data{size(volumes,2), num_iter} = [];
cauchy_data{size(volumes,2), num_iter} = [];
laplace_data{size(volumes,2), num_iter} = [];
uniform_data{size(volumes,2), num_iter} = [];
poisson_data{size(volumes,2), num_iter} = [];
for k = 1:num_iter
    for i = 1:size(volumes,2)
        norm_data{i,k} = sort(normrnd(0,1,volumes(i),1));
        cauchy_data{i,k} = sort(trnd(1,volumes(i),1));
        uniform_data{i,k} = sort(2*sqrt(3).*((rand(volumes(i),1) - .5)));
        laplace_data{i,k} = sort(inv_laplace_cdf(rand(volumes(i),1)));
        poisson_data{i,k} = sort(poissinv(rand(volumes(i),1),10));
    end
end

% boxplots
dists_info = {...
    {'Cauchy distribution (\mu=0, \sigma=1)', {cauchy_data{1,1} cauchy_data{2,1}}}...
    {'Uniform distribution (a=-sqrt(3), b=sqrt(3))', {uniform_data{1,1} uniform_data{2,1}}}...
    {'Gaussian distribution (\mu=0, \sigma=1)', {norm_data{1,1} norm_data{2,1}}}...
    {'Laplace distribution (\mu = 0, b=1/sqrt(2))', {laplace_data{1,1} laplace_data{2,1}}}...
    {'Poisson distribution (\lambda=10)', {poisson_data{1,1} poisson_data{2,1}}}};
for dist = dists_info
    figure
    suptitle(dist{1}{1})
    for i = 1:size(volumes,2)
        subplot(1, size(volumes, 2), i);
        hold on
        xlabel(sprintf('sample size = %d', volumes(i)))
        boxplot(dist{1}{2}{i})
    end
end

% outliers
[norm_outliers, norm_outl_var] = average_outliers_frac(norm_data);
[cauchy_outliers, cauchy_outl_var] = average_outliers_frac(cauchy_data);
[poisson_outliers, poisson_outl_var] = average_outliers_frac(poisson_data);
[laplace_outliers, laplace_outl_var] = average_outliers_frac(laplace_data);
[uniform_outliers, uniform_outl_var] = average_outliers_frac(uniform_data);

% expected outliers - continuous distributions
norm_outl_expected = outliers_probab(...
    @(p)norminv(p), @(x)normcdf(x));
cauchy_outl_expected = outliers_probab(...
    @(p)tinv(p, 1), @(x)tcdf(x, 1)); % Cauchy's = Student's with nu=1
laplace_outl_expected = outliers_probab(...
    @(p)(inv_laplace_cdf(p)), @(x)(laplace_cdf(x))); % defined in lab1
uniform_outl_expected = 0; % evidently

% expected outliers - Poisson distribution
lambda = 10;
q1 = poissinv(.25, lambda);
q3 = poissinv(.75, lambda);
x1 = .5*(5*q1 - 3*q3);
x2 = .5*(5*q3 - 3*q1);
p1 = poisscdf(x1, lambda) - poisspdf(x1, lambda);
p2 = poisscdf(x2, lambda);
poisson_outl_expected =  1 - p2 + p1;