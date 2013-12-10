function [ XPCA ] = GetPCAProyectionsJFold(j, randpermClases, X, LABELS, pvalue, NFOLD)
%GETPDAPROYECTIONSJFOLD Summary of this function goes here
%   Detailed explanation goes here

% Count class labels
classLabels = unique(LABELS);
CLASSNUMBER = length(classLabels);

dataTest = [];
dataTrain = [];
labelsTrain = [];
labelsTest = [];

% We select data randomly to do n-fold
for i=1:CLASSNUMBER
    DATAOFCLASS = X(LABELS==i,:);
    NumDataInClass = size(DATAOFCLASS,1);
    NumDataInTest = round(NumDataInClass/NFOLD);
    
    endTestIndexes = min(NumDataInClass, j * NumDataInTest);
    testIndexes{i} = randpermClases{i}((1+((j-1)* NumDataInTest)):endTestIndexes);
    trainIndexes{i} = randpermClases{i}(1:((j-1)* NumDataInTest));
    trainIndexes{i} = [trainIndexes{i},randpermClases{i}((j*NumDataInTest)+1:NumDataInClass)];
    
    %dataTest = [dataTest; DATAOFCLASS(testIndexes{i},:)];
    dataTest{i} = DATAOFCLASS(testIndexes{i},:);
    dataTrainByClass{i} = DATAOFCLASS(trainIndexes{i},:);
    dataTrain = [dataTrain; dataTrainByClass{i}];
    
    LABELCLASS = LABELS(LABELS==i);
    labelsTrain = [labelsTrain; LABELCLASS(trainIndexes{i})];
    labelsTest = [labelsTest; LABELCLASS(testIndexes{i})];
    %LABELCLASSTRAIN = ones(1,length(dataTrain))*i;
    
    
    testIndexes{i} = zeros(1, NumDataInTest);
    trainIndexes{i} = zeros(1, NumDataInClass - NumDataInTest);
end;

[A, meanX]  = PCA(dataTrain,pvalue);
[m,n] = size(X);
XPCA = (X - repmat(meanX, m,1)) * A;


end

