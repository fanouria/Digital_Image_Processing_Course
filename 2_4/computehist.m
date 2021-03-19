function [ myHist ] = computehist( I )
%COMPUTEHIST Compute histogram of given image.

[m,n] = size(I);

myHist = zeros(1, 256);

for lum = 0:255
    myHist(lum + 1) = sum(sum(I == lum));
end

myHist = myHist / (m * n);

end