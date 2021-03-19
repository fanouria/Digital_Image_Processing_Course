%--------------------------------------------------------------------------
%   Project  : Spectral Domain Watermark Detection
%   Version  : 1.0       
%   Date     : 06/2018
%--------------------------------------------------------------------------
%% init
clear all; close all; clc;

%% load image
load('Eikona1.mat');
I= flower; %double [0,1]
[r,c] = size(I);
J = im2uint8(I); %uint8 [0,25]
 
%% Pseudo-random Watermark signal
rng(15);
w_r = 32; %n. of watermark rows
w_c = 32; %n. of watermark columns
W = randi([0 1], w_r, w_c);
W8 = uint8(W);
 
B = dct2(I); % matrix B contain the dct coefficients B(k1,k2)
B_vec = reshape(B, 1, r*c);
%% Watermark embedding in blocks
embI = insert_wm(J,W8);
wm = extract_wm(embI);

samples = 30;
R1 = zeros(1,samples);

for i=1:samples
    rng(i)
    watermark = randi([0 1], 32,32);
    R1(i) = corr2( wm, watermark);
end


%% 3.2.a noise attack
Ra1 = zeros(1,20);
var=0;

for i=1:20
    In = imnoise(embI,'gaussian',0,var);
    [wm_n]=extract_wm(In);
    Ra1(i) = corr2 ( wm_n, W);
    var = var + 0.1;
end
%% 3.2 rotation attack
 
Iattacked = imrotate(embI,180);
wm_n = extract_wm(Iattacked);
wm_n = imresize((wm_n),[w_r w_c]);


Ra2 = zeros(1,samples);

for i=1:samples
    rng(i)
    watermark = randi([0 1], 32,32);
    Ra2(i) = corr2 ( wm_n, watermark);
end
%% resize attack 
for k = 1 : 3
    resfactor= 1 - 0.1*k;
    Iattacked = imresize(embI,resfactor); 
    Iattacked = imresize(Iattacked,[256 256]);
    wm_n = extract_wm(Iattacked);
    wm_n = imresize((wm_n),[w_r w_c]);
    subplot(5,2,1 + 2*(k-1))
    imshow(Iattacked);
    label = strcat('Resized I with factor = ', num2str(resfactor) );
    xlabel(label,'FontSize',12,'FontWeight','bold');
    
    subplot(5,2,2 + 2 *(k-1))
    for i=1:samples
        rng(i)
        watermark = randi([0 1], 32,32);
        Ra1(i) = corr2( wm_n, watermark);
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

% figure();
% imshow(I); 
% xlabel('Original Image','FontSize',12,'FontWeight','bold');
% saveas(gcf, 'pic\1_original.png');

% figure();
% imshow(Idct); 
% xlabel('Watermark embedding in spectral domain');
% saveas(gcf, 'pic\1_Wfreq.png');

% figure();
% x=1:30;
% bar(x,R,'FaceColor',[0 .5 .5],'EdgeColor',[0 .5 .5],'LineWidth',1.5);
% grid on;
% grid minor;
% xlim([ 0 30]);
% ylim([ -0.1 1.01]);
% xlabel('Random Number Seed','FontSize',12,'FontWeight','bold');
% ylabel('Correlation Value','FontSize',12,'FontWeight','bold');
% saveas(gcf, 'pic\2_0CorValLSB.png');

% figure();
% x=0:0.1:1.9;
% bar(x,nR,'FaceColor',[0 .5 .5],'EdgeColor',[0 .5 .5],'LineWidth',1.5);
% grid on;
% grid minor;
% xlim([ -0.1 2]);
% ylim([ 0 0.19]);
% xlabel('Gaussian Noise Variance','FontSize',12,'FontWeight','bold');
% ylabel('Correlation Value','FontSize',12,'FontWeight','bold');
% saveas(gcf, 'pic\2_noise_attack_variance.png');

% figure();
% x=1:samples;
% bar(x,Ra1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .5 .5],'LineWidth',1.5);
% grid on;
% grid minor;
% xlim([ 0 samples]);
% ylim([ -0.1 0.9]);
% xlabel('Random Number Seed','FontSize',12,'FontWeight','bold');
% ylabel('Correlation Value ','FontSize',12,'FontWeight','bold');
% saveas(gcf, 'pic\2_1CorVal2_without_knowing_about_the_attack.png');

% figure();
% subplot(1,2,1)
% imshow(embI); 
% xlabel('Image with embedded watermark-A','FontSize',12,'FontWeight','bold');
% subplot(1,2,2)
% imshow(I)
% xlabel('Original Image','FontSize',12,'FontWeight','bold');
% saveas(gcf, 'pic\1_original.png');

%close all;