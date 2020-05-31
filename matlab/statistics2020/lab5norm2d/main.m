mu = [0, 0]; % means
sizes = [20, 60, 100];
rho_range = [0, 0.5, 0.9, 1]; % workaround: last for dists mix 
n_iter = 1000;

rng default; % For reproducibility
res_size = [numel(rho_range), numel(sizes)];
spearman_means = zeros(res_size);
spearman_sq_means = zeros(res_size);
spearman_variances = zeros(res_size);
pearson_means = zeros(res_size);
pearson_sq_means = zeros(res_size);
pearson_variances = zeros(res_size);
quadrant_means = zeros(res_size);
quadrant_sq_means = zeros(res_size);
quadrant_variances = zeros(res_size);
data_samples{numel(rho_range), numel(sizes)} = []; % data for plotting

for i_rho = 1:numel(rho_range)
    rho = rho_range(i_rho);
    sigma = [1, rho; rho, 1]; % covariances
    for i_size = 1:numel(sizes)
        spearman_corrcoefs = zeros(1, n_iter);
        pearson_corrcoefs = zeros(1, n_iter);
        quadrant_corrcoefs = zeros(1, n_iter);
        for i = 1:n_iter
            if rho == 1 % dists mix
                sigma1 = [1, 0.9; 0.9, 1];
                T1 = mvnrnd(mu, sigma1, sizes(i_size));
                sigma2 = [10, -0.9; -0.9, 10];
                T2 = mvnrnd(mu, sigma2, sizes(i_size));
                probabs = unifrnd(0, 1, 2, sizes(i_size))';
                Temp = T1 .* (probabs <= 0.9) + T2 .* (probabs > 0.9);
            else
                Temp = mvnrnd(mu,sigma,sizes(i_size));
            end
            pearson_corr_matrix = corrcoef(Temp);
            pearson_corrcoefs(1,i) = pearson_corr_matrix(1,2);
            spearman_corrcoefs(1,i) = corr(Temp(:,1),Temp(:,2),'Type','Spearman');
            quadrant_corrcoefs(1,i) = quadrant_corrcoef(Temp);
        end
        spearman_means(i_rho, i_size) = mean(spearman_corrcoefs);
        pearson_means(i_rho, i_size) = mean(pearson_corrcoefs);
        quadrant_means(i_rho, i_size) = mean(quadrant_corrcoefs);
        spearman_sq_means(i_rho, i_size) = mean(spearman_corrcoefs.^2);
        pearson_sq_means(i_rho, i_size) = mean(pearson_corrcoefs.^2);
        quadrant_sq_means(i_rho, i_size) = mean(quadrant_corrcoefs.^2);
        spearman_variances(i_rho, i_size) = var(spearman_corrcoefs);
        pearson_variances(i_rho, i_size) = var(pearson_corrcoefs);
        quadrant_variances(i_rho, i_size) = var(quadrant_corrcoefs);
        data_samples{i_rho, i_size} = Temp; % save 1 probe for plotting
    end
end

t = -0.05:0.05:2*pi;
rot_mtx = [1 -1; 1 1] ./ sqrt(2); % (x,y) = rot_mtx*(x1,y1)
rot_mtx1 = [1 1; -1 1] ./ sqrt(2); % (x1,y1) = rot_mtx*(x,y)
for i_rho = 1:numel(rho_range)-1
    rho = rho_range(i_rho);
    sigma = [1, rho; rho, 1]; % covariances
    sigma1 = sqrt(1 + rho);
    sigma2 = sqrt(1 - rho);
    for i_size = 1:numel(sizes)
        xy = data_samples{i_rho, i_size};
        x = xy(:,1);
        y = xy(:,2);
        figure
        hold on
        axis equal
        scatter(x,y)
        title(sprintf('bivariational normal distribution, rho =  %.1f, sample size= %d',...
            rho, sizes(i_size)), 'interpreter', 'latex')        
        xyrot = rot_mtx1 * [x';y'];
        xrot = xyrot(1,:);
        yrot = xyrot(2,:);
        r = ellips_r(xrot, yrot, sigma1, sigma2);
        
        x1 = r.*sigma1.*cos(t)';
        y1 = r.*sigma2.*sin(t)';
        xy_rot = rot_mtx * [x1';y1'];
        plot(xy_rot(1,:),xy_rot(2,:), 'r');
    end
end