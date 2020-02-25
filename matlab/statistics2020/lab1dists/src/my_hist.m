function bars = my_hist(x, max_height)
h = histogram(x);
bars = h.Values;
h_max = max(max(bars));
if h_max > max_height
    bars = bars .* (max_height / h_max);
bar(x, bars)
end