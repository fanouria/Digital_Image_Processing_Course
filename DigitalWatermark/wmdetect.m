function result = wmdetect(Image,watermark)
%WMDETECT Detects a watermark.
%   WMDETECT takes an image and a watermark as inputs and detects a
%   watermark using linear correlation and and a threshold.
%   
%   RESULT is 1 if the watermark is detected and 0 if it is not.
%
threshold = 0.02;
R = corr2 (Image, watermark);

if R > threshold 
    result=1;
    fprintf('Watermark detected\n');
else 
    result=0;
    fprintf('Watermark not detected\n')
end

end
