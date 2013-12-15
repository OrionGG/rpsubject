function [Xtest, Ytest,Xtrain, Ytrain, P, meanX] = PrepareDataPCA( X, LABELS, NFOLD )
%PREPAREDATA Summary of this function goes here
%   Detailed explanation goes here


[Xtest, Ytest,Xtrain, Ytrain] = PrepareData( X, LABELS, NFOLD );


P = cell(1,NFOLD);
meanX = cell(1,NFOLD);
for f = 1:NFOLD    
    [P{f}, meanX{f}] = PCA(Xtrain{f});
end;

end

