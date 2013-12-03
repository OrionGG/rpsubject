function A = PCA( X, percentage)
%PCA Summary of this function goes here
%Funtion for calculate the matrix with the principal components

[m n] = size(X);

meanX = mean(X);
XHat = X - repmat(meanX, m,1);

CovMAtrix = 1/m * XHat' * XHat;
% find eigne values and eigen vectors of covariance matrix
[evec,eval]=eig(CovMAtrix);
evalues = diag(eval);

% Sort eigen vectors according to eigen values (ascending order)
[evaluesSort, evaluesSortIdx]= sort(evalues, 'descend');
sumEvaluesTotal = sum(evalues);
percentageEvalues = sumEvaluesTotal * percentage/100;

sumEvalues = 0;
i = 1;
while(sumEvalues < percentageEvalues && i <= length(evalues))
    sumEvalues = sumEvalues + evaluesSort(i);
    i = i+1;
end;

A = evec(:, 1:i-1);

end

