%--------------------------------------------------------------------------
%   Project  : Spatial Domain Watermark Detection
%   Version  : 1.0       
%   Date     : 06/2018
%--------------------------------------------------------------------------
%% init 
clear all; close all; clc;

%% load image

load('Eikona1.mat');
I= flower; %double [0,1]
[r,c] = size(I);
J = im2uint8(I); %uint8 [0,255]

%% Pseudo-random Watermark signal
% The watermark W must be composed of random numbers drawn from a Gaussian distribution N(0,1)
rng(15);
W = randi([0 1], r, c);
W8 = uint8(W);

%% 3.1.a Watermark embedding in spatial domain
% LSB spatial embedding

samples = 30;
A8 =  4 * (J/4) + W8;
%A8 =  4 * (J/4) + 4*W8;
detection = wmdetect( A8, W8);
wmdetected = rem(A8,2);

lsbR = zeros(1,samples);
lsbRi = zeros(1,samples);

for i=1:samples
    rng(i)
    watermark = randi([0 1], r,c);
    lsbRi(i) = corr2 ( A8, watermark); %correlated with the I'w
end

for i=1:samples
    rng(i)
    watermark = randi([0 1], r,c);
    lsbR(i) = corr2 (wmdetected, watermark); %correlated with the detected  watermark
end

% gain factor
k= 0.04;
Iw = I + k * W;
detection = wmdetect( Iw, W);
 
R = zeros(1,samples);
for i=1:samples
    rng(i)
    watermark = randi([0 1], r,c);
    R(i) = corr2 ( Iw, watermark);
end

%% 3.2.a noise attack
nR = zeros(1,20);
R = zeros(1,samples);

% %gain factor
% var=0;
% for i=1:20
%     In = imnoise(Iw,'gaussian',0,var);
%     nR(i) = corr2 ( In, W);
%     var = var + 0.1;
% end

%%lsb
var=0;
 
for i=1:20
    In = imnoise(A8,'gaussian',0,var);
    wmdetected= rem(In,2);
    nR(i) = corr2 (wmdetected, W8);
      if (var == 0.0)
          for i=1:samples
                rng(i)
                watermark = randi([0 1], r,c);
                R(i) = corr2 ( wmdetected, watermark);
          end
      end
          
    var = var + 0.1;
end



%% 3.2.a rotation attack
%LSB case
Iattacked = imresize(A8,[128 128]); 
Iattacked1 = imresize(Iattacked,[256 256]);
% Iattacked1 = imrotate(A8,180,'bilinear','crop');
wdetected = rem(Iattacked1,2);

%gain factor case
Iattacked2 = imrotate(Iw,180,'bilinear','crop');
% even if the rotation is just 1 degree, afterwards we cannot detect the
% watermark

lsbR = zeros(1,samples);
R = zeros(1,samples);

for i=1:samples
    rng(i)
    watermark = randi([0 1], r,c);
    lsbR(i) = corr2 ( wdetected, watermark);%LSBcase
    R(i) = corr2 ( Iattacked2, watermark);%gain factor case
    
end
%% 3.2.a scaling attack
figure;
for k = 1 : 3
    resfactor= 1 - 0.1*k;
    Iattacked = imresize(Iw,resfactor); 
    Iattacked = imresize(Iattacked,[256 256]);
    subplot(5,2,1 + 2*(k-1))
    imshow(Iattacked);
    label = strcat('Resized I with factor = ', num2str(resfactor) );
    xlabel(label,'FontSize',12,'FontWeight','bold');
    
    subplot(5,2,2 + 2 *(k-1))
    
    for i=1:samples
        rng(i)
        watermark = randi([0 1], r,c);
%         R(i) = corr2 ( wdetected, watermark);%LSBcase
        R(i) = corr2 ( Iattacked, watermark);%gain factor case
    end
    x=1:samples;
    bar(x,R,'FaceColor',[0 .5 .5],'EdgeColor',[0 .5 .5],'LineWidth',1.5);
    grid on;
    grid minor;
    xlim([ 0 samples]);
    ylim([ -0.1 0.09]);
    xlabel('Random Number Seed');
    ylabel('Correlation');    
end

%% figures

% figure();
% imshow(W); 
% xlabel('Watermark','FontSize',12,'FontWeight','bold');
% saveas(gcf, 'pic\1_Watermark.png');

% figure();
% imshow(I); 
% xlabel('Original Image','FontSize',12,'FontWeight','bold');
% saveas(gcf, 'pic\1_original.png');

% figure();
% x=1:30;
% bar(x,R,'FaceColor',[0 .5 .5],'EdgeColor',[0 .5 .5],'LineWidth',1.5);
% grid on;
% grid minor;
% xlim([ 0.5 30.5]);
% ylim([ -0.01 1]);
% xlabel('Random Number Seed','FontSize',12,'FontWeight','bold');
% ylabel('Correlation Value with LSB and watermark detection','FontSize',12,'FontWeight','bold');
% saveas(gcf, 'pic\1_0CorValLSB.png');

% figure();
% imshow(A8); 
% xlabel('Watermark embedding in spatial domain','FontSize',12,'FontWeight','bold');
% saveas(gcf, 'pic\1_Wsp.png');

% figure();
% x=0:0.1:1.9;
% bar(x,nR,'FaceColor',[0 .5 .5],'EdgeColor',[0 .5 .5],'LineWidth',1.5);
% grid on;
% grid minor;
% xlim([ -0.1 2.1]);
% ylim([ -0.1 1]);
% xlabel('Gaussian Noise Variance','FontSize',12,'FontWeight','bold');
% ylabel('Correlation Value','FontSize',12,'FontWeight','bold');
% saveas(gcf, 'pic\1_noise_attack_variance_spatialLSB.png');

% figure();
% x=1:samples;
% bar(x,R,'FaceColor',[0 .5 .5],'EdgeColor',[0 .5 .5],'LineWidth',1.5);
% grid on;
% grid minor;
% xlim([ 0 samples]);
% ylim([ -0.01 0.1]);
% xlabel('Random Number Seed','FontSize',12,'FontWeight','bold');
% ylabel('Correlation Value - Gain Factor k=0.04','FontSize',12,'FontWeight','bold');
% saveas(gcf, 'pic\1_1CorVal2.png');

% figure();
% x=1:samples;
% bar(x,R,'FaceColor',[0 .5 .5],'EdgeColor',[0 .5 .5],'LineWidth',1.5);
% grid on;
% xlim([ 0 samples]);
% ylim([ -0.01 0.05]);
% xlabel('Random Number Seed','FontSize',12,'FontWeight','bold');
% ylabel('Correlation Value - 180 degrees rotation','FontSize',12,'FontWeight','bold');
% saveas(gcf, 'pic\1_rotationgain180.png');
% 
% close all;