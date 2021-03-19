function x = ifftRC(I)
% 2D-DFT

[n,m] = size(I);


x = conj(fft(conj(I)).'); %rows become columns
x = conj(fft(conj(x)).');
x = real(x) / numel(x);

end