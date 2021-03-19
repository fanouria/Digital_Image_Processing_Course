%% 1.1) Implementation of 2-D FFT Transform

function [] = ex11(filename)

%% Row/Column method using FFT
%filename = 'clock.jpg';
figure('Name','Original image - "clock.jpg"','NumberTitle','off')
img = imread(filename);   %Load image
image(img)  %Plot image
saveas(gcf,'Ex1_Original Image.jpg')
img = img(:,:);

[l2,l1] = size(img);
N = min(l1,l2);
img = img(1:N,1:N); %Make square matrix

tic;    %Computational time
img2 = fft(fft(img).').';    %Compute 2-D dft using fft function
img2 = img2(mod((0:N-1)-N/2,N)+1,mod((0:N-1)-N/2,N)+1); %Circular shift
toc;

%% Plot linear/log fft magnitude
figure('Name','Magnitude Spectrum using fft','NumberTitle','off')
subplot(211)
imagesc(10+(abs(img2)));   
colormap(gray);
title('magnitude spectrum linear - FFT');
axis square
subplot(212)
imagesc(100*log(10+abs(img2)));
colormap(gray);
title('magnitude spectrum log - FFT');
axis square
saveas(gcf,'Ex1_SpectrumUsing_FFT.jpg')

%% DFT Matrix
W = exp(2*pi*1j/N*(0:N-1)'*(0:N-1)); %Create DFT matrix
tic;
img = double(img);
A = (W)*img*(W.');
toc;
A = A(mod((0:N-1)-N/2,N)+1,mod((0:N-1)-N/2,N)+1);

%% Plot linear/log fft mag
figure('Name','Magnitude Spectrum using DFT Matrix','NumberTitle','off')
subplot(211)
imagesc(10+abs(A));
title('magnitude spectrum linear - DFT Matrix');
colormap(gray);
axis square
subplot(212)
imagesc(10+100*log(abs(A)));
colormap(gray);
title('magnitude spectrum linear - DFT Matrix');
axis square
saveas(gcf,'Ex1_SpectrumUsing_DFTMatrix.jpg')

disp('End of Ex11');
end