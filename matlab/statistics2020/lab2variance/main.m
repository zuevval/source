addpath('../lab1dists/src')
%clear

rng default; % For reproducibility
volumes = [10, 100, 1000]; % sizes of samples on histograms
num_iter = 1000;
norm_data{size(volumes,2), num_iter} = [];
cauchy_data{size(volumes,2), num_iter} = [];
laplace_data{size(volumes,2), num_iter} = [];
uniform_data{size(volumes,2), num_iter} = [];
poisson_data{size(volumes,2), num_iter} = [];
for k = 1:num_iter
    for i = 1:size(volumes,2)
        % normal distribution
        norm_data{i,k} = sort(normrnd(0,1,volumes(i),1));%mu=0 sigma=1 arrSize=volumes(i)
        % Cauchy distribution as Student's distribution with degree of freedom
        % v=1 (mean mu=0, scale gamma=1)
        cauchy_data{i,k} = sort(trnd(1,volumes(i),1)); % v=1 arrSize = (volumes(i),1)
        uniform_data{i,k} = sort(2*sqrt(3).*((rand(volumes(i),1) - .5)));
        laplace_data{i,k} = sort(inv_laplace_cdf(rand(volumes(i),1)));
        poisson_data{i} = sort(poissinv(rand(volumes(i),1),10)); % lambda = 10
    end
end

%  each 2-dim array of means:
%  1st row: (means of 10 elements' selections)
%  2nd row: (means of 100 elements' selections)
%  3rd row: (means of 1000 elements' selections) 
norm_means(size(volumes,2), num_iter) = 0;
cauchy_means(size(volumes,2), num_iter) = 0;
laplace_means(size(volumes,2), num_iter) = 0;
uniform_means(size(volumes,2), num_iter) = 0;
poisson_means(size(volumes,2), num_iter) = 0;
for k = 1:num_iter
    for i = 1:size(volumes,2)
        norm_means(i,k) = mean(norm_data{i,k});
        cauchy_means(i,k) = mean(cauchy_data{i,k});
        laplace_means(i,k) = mean(laplace_data{i,k});
        uniform_means(i,k) = mean(uniform_data{i,k});
        poisson_means(i,k) = mean(norm_data{i,k});
    end
end

norm_medians(size(volumes,2), num_iter) = 0;
cauchy_medians(size(volumes,2), num_iter) = 0;
laplace_medians(size(volumes,2), num_iter) = 0;
uniform_medians(size(volumes,2), num_iter) = 0;
poisson_medians(size(volumes,2), num_iter) = 0;
for k = 1:num_iter
    for i = 1:size(volumes,2)
        norm_medians(i,k) = median(norm_data{i,k});
        cauchy_medians(i,k) = median(cauchy_data{i,k});
        laplace_medians(i,k) = median(laplace_data{i,k});
        uniform_medians(i,k) = median(uniform_data{i,k});
        poisson_medians(i,k) = median(norm_data{i,k});
    end
end

norm_medians(size(volumes,2), num_iter) = 0;
cauchy_medians(size(volumes,2), num_iter) = 0;
laplace_medians(size(volumes,2), num_iter) = 0;
uniform_medians(size(volumes,2), num_iter) = 0;
poisson_medians(size(volumes,2), num_iter) = 0;
for k = 1:num_iter
    for i = 1:size(volumes,2)
        norm_medians(i,k) = median(norm_data{i,k});
        cauchy_medians(i,k) = median(cauchy_data{i,k});
        laplace_medians(i,k) = median(laplace_data{i,k});
        uniform_medians(i,k) = median(uniform_data{i,k});
        poisson_medians(i,k) = median(norm_data{i,k});
    end
end

norm_zrs(size(volumes,2), num_iter) = 0;
cauchy_zrs(size(volumes,2), num_iter) = 0;
laplace_zrs(size(volumes,2), num_iter) = 0;
uniform_zrs(size(volumes,2), num_iter) = 0;
poisson_zrs(size(volumes,2), num_iter) = 0;
for k = 1:num_iter
    for i = 1:size(volumes,2)
        norm_zrs(i,k) = zr(norm_data{i,k});
        cauchy_zrs(i,k) = zr(cauchy_data{i,k});
        laplace_zrs(i,k) = zr(laplace_data{i,k});
        uniform_zrs(i,k) = zr(uniform_data{i,k});
        poisson_zrs(i,k) = zr(norm_data{i,k});
    end
end

% interquartile ranges (TODO: try matlab native method `iqr`)
norm_zqs(size(volumes,2), num_iter) = 0;
cauchy_zqs(size(volumes,2), num_iter) = 0;
laplace_zqs(size(volumes,2), num_iter) = 0;
uniform_zqs(size(volumes,2), num_iter) = 0;
poisson_zqs(size(volumes,2), num_iter) = 0;
for k = 1:num_iter
    for i = 1:size(volumes,2)
        norm_zqs(i,k) = zq(norm_data{i,k});
        cauchy_zqs(i,k) = zq(cauchy_data{i,k});
        laplace_zqs(i,k) = zq(laplace_data{i,k});
        uniform_zqs(i,k) = zq(uniform_data{i,k});
        poisson_zqs(i,k) = zq(norm_data{i,k});
    end
end

norm_ztrs(size(volumes,2), num_iter) = 0;
cauchy_ztrs(size(volumes,2), num_iter) = 0;
laplace_ztrs(size(volumes,2), num_iter) = 0;
uniform_ztrs(size(volumes,2), num_iter) = 0;
poisson_ztrs(size(volumes,2), num_iter) = 0;
for k = 1:num_iter
    for i = 1:size(volumes,2)
        norm_ztrs(i,k) = ztr(norm_data{i,k});
        cauchy_ztrs(i,k) = ztr(cauchy_data{i,k});
        laplace_ztrs(i,k) = ztr(laplace_data{i,k});
        uniform_ztrs(i,k) = ztr(uniform_data{i,k});
        poisson_ztrs(i,k) = ztr(norm_data{i,k});
    end
end

% For mean, median, Z_r, Z_q and Z_tr calculate their means and variances
display(mean(norm_means, 2), 'norm:mean:means')
display(var(norm_medians, 0, 2), 'norm:mean:variances')
display(mean(norm_medians, 2), 'norm:median:means')
display(var(norm_means, 0, 2), 'norm:median:variances')
display(mean(norm_ztrs, 2), 'norm:Ztr:means')
display(var(norm_ztrs, 0, 2), 'norm:Ztr:variances')

display(mean(cauchy_means, 2), 'cauchy:mean:means')
display(var(cauchy_medians, 0, 2), 'cauchy:mean:variances')
display(mean(cauchy_medians, 2), 'cauchy:median:means')
display(var(cauchy_means, 0, 2), 'cauchy:median:variances')
display(mean(cauchy_ztrs, 2), 'cauchy:Ztr:means')
display(var(cauchy_ztrs, 0, 2), 'cauchy:Ztr:variances')

display(mean(laplace_means, 2), 'laplace:mean:means')
display(var(laplace_medians, 0, 2), 'laplace:mean:variances')
display(mean(laplace_medians, 2), 'laplace:median:means')
display(var(laplace_means, 0, 2), 'laplace:median:variances')
display(mean(laplace_ztrs, 2), 'laplace:Ztr:means')
display(var(laplace_ztrs, 0, 2), 'laplace:Ztr:variances')

display(mean(poisson_means, 2), 'poisson:mean:means')
display(var(poisson_medians, 0, 2), 'poisson:mean:variances')
display(mean(poisson_medians, 2), 'poisson:median:means')
display(var(poisson_means, 0, 2), 'poisson:median:variances')
display(mean(poisson_ztrs, 2), 'poisson:Ztr:means')
display(var(poisson_ztrs, 0, 2), 'poisson:Ztr:variances')

display(mean(uniform_means, 2), 'uniform:mean:means')
display(var(uniform_medians, 0, 2), 'uniform:mean:variances')
display(mean(uniform_medians, 2), 'uniform:median:means')
display(var(uniform_means, 0, 2), 'uniform:median:variances')
display(mean(uniform_ztrs, 2), 'uniform:Ztr:means')
display(var(uniform_ztrs, 0, 2), 'uniform:Ztr:variances')
