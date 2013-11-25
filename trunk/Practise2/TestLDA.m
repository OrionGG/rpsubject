function [ output_args ] = TestLDA( X, LABELS)
%TESTLDA Summary of this function goes here
%   Detailed explanation goes here
NFOLD = 10;

% Count class labels
classLabels = unique(LABELS);
CLASSNUMBER = length(classLabels);

% We select data randomly to do n-fold
for i=1:CLASSNUMBER
    DATAOFCLASS = X(LABELS==i,:);
    NumDataInClass = size(DATAOFCLASS,1);
    randpermClases{i} = randperm(NumDataInClass);
    
    NumDataInTest = round(NumDataInClass/NFOLD);
    testIndexes{i} = zeros(1, NumDataInTest);
    trainIndexes{i} = zeros(1, NumDataInClass - NumDataInTest);
end;



for j = 1:NFOLD
    
    [A, dataTest, dataTrain] = GetProyectMatrixForJFold(j, randpermClases, X, LABELS, NFOLD);
    
    
end;

end

