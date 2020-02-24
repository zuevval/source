% test/inv_laplace_cdf_test.m
addpath('../src/')
input_data = [0.1 0.25 0.5 0.75 0.9];
laplace_data = inv_laplace_cdf(input_data);
for i = 1:1:size(input_data, 2)/2
    assert(laplace_data(i) == -laplace_data(size(input_data,2)+1-i))
end
