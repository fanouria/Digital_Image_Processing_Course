%%  2.6.1 init
clear all; close all; clc;

%% load image

I = imread('boat.tiff'); %read image from file
I(:,:,4) = []; %Your image has a transparency channel in addition to the three colour channels. 
%If you don't want to do anything with the transparency information, just discard it
%proceed with rgb2gray
I = rgb2gray(I);
I = double(I);

%% processing and save results
EdgeDetection( I , 1); %sobel mask
EdgeDetection( I , 2); %prewitt mask

%%
close all;

