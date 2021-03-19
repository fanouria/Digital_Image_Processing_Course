%% init
clear all; close all; clc;

%% 2.1.1 load image
I = imread('moon.tiff'); %read image from file

%scale Image
I=im2double(I);
I = I*255;
minI = min(min(I));
maxI = max(max(I));
rangeI = maxI - minI;
minN = 0;
maxN = 255;
rangeN = maxN - minN;

scale = ( I - minI) ./ rangeI;
nI  =  (rangeN * scale) + minN;

%present results
figure;
subplot(1,2,1);
imshow(uint8(I));
title('Original Image');
subplot(1,2,2);
imshow(uint8(nI));
title('Whole dynamic range values'); 
saveas(gcf, 'pic\1dynamicrange.png');

% Shift zero-freq point to (0,0)
N = size(nI,1);
modI = freqShift(nI); 

figure;
subplot(1,2,1);
imshow(uint8(I));
title('Original Image');
subplot(1,2,2);
imshow(uint8(modI));
title('Shifted Image'); 
saveas(gcf, 'pic\1shifted.png');

 
%% 2.1.2 Rows-Columns FFT
   
fftI= fftRC(modI);%Compute 2-D dft using fft function
figure;
title('2D-DFT Rows-ColumnsFFT');
subplot(1,2,1);
imshow( log10( abs(fftI)),[] );
xlabel('Logarithmic');
subplot(1,2,2);
imshow( abs(fftI),[]); 
xlabel('Linear');
saveas(gcf, 'pic\2fftrc.png');

%% 2.1.3 Low pass filter
%create circular filter
fc = 0.4 ; %low fc means more blurring and higher less
[m,n] = size(fftI); 
hr = (m-1)/2; 
hc = (n-1)/2; 
[x, y] = meshgrid(-hc:hc, -hr:hr);

mg = sqrt((x/hc).^2 + (y/hr).^2); 
Low = double(mg <= fc);

filterI = (Low .* fftI);

%% 2.1.4 IDFT

filterI = ifftRC(filterI);

%% 2.1.5 Shift
idftI = freqShift(filterI);

figure('Units', 'pixels', 'Position', [0 0 1080 860]);
subplot(1,2,1);
imshow(uint8(I));
title('Original Image');
subplot(1,2,2);
imshow(uint8(idftI));
title('Final Image'); 
saveas(gcf, 'pic\5final.png');
