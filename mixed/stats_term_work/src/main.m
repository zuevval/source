% -------------------------------------
% --------- preparing data ------------
% -------------------------------------
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
% prevalence of blindness, aged from __ to __
prevalence_0_14 = table2array(T(:,8))';
prevalence_15_49 = table2array(T(:,9))';
prevalence_50_inf = table2array(T(:,10))';
% No. of blind persons aged from __ to __
blinds_0_14 = table2array(T(:,11))';
blinds_15_49 = table2array(T(:,12))';
blinds_50_inf = table2array(T(:,13))';


% -------------------------------------
% ------- fitting regressions ---------
% -------------------------------------
total_blind_filtered = sort(total_blind(total_blind ~= 0));
total_vi_filtered = sort(total_vi(total_blind ~= 0));
log_regression_fit(total_vi_filtered, total_blind_filtered,...
    'blind cases against VI cases', 'total VI cases', 'total blind cases');
% employment rate and VI
y_datas = {prevalence_0_14, prevalence_15_49, prevalence_50_inf};
titles = {
    'POB against ER, persons under 15 years'
    'POB against ER, age 15 years - 49 years'
    'POB against ER, persons over 50 years'
    };
for i = 1:numel(y_datas)
    regression_fit(pw_er, y_datas{i}, titles{i},...
        'employment rate from 0 to 1', 'prevalence (%)')
end

y_datas = {blinds_0_14, blinds_15_49, blinds_50_inf};
titles = {
    'No. of blind against LFPR, persons under 15 years'
    'No. of blind against LFPR, age 15 years - 49 years'
    'No. of blind against LFPR, persons over 50 years'
    };
for i = 1:numel(y_datas)
    regression_fit(pw_lfpr, y_datas{i}, titles{i},...
        'labour force participation rate', 'number of blind cases')
end

% fitlm(pw_lfpr, blinds_15_49)
