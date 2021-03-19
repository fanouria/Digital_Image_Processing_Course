function result = imquant(x,method,p)
% 32x32 blocks as input

if strcmp(method,'zonal')
    %Keep percent of the coefficients with maximum variance across all subimages
    p = round(numel(x)*p);
    zonalMask = zeros(32,32);
    indices = zigzag(32); %zigzag image
    for i = 1:p
        %keep p ones in image 
        zonalMask(indices(i)) = 1;
    end
    result = x.*zonalMask;
    
elseif strcmp(method,'threshold')
    % Keep p percent of the coefficients with the biggest magnitude
    xsort = sort(reshape(abs(x),numel(x),1),'descend');
    p = round(numel(x)*p);
    th = xsort(p);
    result = round(x .* (abs(x) >= th));
end
