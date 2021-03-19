%--------------------------------------------------------------------------
%   Project  : Spectral Domain Watermark Detection - Insertion of watermark
%   at some middle band freqs of DCT coefs
%   Version  : 1.0       
%   Date     : 06/2018
%--------------------------------------------------------------------------
%% init
clear all; close all; clc;

%% load image
load('Eikona1.mat');
I= flower; %double [0,1]
[r,c] = size(I);
J = im2uint8(I); %uint8 [0,255
%% Pseudo-random Watermark signal
% the size of the watermark can be changed

w_r = 64; %n. of watermark rows
w_c = 64; %n. of watermark columns

start_mid = 32000; %where to start inserting the watermark

I_w=insert_zigzag(I,w_r,w_c,start_mid);
figure;
imshow(I_w);

fdct=extract_zigzag(I_w,w_r,w_c,start_mid);

wmsz= w_r*w_c;
samples = 30;
for i=1:samples
    rng(i);
    watermark = randn(1,wmsz);
    Ra1(i) = corr2( fdct, watermark);
end
x=1:samples;
bar(x,Ra1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .5 .5],'LineWidth',1.5);
grid on;
grid minor;
xlim([ 0 samples]);
ylim([ -0.1 0.9]);
xlabel('Random Number Seed','FontSize',12,'FontWeight','bold');
ylabel('Correlation Value ','FontSize',12,'FontWeight','bold');
saveas(gcf, 'pic\1_zigCor.png');

%% noise attack
Ra1 = zeros(1,20);

var=0;
rng(15);
W = randn(1,wmsz)


for i=1:20
    In = imnoise(I_w,'gaussian',0,var);
    fdct_at = extract_zigzag(In,w_r,w_c,start_mid);
    nR(i) = corr2 ( fdct_at,W);
    var = var + 0.1;
end

figure();
x=0:0.1:1.9;
bar(x,nR,'FaceColor',[0 .5 .5],'EdgeColor',[0 .5 .5],'LineWidth',1.5);
grid on;
grid minor;
xlim([ -0.1 2]);
ylim([ 0 0.8]);
xlabel('Gaussian Noise Variance','FontSize',12,'FontWeight','bold');
ylabel('Correlation Value','FontSize',12,'FontWeight','bold');
saveas(gcf, 'pic\2_zig_noise.png');

%% multiple types of geometrical attacks
% Iattacked = imrotate(I_w,180);
% Iattacked = imsharpen(I_w);
% tform = affine2d([1 0 0; .5 1 0; 0 0 1]);% Create 2-D geometric transformation object.
% Iattacked = imwarp(I_w,tform);

for k = 1 : 3
    resfactor= 1 - 0.1*k;
    Iattacked = imresize(I_w,resfactor); 
    Iattacked = imresize(Iattacked,[256 256]);
    subplot(5,2,1 + 2*(k-1))
    imshow(Iattacked);
    label = strcat('Resized I with factor = ', num2str(resfactor) );
    xlabel(label,'FontSize',12,'FontWeight','bold');
    
    subplot(5,2,2 + 2 *(k-1))
    fdct_at = extract_zigzag(Iattacked,w_r,w_c,start_mid);

    for i=1:samples
        rng(i)
        watermark = randn(1,wmsz);
        Ra1(i) = corr2( fdct_at, watermark);
    end
    x=1:samples;
    bar(x,Ra1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .5 .5],'LineWidth',1.5);
    grid on;
    grid minor;
    xlim([ 0 samples]);
    ylim([ -0.1 0.9]);
    xlabel('Random Number Seed');
    ylabel('Correlation');    
end
%% figures

%     resfactor=0.7
%     Iattacked = imresize(I_w,resfactor); 
%     Iattacked = imresize(Iattacked,[256 256]);
%     imshow(Iattacked);
%     label = strcat('Resized I with factor = ', num2str(resfactor) );
%     xlabel(label,'FontSize',12,'FontWeight','bold');
%     saveas(gcf, 'pic\2_zig_res.png');
%     figure();
% subplot(1,2,1)
% imshow(Iattacked); 
% label = strcat('Resized Image with factor = ', num2str(resfactor) );
% xlabel(label,'FontSize',10,'FontWeight','bold');;
% subplot(1,2,2)
% imshow(I)
% xlabel('Original Image','FontSize',10,'FontWeight','bold');
% saveas(gcf, 'pic\1_original.png');

% figure();
% subplot(1,2,1)
% imshow(I_w); 
% xlabel('Image with embedded watermark-B','FontSize',12,'FontWeight','bold');
% subplot(1,2,2)
% imshow(I)
% xlabel('Original Image','FontSize',12,'FontWeight','bold');
% saveas(gcf, 'pic\1_original.png');


