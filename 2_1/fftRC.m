function x = fftRC(I)
% 2D-DFT

[n,m] = size(I);


x = fft(I).'; %rows become columns
x = fft(x).';

end
