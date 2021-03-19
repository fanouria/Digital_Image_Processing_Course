%%  2.6.1 init
clear all; close all; clc;

%% load image

I = imread('clock.tiff'); %read image from file
I = double(I);
% I = im2double(I);

%% Compression
[m,n] = size(I); % dimensions of I 
blksize = 32; %block dimension
no_blocks_i = ceil(m / blksize);  %number of blocks in x-axis 
no_blocks_j = ceil(n / blksize);  %number of blocks in y-axis 

% 2D-DCT transformation for each or our blocks
dctcoef = blockproc(I, [blksize, blksize], ...
    @(block_struct)mydct2(block_struct.data));

mask = zeros(blksize,blksize);
len_ones = 20;
p = 0.05:0.05:0.5;
for i = 1 : length(p)

    % zonal method
    Bcuttcoef = blockproc(dctcoef, [blksize, blksize],...
        @(block_struct)imquant(block_struct.data,'zonal',p(i)));
    %thresholding method
    Tcuttcoef = blockproc(dctcoef, [blksize, blksize],...
        @(block_struct)imquant(block_struct.data,'threshold',p(i)));
    %% Decompression

    % 2D-IDCT transformation for each or our blocks  

    %zonal method
    BdecompI = blockproc(Bcuttcoef,[blksize, blksize],...
        @(block_struct)idct2(block_struct.data));

    %thresholding method
    TdecompI = blockproc(Tcuttcoef,[blksize, blksize],...
        @(block_struct)idct2(block_struct.data));
   
    %saving decompressed values in cells
    Bcell{i} = mat2cell(BdecompI,m,n);
    Tcell{i} = mat2cell(BdecompI,m,n);

    %%computing mse results
    errB(i) = immse(I,BdecompI); %zonal mse 
    errT(i) = immse(I,TdecompI); %thresholding mse

end

%% Plot mse
figure;
plot(p,errB,'-s',p,errT,'-s','LineWidth',1.5);
xlabel('Coefficients %');
ylabel('MSE');
legend('Zonal coding','Threshold coding')
title('MSE');
grid on;

saveas(gcf, 'pic\msegraph.png');

%% results of compression

figure('Units', 'pixels', 'Position', [0 0 800 1080]);

for l = 1 : 5
    subplot(5,3,1 + 3*(l-1))
    imagesc(I); 
    xlabel('Original');
    subplot(5,3,2 + 3*(l-1))
    BdecompI = reshape(cell2mat(Bcell{2*l}),[m n]);
    imagesc(BdecompI); 
    percent1 = strcat('Zonal coding p=', num2str(p(2*l)) );
    xlabel(percent1);
    subplot(5,3,3 + 3*(l-1))
    TdecompI = reshape(cell2mat(Tcell{2*l}),[m n]);
    imagesc(TdecompI); 
    percent2 = strcat('Threshold coding p=', num2str(p(2*l)) );
    xlabel(percent2);
    
end
colormap(gray)
hgexport(gcf, 'pic\comparison.png', hgexport('factorystyle'), 'Format', 'png') 

