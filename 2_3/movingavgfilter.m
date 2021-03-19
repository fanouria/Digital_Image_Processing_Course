function result = movingavgfilter(x,windowSize)
% MEDIANFILTER input: image I 
%output: filtered image
[rows,cols] = size(x);
result = zeros(rows,cols);
m = windowSize-1; n = windowSize-1;

for i = 1:rows-m
    for j = 1:cols-n
        temp = x(i:i+m,j:j+n);
        result(i+m-1,j+n-1) = mean(temp(:));
    end
end


end