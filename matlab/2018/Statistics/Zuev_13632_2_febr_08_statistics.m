%var 9 (distribution=gp (Generalized Pareto))
%math. statistics
format compact
k=1;
theta=0;
sigma=1;
Y1=random(makedist('GeneralizedPareto','k',k, 'theta',theta, 'sigma', sigma), 1, 100);
Y1=sort(Y1);
pdf_pareto = gppdf(Y1, k, sigma, theta);
cdf_pareto = gpcdf(Y1, k, sigma, theta);
figure
subplot(2,1,1)
hold on
title('PDF (Generalized Pareto, k=1, \theta=0, \sigma=1)');
plot(Y1, pdf_pareto)
subplot(2,1,2)
hold on
title('CDF (Generalized Pareto)');
plot(Y1, cdf_pareto, 'green')
%task 1
mu=1;
sigma=2;
Y=normrnd(mu,sigma,5,7);
display(Y, 'random numbers (normal distribution)');
%generalized Pareto
Y=random(makedist('gp'),5,7);
display(Y, 'random numbers (generalized Pareto)');
%randtool
load('gpvals.m', '-mat', 'gpvals');
%save('gpvals.m', 'gpvals');
display(gpvals, 'random numbers (generalized Pareto)(via randtool)');
%problem: displays nothing, thjogh matrix "gpvals" (100X1) exists in the
%workspace

%task 2
max1=max(Y);
display(max1, 'max(Y)');
min1=min(Y);
display(min1, 'min(Y)');
%task 3
j=int8(rand(1)*6)+1;
display(j, 'j');
display(sort(Y(:,j)), 'sorted column j of Y');
max2=max(Y(:,j));
display(max2, 'max(Y(:,j))');
min2=min(Y(:,j));
display(min2, 'min(Y(:,j))');

%task 4
mean_4_column = mean(Y(:,4));
display(mean_4_column, 'mean(Y(:,4))')
%task 5
mean_overall = mean(Y);
display(mean_overall, 'overall mean (Y)');
%task 6
median_4 = median(Y(:,4));
display(median_4, 'median(Y(:,4))')
%task 7
median_overall = median(Y);
display(median_overall, 'overall median (Y)');
%task 8
variance_4 = var(Y(:,4));
display(variance_4, 'variance (Y(:,4))')
%task 9
variance_overall = var(Y);
display(variance_overall, 'overall variance (Y)');
%task 10
std_deviation_4 = std(Y(:,4));
display(std_deviation_4, 'standard deviation (Y(:,4))')
%task 11
std_deviation_overall = std(Y);
display(std_deviation_overall, 'overall standard deviation (Y)');
%task 12
Y=random(makedist('gp'),5,7);
linear_corr = corr(Y);
display(linear_corr, 'linear correlation between columns (Y)')
[linear_corr_coeff, null_hyp] = corrcoef(Y);
display(linear_corr_coeff, 'correlation coefficients (Y)')
display(null_hyp, 'results of null hypotesis test (Y)')
%task 13
a=rand(1,5)
b=random(makedist('gp'),1,5)
corr_coeff2=corrcoef(a,b);
display(corr_coeff2, 'correlation between a & b');
%task 14
gm=geomean(b);
display(gm, 'geometric mean of elements in b');
%task 15
hm=harmmean(b);
display(hm, 'harmonic mean of elements in b');
%task 16
cov1=cov(Y);
display(cov1, 'covariation matrix for Y');

%task 17
mu=1;
sigma=0.1;
n1=normrnd(mu,sigma,1,100);
figure
hold on
title('CDF for normal distribution')
axis([0.7 1.4 0 1]);
pl1=cdfplot(n1);
y1=0.7:0.01:1.4;%bounds choose based on observation of previous plot
pl2=plot(y1,normcdf(y1, mu,sigma));
legend('empirical CDF', 'theoretical CDF');
hold off
display(n1(1:10), 'normal distribution (mu=1, sigma=0.1)');
A=2;
B=1;
weibull1=wblrnd(A,B,1,100);
display(weibull1(1:10), 'Weibull distribution (A=2, B=1)');
gamma1=gamrnd(A,B,1,100);
display(gamma1(1:10), 'gamma random numbers (A=1, B=2)');

%task 18
P1=cdf('gp', B, mu, sigma);
display(P1, 'probability of case x<B (generalized Pareto, mu, sigma)');
P2=1-cdf('gp', A, mu, sigma);
A=1;
B=2;
disp('A=1, B=2');
display(P2, 'probability of case x>A (generalized Pareto, mu, sigma)');
P3=P1-(1-P2);
display(P3, 'probability of case A<x<B (generalized Pareto, mu, sigma)');

%task 19
%normal distribution
Y1=random(makedist('Normal', 'mu', 5, 'sigma', 2), 1, 100);
[mu1,sigma1,muci1,sigmaci1] = normfit(Y1)
Y1=sort(Y1);
pdf_normal = normpdf(Y1, mu1, sigma1);
cdf_normal = normcdf(Y1, mu1, sigma1);
figure
subplot(2,1,1)
hold on
title('PDF (normal distribution, mu=5, sigma=2)');
plot(Y1, pdf_normal)
subplot(2,1,2)
hold on
title('CDF (normal distribution)');
plot(Y1, cdf_normal, 'green')
%weibull distribution
Y2=random(makedist('Weibull', 'a', 4, 'b', 1), 1, 100);
weibull_param_empiric = fitdist(Y2', 'Weibull')
Y2=sort(Y2);
pdf_weibull = wblpdf(Y2, mu1, sigma1);
cdf_weibull = wblcdf(Y2, mu1, sigma1);
figure
subplot(2,1,1)
hold on
title('PDF (Weibull distribution, a=4, b=1)');
plot(Y2, pdf_weibull)
subplot(2,1,2)
hold on
title('CDF (Weibull distribution)');
plot(Y2, cdf_weibull, 'green')
Y3=random(makedist('gamma', 'a', 3, 'b', 1.5), 1, 100);
[gam_param, pci] = gamfit(Y3)
Y3=sort(Y3);
pdf_gam=gampdf(Y3, 3, 1.5);
cdf_gam=gamcdf(Y3,3,1.5);
figure
subplot(2,1,1)
hold on
title('PDF (\gamma distribution, a=3, b=1.5)');
plot(Y3, pdf_gam)
subplot(2,1,2)
hold on
title('CDF (\gamma distribution)');
plot(Y3, cdf_gam, 'green')
Y4=trnd(ones(1,100));
fitdist(Y4','tLocationScale')
Y4=sort(Y4);
pdf_student=tpdf(Y4, 1);
cdf_student=tcdf(Y4, 1);
figure
subplot(2,1,1)
hold on
title('PDF (Student distribution, \nu=1)');
plot(Y4, pdf_student)
subplot(2,1,2)
hold on
title('CDF (Student distribution)');
plot(Y4, cdf_student, 'green')

%task 20
%randtool