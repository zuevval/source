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
col1 = [10 100 1000]';
normZrsM = mean(norm_zrs, 2);
normZqsM = mean(norm_zqs, 2);
normMeansM = mean(norm_means, 2);
normMedsM = mean(norm_medians, 2);
normZtrsM = mean(norm_ztrs, 2);
norm_m = [col1 normZrsM normZqsM normMeansM normMedsM normZtrsM];
norm_m_str = ' & $' + string(round(norm_m, 3)) + '$';
writetable(array2table(norm_m_str), 'data/norm_m.txt', 'Delimiter', ' ');
fid  = fopen('data/norm_m.txt','r');
f=fread(fid,'*char')';
fclose(fid);
f = strrep(f,'"','');
fid  = fopen('data/norm_m.txt','w');
fprintf(fid,'%s',f);
fclose(fid);

normMeansV = var(norm_means, 0, 2);
normZrsV = var(norm_zrs, 0, 2);
normZqsV = var(norm_zqs,0, 2);
normMeansV = var(norm_means, 0, 2);
normMedsV = var(norm_medians, 0, 2);
normZtrsV = var(norm_ztrs, 0, 2);
norm_v = [col1 normZrsV normZqsV normMeansV normMedsV normZtrsV];
norm_v_str = ' & $' + string(round(norm_v, 3)) + '$';
writetable(array2table(norm_v_str), 'data/norm_v.txt', 'Delimiter', ' ');
fid  = fopen('data/norm_v.txt','r');
f=fread(fid,'*char')';
fclose(fid);
f = strrep(f,'"','');
fid  = fopen('data/norm_v.txt','w');
fprintf(fid,'%s',f);
fclose(fid);

cauchyZrsM = mean(cauchy_zrs, 2);
cauchyZqsM = mean(cauchy_zqs, 2);
cauchyMeansM = mean(cauchy_means, 2);
cauchyMedsM = mean(cauchy_medians, 2);
cauchyZtrsM = mean(cauchy_ztrs, 2);
cauchy_m = [col1 cauchyZrsM cauchyZqsM cauchyMeansM cauchyMedsM cauchyZtrsM];
cauchy_m_str = ' & $' + string(round(cauchy_m, 3)) + '$';
writetable(array2table(cauchy_m_str), 'data/cauchy_m.txt', 'Delimiter', ' ');
fid  = fopen('data/cauchy_m.txt','r');
f=fread(fid,'*char')';
fclose(fid);
f = strrep(f,'"','');
fid  = fopen('data/cauchy_m.txt','w');
fprintf(fid,'%s',f);
fclose(fid);

cauchyMeansV = var(cauchy_means, 0, 2);
cauchyZrsV = var(cauchy_zrs, 0, 2);
cauchyZqsV = var(cauchy_zqs,0, 2);
cauchyMeansV = var(cauchy_means, 0, 2);
cauchyMedsV = var(cauchy_medians, 0, 2);
cauchyZtrsV = var(cauchy_ztrs, 0, 2);
cauchy_v = [col1 cauchyZrsV cauchyZqsV cauchyMeansV cauchyMedsV cauchyZtrsV];
cauchy_v_str = ' & $' + string(round(cauchy_v, 3)) + '$';
writetable(array2table(cauchy_v_str), 'data/cauchy_v.txt', 'Delimiter', ' ');
fid  = fopen('data/cauchy_v.txt','r');
f=fread(fid,'*char')';
fclose(fid);
f = strrep(f,'"','');
fid  = fopen('data/cauchy_v.txt','w');
fprintf(fid,'%s',f);
fclose(fid);

laplaceZrsM = mean(laplace_zrs, 2);
laplaceZqsM = mean(laplace_zqs, 2);
laplaceMeansM = mean(laplace_means, 2);
laplaceMedsM = mean(laplace_medians, 2);
laplaceZtrsM = mean(laplace_ztrs, 2);
laplace_m = [col1 laplaceZrsM laplaceZqsM laplaceMeansM laplaceMedsM laplaceZtrsM];
laplace_m_str = ' & $' + string(round(laplace_m, 3)) + '$';
writetable(array2table(laplace_m_str), 'data/laplace_m.txt', 'Delimiter', ' ');
fid  = fopen('data/laplace_m.txt','r');
f=fread(fid,'*char')';
fclose(fid);
f = strrep(f,'"','');
fid  = fopen('data/laplace_m.txt','w');
fprintf(fid,'%s',f);
fclose(fid);

laplaceMeansV = var(laplace_means, 0, 2);
laplaceZrsV = var(laplace_zrs, 0, 2);
laplaceZqsV = var(laplace_zqs,0, 2);
laplaceMeansV = var(laplace_means, 0, 2);
laplaceMedsV = var(laplace_medians, 0, 2);
laplaceZtrsV = var(laplace_ztrs, 0, 2);
laplace_v = [col1 laplaceZrsV laplaceZqsV laplaceMeansV laplaceMedsV laplaceZtrsV];
laplace_v_str = ' & $' + string(round(laplace_v, 3)) + '$';
writetable(array2table(laplace_v_str), 'data/laplace_v.txt', 'Delimiter', ' ');
fid  = fopen('data/laplace_v.txt','r');
f=fread(fid,'*char')';
fclose(fid);
f = strrep(f,'"','');
fid  = fopen('data/laplace_v.txt','w');
fprintf(fid,'%s',f);
fclose(fid);

poissonZrsM = mean(poisson_zrs, 2);
poissonZqsM = mean(poisson_zqs, 2);
poissonMeansM = mean(poisson_means, 2);
poissonMedsM = mean(poisson_medians, 2);
poissonZtrsM = mean(poisson_ztrs, 2);
poisson_m = [col1 poissonZrsM poissonZqsM poissonMeansM poissonMedsM poissonZtrsM];
poisson_m_str = ' & $' + string(round(poisson_m, 3)) + '$';
writetable(array2table(poisson_m_str), 'data/poisson_m.txt', 'Delimiter', ' ');
fid  = fopen('data/poisson_m.txt','r');
f=fread(fid,'*char')';
fclose(fid);
f = strrep(f,'"','');
fid  = fopen('data/poisson_m.txt','w');
fprintf(fid,'%s',f);
fclose(fid);

poissonMeansV = var(poisson_means, 0, 2);
poissonZrsV = var(poisson_zrs, 0, 2);
poissonZqsV = var(poisson_zqs,0, 2);
poissonMeansV = var(poisson_means, 0, 2);
poissonMedsV = var(poisson_medians, 0, 2);
poissonZtrsV = var(poisson_ztrs, 0, 2);
poisson_v = [col1 poissonZrsV poissonZqsV poissonMeansV poissonMedsV poissonZtrsV];
poisson_v_str = ' & $' + string(round(poisson_v, 3)) + '$';
writetable(array2table(poisson_v_str), 'data/poisson_v.txt', 'Delimiter', ' ');
fid  = fopen('data/poisson_v.txt','r');
f=fread(fid,'*char')';
fclose(fid);
f = strrep(f,'"','');
fid  = fopen('data/poisson_v.txt','w');
fprintf(fid,'%s',f);
fclose(fid);

uniformZrsM = mean(uniform_zrs, 2);
uniformZqsM = mean(uniform_zqs, 2);
uniformMeansM = mean(uniform_means, 2);
uniformMedsM = mean(uniform_medians, 2);
uniformZtrsM = mean(uniform_ztrs, 2);
uniform_m = [col1 uniformZrsM uniformZqsM uniformMeansM uniformMedsM uniformZtrsM];
uniform_m_str = ' & $' + string(round(uniform_m, 3)) + '$';
writetable(array2table(uniform_m_str), 'data/uniform_m.txt', 'Delimiter', ' ');
fid  = fopen('data/uniform_m.txt','r');
f=fread(fid,'*char')';
fclose(fid);
f = strrep(f,'"','');
fid  = fopen('data/uniform_m.txt','w');
fprintf(fid,'%s',f);
fclose(fid);

uniformMeansV = var(uniform_means, 0, 2);
uniformZrsV = var(uniform_zrs, 0, 2);
uniformZqsV = var(uniform_zqs,0, 2);
uniformMeansV = var(uniform_means, 0, 2);
uniformMedsV = var(uniform_medians, 0, 2);
uniformZtrsV = var(uniform_ztrs, 0, 2);
uniform_v = [col1 uniformZrsV uniformZqsV uniformMeansV uniformMedsV uniformZtrsV];
uniform_v_str = ' & $' + string(round(uniform_v, 3)) + '$';
writetable(array2table(uniform_v_str), 'data/uniform_v.txt', 'Delimiter', ' ');
fid  = fopen('data/uniform_v.txt','r');
f=fread(fid,'*char')';
fclose(fid);
f = strrep(f,'"','');
fid  = fopen('data/uniform_v.txt','w');
fprintf(fid,'%s',f);
fclose(fid);
