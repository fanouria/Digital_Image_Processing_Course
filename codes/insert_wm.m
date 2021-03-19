function [embI]=insert_wm(im,wt)
% INSERT_WM function performs watermarking in DCT domain
% it processes the image into 8x8 blocks.
%  im     = Input Image
%  wt     = Watermark
%  embimg = Output Embedded image
% modified code of Suraj Kamya's Watermark DCT

watermark = imresize((wt),[32 32]);% Resize and convert to binary

x={}; % empty cell which will consist all blocks
dct_img=blkproc(im,[8,8],@dct2);% step 1: DCT of image using 8X8 block
m=dct_img; % Source image in which watermark will be inserted 

k=1; dr=0; dc=0;
% dr is to address 1:8 row every time for new block in x
% dc is to address 1:8 column every time for new block in x
% k is to change the no. of cell

%divide image into 1024  non overlapping 8X8 blocks 
for ii=1:8:256 % To address row -- 8X8 blocks of image
    for jj=1:8:256 % To address columns -- 8X8 blocks of image
        for i=ii:(ii+7) % To address rows of blocks
            dr=dr+1;
            for j=jj:(jj+7) % To address columns of block
                dc=dc+1;
                z(dr,dc)=m(i,j);
            end
            dc=0;
        end
        x{k}=z; k=k+1;
        z=[]; dr=0;
    end
end
nn=x;

%insert watermark into  blocks 
i=[]; j=[]; w=1; wmrk=watermark;
w_el = numel(wmrk); % number of elements

for k=1:1024
    kx=(x{k}); % Extracting block into kx for processing
    for i=1:8 % To address row of block
        for j=1:8 % To adress column of block
            if (i==8) && (j==8) && (w<=w_el) % insert watermark               .
                 if wmrk(w)==0
                    kx(i,j)=kx(i,j)+15;
                elseif wmrk(w)==1
                    kx(i,j)=kx(i,j)-15;
                 end                                
            end            
        end        
    end
    w=w+1;
    x{k}=kx; kx=[]; % Watermark value will be replaced in block
end     

% recombine cells in to image 
i=[]; j=[]; data=[]; count=0;
embimg1={}; % Changing complete row cell of 1024 into 32 row cell 
for j=1:32:1024
    count=count+1;
    for i=j:(j+31)
        data=[data,x{i}];
    end
    embimg1{count}=data;
    data=[];
end

% Change 32 row cell in to particular columns to form image
i=[]; j=[]; data=[]; 
embI=[];  % final watermark image 
for i=1:32
    embI=[embI;embimg1{i}];
end
embI=(uint8(blkproc(embI,[8 8],@idct2)));
