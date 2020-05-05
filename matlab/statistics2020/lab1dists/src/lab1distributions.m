rng default; % For reproducibility
volumes = [10, 50, 1000]; % sizes of samples on histograms
norm_data = {};
cauchy_data = {};
laplace_data = {};
uniform_data = {};
poisson_data = {};
for i = 1:size(volumes,2)
    % normal distribution
    norm_data{i} = normrnd(0,1,volumes(i),1);%mu=0 sigma=1 arrSize=volumes(i)
    % Cauchy distribution as Student's distribution with degree of freedom
    % v=1 (mean mu=0, scale gamma=1)
    cauchy_data{i} = trnd(1,volumes(i),1); % v=1 arrSize = (volumes(i),1)
    uniform_data{i} = 2*sqrt(3).*((rand(volumes(i),1) - .5));
    laplace_data{i} = inv_laplace_cdf(rand(volumes(i),1));
    poisson_data{i} = poissinv(rand(volumes(i),1),10); % lambda = 10
end

dists_info = {...
    {'Cauchy distribution ($\mu=0, \sigma=1$)', cauchy_data, @(x)(cauchy_pdf(x))}...
    {'Uniform distribution ($a=-\sqrt{3}, b=\sqrt{3}$)', uniform_data, @(x)(uniform_pdf(x))}...
    {'Gaussian distribution ($\mu=0, \sigma=1$)', norm_data, @(x)(norm_pdf(x))}...
    {'Laplace distribution ($\mu = 0, b=\frac{1}{\sqrt{2}})$', laplace_data, @(x)(laplace_pdf(x))}...
    {'Poisson distribution ($\lambda=10$)', poisson_data, @(x)(poisspdf(x,10)), 'discrete'}};
subplots = {};
for dist = dists_info
    figure
    for i = 1:size(volumes,2)
        subplots{end+1} = subplot(size(volumes, 2),1, i);
        hold on
        title(strcat(dist{1,1}{1,1},...
        sprintf(', sample size = %d', volumes(i))),'interpreter','latex');
        yyaxis left
        ylabel('histogram')
        histogram(dist{1,1}{1,2}{1,i})
        yyaxis right
        if size(dist{1,1}, 2) >= 4 % if discrete
            x = 1:20;
            y = dist{1,1}{1,3}(x);
            plot(y, '*');
        else
            fplot(dist{1,1}{1,3}, 'r')
        end
        ylabel('PDF')
    end
end