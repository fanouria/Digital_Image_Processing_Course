function [fdct]=extract_coef(I,w_r,w_c)
% Extract coefs where watermark is inserted 
wmsz=w_r*w_c; %watermark size
[r,c]=size(I);

D=dct2(I);%get DCT of the Asset
D_vec=reshape(D,1,r*c);%putting all DCT values in a vector
[D_vec_srt,Idx]=sort(abs(D_vec),'descend');%re-ordering all the absolute values

Idx2=Idx(3:wmsz+2);%choosing 1000 biggest values other than the DC value
%finding associated row-column order for vector values
IND=zeros(wmsz,2);
for k=1:wmsz
 x=floor(Idx2(k)/r)+1;%associated column in the image
 y=mod(Idx2(k),r);%associated row in the image
 IND(k,1)=y;
 IND(k,2)=x;
end

for k=1:wmsz
 %insert the WM signal into the DCT values
fdct(k) = D(IND(k,1),IND(k,2));
end
end