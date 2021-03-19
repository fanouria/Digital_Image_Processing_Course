function [I_w]=insert_zigzag(I,w_r,w_c,start_mid)
% Insert watermark in zig-zag order in mid band

wmsz= w_r*w_c; %watermark size
[r,c]=size(I);
D=dct2(I);%get DCT of the Asset
D_vec=zigzag(D);%re-ordering all the absolute values

rng(15);
W = randn(1,wmsz);%generate a Gaussian spread spectrum noise to use as watermark signal


D_w = D_vec;
a = 0.04;

for k=1:wmsz
    D_w(k+start_mid)=D_vec(k+start_mid)+ a * W(k);
end
D = izigzag( D_w,r,c);
I_w=idct2(D);
end