function [fdct]=extract_zigzag(I_w,w_r,w_c,start_mid)
% Insert watermark in zig-zag order in mid band

wmsz= w_r*w_c; %watermark size

D=dct2(I_w);%get DCT of the Asset
D_vec=zigzag(D);%re-ordering in zig-zag order

for k=1:wmsz
    fdct(k)= D_vec(k+start_mid);%the dct coefs where watermark should be embedded
end

end