function [ fI ] = myWiener( I, windowSize, noisePower )
%MYWIENER
if strcmp(noisePower,'UNKNOWN') 
    noisePower = NoiseEstimation(I);
end

extendedI = extendI(I, windowSize);
[rows, columns] = size(I);

fI = zeros(rows, columns);
for row = round(windowSize/2):rows + (round(windowSize/2) - 1)
    for col = round(windowSize/2):columns + (round(windowSize/2) - 1)
        rect = extendedI(row - (round(windowSize/2) - 1) : row + round(windowSize/2) - 1, col - (round(windowSize/2) - 1): col + round(windowSize/2) - 1);
        rect = reshape(rect, [1 windowSize*windowSize]);
        rect = double(rect);
        localMean = mean(rect);
        localVar = var(rect);
        fI(row - (round(windowSize/2) - 1), col - (round(windowSize/2) - 1)) = localMean + localVar / (localVar + noisePower) * (extendedI(row, col) - localMean);
    end
end

end

