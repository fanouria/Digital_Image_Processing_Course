function result = addnoise(x,p,type)
%ADDNOISE INPUTS: X   image
%                 p   variance in case of gaussian noise and percent in case of impulse  
%                 type type of noise we are going to add  
[m,n] = size(x);
if strcmp(type,'GAUSSIAN') 
    
    result= x + sqrt(p).*randn(size(x));
    % randn(n) returns an n-by-n matrix of normally distributed random numbers
    
elseif strcmp(type,'SALTPEPPER')
    
    result = x;
    
    for i = 1:m
        for j = 1:n
            myrandom = rand; % rand returns a single uniformly distributed random number in the interval (0,1)
            if myrandom < p/2
                result(i,j) = 0;
            elseif ( myrandom >= p/2 && myrandom < p )
                result(i,j) = 255;
            end
        end
    end 

end
end