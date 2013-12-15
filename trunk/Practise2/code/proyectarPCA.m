function [ XPCA ] = proyectarPCA(P, meanX, X)
%PROYECTARPCA Summary of this function goes here
%   Detailed explanation goes here
[m,n] = size(X);
XPCA = (X - repmat(meanX, m,1)) * P;

end

