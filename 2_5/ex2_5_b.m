%%  2.5.a init
clear all; close all; clc;

%% load image
I = imread('factory.jpg'); %load image from file
I = rgb2gray(I);
I = im2double(I);
I = I(:, 1:300);
%% compute impulse response
[rows,columns] = size(I);

delta = zeros(rows, columns);
delta(round(rows/2), round(columns/2)) = 1;
h = psf(delta);

%% frequency response
H= fft2(h);
H = fftshift(H);
Hspectrum = log(abs(H).^2 + 1);
Hspectrum = (Hspectrum - min(min(Hspectrum))) / max(max(Hspectrum)) * 255;
Hspectrum = uint8(Hspectrum);

figure;
imshow(log(1+abs(h)),[])
title('Impulse Response');
saveas(gcf,'impulse.png')

figure;
imshow(Hspectrum);
title('PSF spectrum');
saveas(gcf, 'pic\PSFspectrum.png');
%% corrupt image
corruptedI = psf(I); %corrupt

%% inverse filter using threshold
Thresholds = [0.1 0.2 0.5 0.8 1 2 5 10 15 20 50 80 100 200 500 1000 5000 10000];

showOutput = [0.1 0.2 0.5 0.8 1 5 20 100 1000 5000 10000]; 
filteredMSE = zeros(1, length(Thresholds)); %init MSE array
H = fft(fft(h).').'; %compute spectrum of PSF impulse response
%H = CustomFFTshift(H); %shift spectrum
F = fft(fft(corruptedI).').'; %compute spectrum of corrupted image
F = fftshift(F); %shift spectrum

for threshold = Thresholds
    inverseFilter = H; %initialize inverse filter
    ind = 1./abs(H) < threshold; %find values lower than threshold
    inverseFilter(ind) = 1./H(ind); %if lower than threshold keep value
    inverseFilter(~ind) = threshold * abs(H(~ind))./H(~ind); %if value higher than threshold then limit it
    filteredIFFT = inverseFilter .* F; %multiply spectra
    filteredIFFT = fftshift(filteredIFFT); %shift spectrum
    filteredI = ifft(ifft(filteredIFFT).').'; %get inverse Fourier Transform 
    filteredI = fftshift(filteredI);    
    filteredI = (filteredI - min(filteredI(:))) / (max(filteredI(:)) - min(filteredI(:)));
    filteredI = real(filteredI); %get absolute value of result
    filteredMSE(threshold == Thresholds) = mean( mean( ( double(filteredI)-double(I) ) .^ 2 ) ); %compute MSE
end

%% inverse filter not using threshold
inverseFilter = 1./H; %initialize inverse filter
filteredIFFT = inverseFilter .* F; %multiply spectra
filteredIFFT = fftshift(filteredIFFT); %shift spectrum
filteredI = ifft(ifft(filteredIFFT).').'; %get inverse Fourier Transform
filteredI = fftshift(filteredI);
filteredI = (filteredI - min(filteredI(:))) / (max(filteredI(:)) - min(filteredI(:)));
filteredI = real(filteredI); %get absolute value of result

figure;
imshow(filteredI);
title('Filtered without threshold');
saveas(gcf, 'filteredNoThreshold.png');
%% compute MSE
corruptedMSE = mean(mean((corruptedI-I) .^ 2));
disp('MSE of corrupted image:')
disp(corruptedMSE);

%% results

corruptedI = (corruptedI - min(min(corruptedI))) / max(max(corruptedI)); %normalize

figure;
imshow(corruptedI);
title('Corrupted Image');
saveas(gcf, 'pic\b_corruptedI.png');

figure;
plot(Thresholds, filteredMSE);
xlabel('Threshold');
ylabel('MSE');
saveas(gcf, 'pic\b_mse.png');

%%
%close all;


