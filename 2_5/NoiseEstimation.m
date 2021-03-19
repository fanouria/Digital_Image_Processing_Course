function [ noisePower ] = NoiseEstimation( inputImage )
%NOISEESTIMATION Estimates power of noise in given image.
%   This method works under the assumption that we have AWGN and that the
%   image does not contain many high frequencies. As a result most of the
%   power concentrated around high frequency bands can be attributed to
%   noise.
columns = length(inputImage(1, :));
Pf = fftshift( abs( fft2(inputImage) ) );
win = Pf(1:20, columns-20: columns);
rows = length(win(:, 1));
columns = length(win(1, :));
noisePower = mean(reshape(win, [1 rows*columns]));


end