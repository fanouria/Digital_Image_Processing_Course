%%  2.4 init
clear all; close all; clc;

%% load image
I = imread('Eikona4.jpg'); %read image from file
G = rgb2gray(I);
% I = im2double(I);
[n,m] = size(I);


figure;
imshow(I);
title('Original Image');
saveas(gcf, 'pic\original.png');

%% 2.4.1 RGB Global histogram eq
rHist = I(:,:,1);
gHist = I(:,:,2);
bHist = I(:,:,3);

%RGBHIST Histogram Plot

figure;
h(1) = histogram(rHist,'FaceColor','r'); hold on; 
h(2) = histogram(gHist,'FaceColor','g'); hold on; 
h(3) = histogram(bHist,'FaceColor','b'); hold on; 
title('RGB image histogram');
saveas(gcf, 'pic\a_rgb_his.png');

%global histogram equalization
eq_rHist = eqhist(rHist);
eq_gHist = eqhist(gHist);
eq_bHist = eqhist(bHist);
%reconstruct I
rI(:,:,1) = eq_rHist;
rI(:,:,2) = eq_gHist;
rI(:,:,3) = eq_bHist;

figure;
imshow(rI);
title('Image after Global Histogram equalization');
saveas(gcf, 'pic\rgbimage_1eq.png');

figure;
rh(1) = histogram(eq_rHist,'FaceColor','r'); hold on; 
rh(2) = histogram(eq_gHist,'FaceColor','g'); hold on; 
rh(3) = histogram(eq_bHist,'FaceColor','b'); hold on; 
title('Histogram after Global Histogram equalization');
saveas(gcf, 'pic\rgbhisteq.png');

%% Local Histogram Equalization
eq_rHist = localeqhist(rHist,25);
eq_gHist = localeqhist(gHist,25);
eq_bHist = localeqhist(bHist,25);
%reconstruct I
rI=cat(3,eq_rHist,eq_gHist,eq_rHist);

figure;
rh(1) = histogram(eq_rHist,'FaceColor','r'); hold on; 
rh(2) = histogram(eq_gHist,'FaceColor','g'); hold on; 
rh(3) = histogram(eq_bHist,'FaceColor','b'); hold on; 
title('Histogram after Local Histogram equalization (25 x 25 window)');
saveas(gcf, 'pic\rgbhisteq_25.png');

figure;
imshow(rI);
title('Local Histogram equalization Image 25 x 25 window');
saveas(gcf, 'pic\rgb_25.png');



%%
close all;