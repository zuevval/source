T = readtable('../data/postprocessed/overall-data.csv');
% gross domestic product
gdp = table2array(T(:,2))';
% total visual impairment cases
total_vi = table2array(T(:,3))' .* 1000;
total_blind = table2array(T(:,4))' .* 1000;
gdp_loss = table2array(T(:,5))' .* 1e+6;
% population weighted regional labour force participation rate
pw_lfpr = table2array(T(:,6))';
% population weighted regional employment rate
pw_er = table2array(T(:,7))';

total_blind_filtered = sort(total_blind(total_blind ~= 0));
total_vi_filtered = sort(total_vi(total_blind ~= 0));
log_regression_fit(total_vi_filtered, total_blind_filtered, 'total blind to total VI cases');
