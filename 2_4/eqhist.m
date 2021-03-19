function [ equalizedImage ] = eqhist( I)
% EQHIST Equalize histogram given original image.
 
[m,n] =  size(I);
 
equalizedImage = zeros(m, n);
hist = computehist(I);
 
for row = 1:m
    for col = 1:n
        equalizedImage(row, col) = floor(255 * sum(hist(1:I(row, col) + 1)));
    end
end
 
equalizedImage = uint8(equalizedImage);
 
end