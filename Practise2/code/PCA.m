function [A, meanX] = PCA( X, d)
%PCA Summary of this function goes here
%Funtion for calculate the matrix with the principal components
[m n] = size(X);
if nargin == 1
    d =   n;
end

meanX = mean(X);
XHat = X - repmat(meanX, m,1);

CovMAtrix = 1/m * XHat' * XHat;
% find eigne values and eigen vectors of covariance matrix
[evec,eval]=eig(CovMAtrix);
evalues = diag(eval);

% Sort eigen vectors according to eigen values (ascending order)
[evaluesSort, evaluesSortIdx]= sort(evalues, 'descend');

A = evec(:, evaluesSortIdx(1:d));

end

