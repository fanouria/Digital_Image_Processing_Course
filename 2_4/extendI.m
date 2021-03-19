function [ extI ] = extendI( I, windowSize )
%EXTENDI Extends the image on each edge
%It mirrors the image on each edge to process it with a window.

[m,n] = size(I);

extI = zeros(m +  2 * (round(windowSize/2) - 1), n + 2 * (round(windowSize/2) - 1));
extI(round(windowSize/2):m + round(windowSize/2) - 1, round(windowSize/2):n + round(windowSize/2) - 1) = I;
%top rows
extI(1:round(windowSize/2) - 1, round(windowSize/2):n + (round(windowSize/2) - 1)) = flipud(I(2:round(windowSize/2), :));
%bottom rows
extI(m + round(windowSize/2):m +  2 * (round(windowSize/2) - 1), round(windowSize/2):n + (round(windowSize/2) - 1)) = flipud(I(m - (round(windowSize/2) - 1):m - 1, :));
%left column
extI(round(windowSize/2):m + (round(windowSize/2) - 1), 1:round(windowSize/2) - 1) = fliplr(I(:, 2:round(windowSize/2)));
%right column
extI(round(windowSize/2):m + (round(windowSize/2) - 1), n + round(windowSize/2):n +  2 * (round(windowSize/2) - 1)) = fliplr(I(:, n - (round(windowSize/2) - 1):n - 1));
%top left corner
extI(1:round(windowSize/2)-1, 1:round(windowSize/2)-1) = rot90(I(2:1+round(windowSize/2)-1, 2:1+round(windowSize/2)-1), 2);
%top right corner
extI(1:round(windowSize/2)-1, n + round(windowSize/2):end) = rot90(I(2:round(windowSize/2), n - (round(windowSize/2)-1):n-1), 2);
%bottom left corner
extI(m + round(windowSize/2):end, 1:round(windowSize/2)-1) = rot90(I(m - (round(windowSize/2)-1):m-1, 2:1+round(windowSize/2)-1), 2);
%bottom right corner
extI(m + round(windowSize/2):end, n + round(windowSize/2):end) = rot90(I(m - (round(windowSize/2)-1):m-1, n - (round(windowSize/2)-1):n-1), 2);


end
