function result = medianfilter(x,windowSize)
% MEDIANFILTER INPUT: image x 
%                     windowsize size of the window we are goingt o use  
% OUTPUT : fitered image

[m,n] = size(x);
extendedx = extendI(x,windowSize);
result = zeros(m,n);
center = round(windowSize/2);
middle = windowSize*windowSize / 2;

for i = center: m + (center - 1)
    for j = center: n + (center - 1)
        temp = extendedx(i - (center - 1) : i + center - 1, j - (center - 1): j + center - 1);        
        list = reshape(temp, [1 windowSize*windowSize]);
        sortedlist = sort(list); %sort the array
        
        if mod(windowSize^2, 2)
            medianValue = sortedlist(round(middle)); %odd case
        else
            medianValue = (sortedlist(middle) + sortedlist(middle + 1)) / 2; %even case
        end
        result(i - (center - 1), j - (center - 1)) = medianValue;
    end
% end
end
