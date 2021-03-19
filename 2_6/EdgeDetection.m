function [] = EdgeDetection( I , mask)
% EDGEDETECTION Detects the edges of an image before and after thresholding
% The inputs to our function are an image and a mask that is going to be applied
% 1 in the mask field means applying Sobel mask and 2 Prewitt mask

    if mask==1
        MGc = [ 1 2 1; 0 0 0 ; -1 -2 -1];
        MGr = [-1 0 1; -2 0 2; -1 0 1];
    else if mask==2
        MGc = [-1 -1 -1; 0 0 0; 1 1 1];
        MGr = [ -1 0 1; -1 0 1; -1 0 1];
    else
        error('Wrong mask value');   
        end
    end
    Gr = conv2(I, MGr);
    Gc = conv2(I, MGc);
    G  = round(sqrt((double(Gr .^2 + double(Gc) .^ 2))));
    %% thresholding
    BW = G/max(G(:)); %normalization
    T = graythresh(BW); % otsu threshold
    BW(BW > T) = 255;
    BW(BW < T) = 0;
    
    BW = uint8(BW);
    G  = uint8(G);

 
    %% presenting results
    fig1 = figure('Units', 'pixels', 'Position', [0 0 860 1080]);
    subplot(1, 3, 1);
    I = uint8(I);
    imshow(I);
    title('Original Image');
    
    if mask==1
        subplot(1, 3, 2);
        imshow(G);
        title('Sobel Kernels');
        

        subplot(1, 3, 3);
        imshow(BW);
        title('Sobel Kernels & Thresholding');
        saveas(fig1, 'pic\SobelThreshold.png');

    else if mask==2
        subplot(1, 3, 2);
        imshow(G);
        title('Prewitt Kernels');
        

        subplot(1, 3, 3);
        imshow(BW);
        title('Prewitt Kernels & Thresholding');
        saveas(fig1, 'pic\PrewittThreshold.png');
    end
    
end
        

