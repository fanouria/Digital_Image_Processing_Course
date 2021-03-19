function result = mydct2(x)
% 2D-DCT 
%Row-Column Computation

[m,n] = size(x);

ww = 2 * exp(-1i*(0:m-1)' * pi / (2*m)) / sqrt(2*m);
ww(1) = ww(1) / sqrt(2);
W = ww(:,ones(1,n));

y = [x(1:2:m,:);
x(m:-2:2,:)];
yy = fft(y);
d = real(W .* yy);

d = d.';

y = [d(1:2:m,:); d(m:-2:2,:)];
yy = fft(y);
result = real(W .* yy).';

end
