function [ w, b ] = quad_fitcsvm( x, y )
%Finds largest marging hyperlane for dataset

y(y == 0) = -1;

[n, p] = size(x);
H = eye(p);
H(p+1, p+1) = 0;
f = zeros(p+1, 1);
A = -[diag(y)*x y];
bb = -ones(n, 1);
 
w = quadprog(H, f, A, bb);
w = w(1:end-1);
b = w(end);

end

