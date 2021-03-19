function ind = zigzag(N)
K = 2;
M = N-1;
ind = zeros(1,N*N);

for i=[1:M];
  ind(K:K+i) = [(1+M*rem(i,2)), (-1)^i*M*ones(1,i)];
  K = K+i+1;
end

for i=[M-1:-1:0]
  ind(K:K+i) = [(N-M*rem(i,2)), (-1)^i*M*ones(1,i)];
  K = K+i+1;
end

ind = cumsum(ind)+1;

end