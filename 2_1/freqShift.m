function x = freqShift(I)
% Shift zero-freq point to (0,0).

[n,m] = size(I);

x = zeros (n,m); %initialize matrix
for i = 1:n
    for j = 1:m
        x(i,j) = I(i,j) * ((-1)^(i+j));
    end
end

end
