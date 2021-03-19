%%  2.5.a init
clear all; close all; clc;

%% load image

I = imread('factory.jpg'); %read image from file
I = rgb2gray(I);
I = double(I);
[n,m] = size(I);

%add noise
SNRdb = 10;
SNR = 10^(SNRdb/10);
varI = std(I(:))^2; 
varN = varI/SNR; 
nI = addnoise(I,varN,'GAUSSIAN');

%% 2.5.a.1 known noise Wiener
fI_kN = myWiener(nI, 5, varN);

%% 2.5.a.2 unknown noise Wiener
fI_uN = myWiener(nI, 5, 'UNKNOWN');

%% results
figure;
imshow(uint8(I));
title('Original Image');
saveas(gcf, 'pic\original.png');
close all;

figure;
imshow(uint8(nI));
title('Image with AWGN');
saveas(gcf, 'pic\awgnI.png');

figure;
imshow(uint8(fI_kN));
title('Filtered Image using with known noise');
saveas(gcf, 'pic\fI_kN.png');

figure;
imshow(uint8(fI_uN));
title('Filtered Image with unknown noise');
saveas(gcf, 'pic\fI_uN.png');

%% 
close all;