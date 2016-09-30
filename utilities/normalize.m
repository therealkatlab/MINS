function res = normalize(data)

minV = min(double(data(:)));
maxV = max(double(data(:)));

if maxV == minV
    res = zeros(size(data));
    return ;
end

res = (double(data) - minV) ./ (maxV - minV);