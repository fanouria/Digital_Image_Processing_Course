%%  2.4 init
clear all; close all; clc;

%% load image
Im = imread('Eikona4.jpg'); %read image from file
originalhsi = rgb2hsi(Im);
[n,m] = size(Im);


%% 2.4.1 HSI Global histogram eq

H = originalhsi(:,:,1);
S = originalhsi(:,:,2);
I = originalhsi(:,:,3);
% 
% %RGBHIST Histogram Plot
% figure; 
% imshow(originalhsi); 
% title('Original image to HSI');
% saveas(gcf, 'pichsi\a_hsi_image.png');
% 
% figure;
% imhist(I);
% title('I image histogram');
% saveas(gcf, 'pichsi\a_hsi_his.png');
% 
% %global histogram equalization
% newI = imhist(I);
% newI = newI / (m*n); %probability
% CDF_I = cumsum(newI);
% newI = CDF_I(uint8(255*I+1));
% %reconstruct I
% hsi = cat(3, H, S, newI);
% newRGB = hsi2rgb(hsi);
% 
% figure;
% imhist(newI);
% title('HSI Histogram after Histogram equalization');
% saveas(gcf, 'pichsi\a_rgbhisteq.png');
% 
% figure;
% imshow(hsi);
% title('HSI Image after Histogram equalization');
% saveas(gcf, 'pichsi\a_rgbhisteq.png');
% 
% figure;
% imshow(newRGB);
% title('RGB Image after HSI Histogram equalization');
% saveas(gcf, 'pichsi\a_newRGB.png');

%% Local Histogram Equalization
I = uint8(255*I+1);
newI = localeqhist(I, 15);
newI = im2double(newI);
%reconstruct I
hsi = cat(3, H, S, newI);
newRGB = hsi2rgb(hsi);

figure;
imhist(newI);
title('I Histogram after Local Histogram equalization ( 15 x 15 window)');
saveas(gcf, 'pichsi\b_ihisteq_15.png');

figure;
imshow(hsi);
title('HSI Image after Histogram equalization ( 15 x 15 window)');
saveas(gcf, 'pichsi\b_hsi_15.png');

figure;
imshow(newRGB);
title('RGB Image after Local HSI Histogram equalization ( 15 x 15 window)');
saveas(gcf, 'pichsi\b_newRGB_15.png')


%%
close all;