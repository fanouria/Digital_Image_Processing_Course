function [I_w]=insert_bigcoef(I,w_r,w_c)
% Insert watermark in w_r*w_c biggest coefs except the 2 biggest

wmsz=w_r*w_c; %watermark size
I=I(:,:,1);%get the first color in case of RGB image
[r,c]=size(I);
D=dct2(I);%get DCT of the Asset
D_vec=reshape(D,1,r*c);%putting all DCT values in a vector
[D_vec_srt,Idx]=sort(abs(D_vec),'descend');%re-ordering all the absolute values
rng(15);
W=randn(1,wmsz);%generate a Gaussian spread spectrum noise to use as watermark signal
Idx2=Idx(3:wmsz+2);%choosing 1000 biggest values other than the DC value
%finding associated row-column order for vector values
IND=zeros(wmsz,2);
for k=1:wmsz
 x=floor(Idx2(k)/r)+1;%associated column in the image
 y=mod(Idx2(k),r);%associated row in the image
 IND(k,1)=y;
 IND(k,2)=x;
end
D_w=D;
a = 0.2
for k=1:wmsz
 %insert the WM signal into the DCT values
D_w(IND(k,1),IND(k,2))=D_w(IND(k,1),IND(k,2))+a * W(k);
end
I_w=idct2(D_w);
end