%task 19

%----Compliance intervals---

p=0.98; %desired probability
p1=1-p;
n=100; %cull quantity
nu=n-1;
t=tinv(1-p1/2,nu); %inverse of Student's CDF
chi_squared_l=chi2inv(1-p1/2,nu); %chi-square inverse CDF (left bound)
chi_squared_r=chi2inv(p1/2,nu); %chi-square (right bound)
TableData = [t, chi_squared_l,chi_squared_l]';
 
Da=6*(n-1)/((n+1)*(n+3));%dispersion of a sample of skewness
De=24*n*(n-2)*(n-3)/((n+1)^2*(n+3)*(n+5));%dispersion of a sample of kurtosis
 
fprintf('dispersion of a sample of skewness & kurtosis\n Da=%5f De=%5f \n',Da,De);
display(p,'p');
disp('t(1-p/2,f)  chi2(1-p/2)  chi2(p/2,f)')
fprintf('%1.5f%14.5f%14.5f\n\n',TableData)
 
%----Normal distribution----
 
Y1=random(makedist('Normal', 'mu', 5, 'sigma', 2), 1, 100);
[mu1,sigma1,muci1,sigmaci1] = normfit(Y1)
 
mu_norm=mean(Y1);%general mean
var_norm = var(Y1);%general variance
sigm_norm=std(Y1);%standard deviation
skew_norm=skewness(Y1);
kurt_norm=kurtosis(Y1);
mu_compl_norm=[mu_norm-sigm_norm*t/n^0.5,mu_norm+sigm_norm*t/n^0.5];
disp('Compliance interval for general mean (Normal distribution, p=0.98)');
fprintf('%8.5f < mu <%8.5f\n',mu_compl_norm);
var_compl_norm=[nu*var_norm./chi_squared_l,nu*var_norm./chi_squared_r];
disp('Compliance interval for general variance (Normal distribution, p=0.98)');
fprintf('%8.5f < var <%8.5f\n',var_compl_norm);
skew_compl_norm=[skew_norm-(Da/p1).^0.5,skew_norm+(Da/p1).^0.5];
disp('Compliance interval for skewness (Normal distribution, p=0.98)');
fprintf('%8.5f < skewness <%8.5f\n',skew_compl_norm);
kurt_compl_norm=[kurt_norm-(De/p1).^0.5,kurt_norm+(De/p1).^0.5];
disp('Compliance interval for kurtosis (Normal distribution, p=0.98)');
fprintf('%8.5f < kurtosis <%8.5f\n',kurt_compl_norm);
 
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
 
mu_wbl=mean(Y2);%general mean
var_wbl = var(Y2);%general variance
sigm_wbl=std(Y2);%standard deviation
skew_wbl=skewness(Y2);
kurt_wbl=kurtosis(Y2);
mu_compl_wbl=[mu_wbl-sigm_wbl*t/n^0.5,mu_wbl+sigm_wbl*t/n^0.5];
disp('Compliance interval for general mean (Weibull distribution, p=0.98)');
fprintf('%8.5f < mu <%8.5f\n',mu_compl_wbl);
var_compl_wbl=[nu*var_wbl./chi_squared_l,nu*var_wbl./chi_squared_r];
disp('Compliance interval for general variance (Weibull distribution, p=0.98)');
fprintf('%8.5f < var <%8.5f\n',var_compl_wbl);
skew_compl_wbl=[skew_wbl-(Da/p1).^0.5,skew_wbl+(Da/p1).^0.5];
disp('Compliance interval for skewness (Weibull distribution, p=0.98)');
fprintf('%8.5f < skewness <%8.5f\n',skew_compl_wbl);
kurt_compl_wbl=[kurt_wbl-(De/p1).^0.5,kurt_wbl+(De/p1).^0.5];
disp('Compliance interval for kurtosis (Weibull distribution, p=0.98)');
fprintf('%8.5f < kurtosis <%8.5f\n',kurt_compl_wbl);
 
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
 
%----Gamma distribution----
 
Y3=random(makedist('gamma', 'a', 3, 'b', 1.5), 1, 100);
[gam_param, pci] = gamfit(Y3)
Y3=sort(Y3);
 
mu_gam=mean(Y1);%general mean
var_gam = var(Y3);%general variance
sigm_gam=std(Y3);%standard deviation
skew_gam=skewness(Y3);
kurt_gam=kurtosis(Y3);
mu_compl_gam=[mu_gam-sigm_gam*t/n^0.5,mu_gam+sigm_gam*t/n^0.5];
disp('Compliance interval for general mean (Gamma distribution, p=0.98)');
fprintf('%8.5f < mu <%8.5f\n',mu_compl_gam);
var_compl_gam=[nu*var_gam./chi_squared_l,nu*var_gam./chi_squared_r];
disp('Compliance interval for general variance (Gamma distribution, p=0.98)');
fprintf('%8.5f < var <%8.5f\n',var_compl_gam);
skew_compl_gam=[skew_gam-(Da/p1).^0.5,skew_gam+(Da/p1).^0.5];
disp('Compliance interval for skewness (Gamma distribution, p=0.98)');
fprintf('%8.5f < skewness <%8.5f\n',skew_compl_gam);
kurt_compl_gam=[kurt_gam-(De/p1).^0.5,kurt_gam+(De/p1).^0.5];
disp('Compliance interval for kurtosis (Gamma distribution, p=0.98)');
fprintf('%8.5f < kurtosis <%8.5f\n',kurt_compl_gam);
 
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
 
mu_t=mean(Y4);%general mean
var_t = var(Y4);%general variance
sigm_t=std(Y4);%standard deviation
skew_t=skewness(Y4);
kurt_t=kurtosis(Y4);
mu_compl_t=[mu_t-sigm_t*t/n^0.5,mu_t+sigm_t*t/n^0.5];
disp("Compliance interval for general mean (Student's distribution, p=0.98)");
fprintf('%8.5f < mu <%8.5f\n',mu_compl_t);
var_compl_t=[nu*var_t./chi_squared_l,nu*var_t./chi_squared_r];
disp("Compliance interval for general variance (Student's distribution, p=0.98)");
fprintf('%8.5f < var <%8.5f\n',var_compl_t);
skew_compl_t=[skew_t-(Da/p1).^0.5,skew_t+(Da/p1).^0.5];
disp("Compliance interval for skewness (Student's distribution, p=0.98)");
fprintf('%8.5f < skewness <%8.5f\n',skew_compl_t);
kurt_compl_t=[kurt_t-(De/p1).^0.5,kurt_t+(De/p1).^0.5];
disp("Compliance interval for kurtosis (Student's distribution, p=0.98)");
fprintf('%8.5f < kurtosis <%8.5f\n',kurt_compl_t);
 
Y4=sort(Y4);
pdf_student=tpdf(Y4, 99); %99=100-1 (nu)
cdf_student=tcdf(Y4, 99);
figure
subplot(2,1,1)
hold on
title('PDF (Student distribution, \nu=99)');
plot(Y4, pdf_student)
subplot(2,1,2)
hold on
title('CDF (Student distribution)');
plot(Y4, cdf_student, 'green')