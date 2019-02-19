%statistics_draft
%task 19

%----Compliance intervals---

p=0.98; %desired probability
p1=1-p;
n=100; %cull quantity
nu=n-1;
t=tinv(1-p1/2,nu); %inverse of Student's CDF
chi_squared_l=chi2inv(1-p1/2,nu); %chi-square inverse CDF (left bound)
chi_squared_r=chi2inv(p1/2,nu); %chi-square (right bound)
TableData = [p, p1,t, chi_squared_l,chi_squared_l]'

%----Normal distribution----

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

%----Gamma distribution----

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

%----Student's distribution----

Y4=trnd(ones(1,100));
Y4=sort(Y4);
pdf_student=tpdf(Y4, 99); %99=100-1 (nu)
cdf_student=tcdf(Y4, 99);
figure
subplot(2,1,1)
hold on
title('PDF (Student distribution, \nu=1)');
plot(Y4, pdf_student)
subplot(2,1,2)
hold on
title('CDF (Student distribution)');
plot(Y4, cdf_student, 'green')