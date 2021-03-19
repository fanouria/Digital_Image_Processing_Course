%%  2.3 init
clear all; close all; clc;

%% load image

I = imread('aerial.tiff');
I= double(I);

%% 2.3.1
SNRdb = 10;
SNR = 10^(SNRdb/10);
varI = std(I(:))^2; %signal variance
varN = varI/SNR; %noise variance
gI = addnoise(I,varN,'GAUSSIAN'); %image with gaussian noise
movinggI = movingavgfilter(gI,5);%moving average filter
mediangI = medianfilter(gI,5);%median filter

figure();

subplot(1,3,1)
imshow(uint8(gI)); 
xlabel('Noisy Image');
subplot(1,3,2)
imshow(uint8(movinggI)); 
xlabel('Moving Average Filter');
subplot(1,3,3)
imshow(uint8(mediangI)); 
xlabel('Median Filter');

hgexport(gcf, 'pic\1comparison.png', hgexport('factorystyle'), 'Format', 'png')


%% 2.3.2
p=0.15;
spI = addnoise(I,p,'SALTPEPPER');
movingspI = movingavgfilter(spI,5);%moving average filter
medianspI = medianfilter(spI,5);%median filter

figure();

subplot(1,3,1)
imshow(uint8(spI)); 
xlabel('Noisy Image');
subplot(1,3,2)
imshow(uint8(movingspI)); 
xlabel('Moving Average Filter');
subplot(1,3,3)
imshow(uint8(medianspI)); 
xlabel('Median Filter');

hgexport(gcf, 'pic\2comparison.png', hgexport('factorystyle'), 'Format', 'png') 




%% 2.3.3
spgI = addnoise(gI,p,'SALTPEPPER');% we add to the image with the gaussian noise, salt and pepper noise
movingspgI = movingavgfilter(spgI,5);%moving average filter
medianmovingspgI = medianfilter(movingspgI,5);%median after moving
medianspgI = medianfilter(spgI,5);%median 
movingmedianspgI = movingavgfilter(medianspgI,5);%moving average filter after median


figure('Units', 'pixels', 'Position', [0 0 800 1080]);

subplot(3,2,1)
imshow(uint8(I)); 
xlabel('Original Image');
subplot(3,2,2)
imshow(uint8(spgI)); 
xlabel('Noisy Image');
subplot(3,2,3)
imshow(uint8(movingspgI)); 
xlabel('1.Moving average Filter');
subplot(3,2,4)
imshow(uint8(medianspgI)); 
xlabel('1.Median Filter');
subplot(3,2,5)
imshow(uint8(medianmovingspgI)); 
xlabel('2.Median Filter');
subplot(3,2,6)
imshow(uint8(movingmedianspgI)); 
xlabel('2.Moving average Filter');

hgexport(gcf, 'pic\3comparison.png', hgexport('factorystyle'), 'Format', 'png') 

%%
% close all;
