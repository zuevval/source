% function x = inv_laplace_cdf(y)
% b = 1/sqrt(2); % scale parameter
% mu = 0; % mean (location parameter)
% if y >= 0.5
%     x = mu - b.*log(2 - 2.*y); 
% else
%     x = mu + b.*log(2.*y);
% end
% end

function x = inv_laplace_cdf(y)
b = 1/sqrt(2); % scale parameter
mu = 0; % mean (location parameter)
x = mu - b.*sign(y-0.5).*log(1-2.*abs(y-0.5));
end