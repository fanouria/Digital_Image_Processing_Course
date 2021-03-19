%--------------------------------------------------------------------------
%   Project  : Spectral Domain Watermark Detection - Embedding in k biggest
%   DCT coefs
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

w_r = 32; %n. of watermark rows
w_c = 32; %n. of watermark columns
rng(15);
W = randi([0 255], w_r, w_c);  %for the first method
%W = randi([0 1], w_r, w_c);%for the second method
W8 = uint8(W);

B = dct2(I); % matrix B contain the dct coefficients B(k1,k2)
B_vec = reshape(B, 1, r*c);
%%
I_w = insert_bigcoef(I,w_r,w_c);
figure;
imshow(I_w)
fdct = extract_coef(I_w,w_r,w_c);

samples = 30;
for i=1:samples
    rng(i);
    watermark = randn(1,w_r*w_c);
    Ra1(i) = corr2( fdct, watermark);
end
figure();
x=1:samples;
bar(x,Ra1,'FaceColor',[0 .5 .5],'EdgeColor',[0 .5 .5],'LineWidth',1.5);
grid on;
grid minor;
xlim([ 0 samples]);
ylim([ -0.1 0.9]);
xlabel('Random Number Seed','FontSize',12,'FontWeight','bold');
ylabel('Correlation Value ','FontSize',12,'FontWeight','bold');
saveas(gcf, 'pic\2_1CorVal2_without_knowing_about_the_attack.eps');