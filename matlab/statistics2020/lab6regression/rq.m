function res = rq(x, y) % x, y: arrays of same size
res = 1/numel(x)*sum((sign(x-median(x)).*sign(y-median(y))));
end