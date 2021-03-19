function [ equalizedImage ] = localeqhist( I, windowSize )
%LOCALEQHIST Equalize histogram given original image and its histogram.
[m,n] = size(I);
extendedImage = extendI(I, windowSize);

equalizedImage = uint8(zeros(m, n));

for row = round(windowSize/2):m + (round(windowSize/2) - 1)
    for col = round(windowSize/2):n + (round(windowSize/2) - 1)
        rowStart = row - (round(windowSize/2) - 1);
        rowEnd = row + round(windowSize/2) - 1;
        colStart = col - (round(windowSize/2) - 1);
        colEnd = col + round(windowSize/2) - 1;
        
        localHist = zeros(1, 256);
        for rowInd = rowStart:rowEnd
            for colInd = colStart:colEnd
                index = extendedImage( rowInd, colInd ) + 1;
                localHist(index) = localHist(index) + 1;
            end
        end  
        cdfValue = sum(localHist(1:extendedImage( row, col ) + 1)) / (windowSize * windowSize);
        equalizedImage(row - (round(windowSize/2) - 1), col - (round(windowSize/2) - 1)) = floor(255 * cdfValue);
    end
end
end