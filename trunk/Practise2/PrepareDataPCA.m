function [Xtest, Ytest,Xtrain, Ytrain, P, meanX] = PrepareDataPCA( X, LABELS, NFOLD )
%PREPAREDATA Summary of this function goes here
%   Detailed explanation goes here


% Count class labels
classLabels = unique(LABELS);
CLASSNUMBER = length(classLabels);

Xtest  = cell(1,NFOLD);
Ytest  = cell(1,NFOLD);
Xtrain  = cell(1,NFOLD);
Ytrain  = cell(1,NFOLD);

% We select data randomly to do n-fold
for i=1:CLASSNUMBER
    DATAOFCLASS = X(LABELS==i,:);
    NumDataInClass = size(DATAOFCLASS,1);
    randpermClases{i} = randperm(NumDataInClass);
    
    NumDataInTest = round(NumDataInClass/NFOLD);
    
    for j = 1:NFOLD
        
        endTestIndexes = min(NumDataInClass, j * NumDataInTest);
        FoldIndexes{j} = randpermClases{i}((1+((j-1)* NumDataInTest)):endTestIndexes);
        Fold{j} = DATAOFCLASS(FoldIndexes{j},:);
        
        LABELCLASS = LABELS(LABELS==i);
        FoldLabel{j} = LABELCLASS(FoldIndexes{j}, :);
        
    end;
    
    for j = 1:NFOLD
        Xtest{j} = [Xtest{j};Fold{j}];
        Ytest{j} = [Ytest{j};FoldLabel{j}];
        for jb = 1:j-1
            Xtrain{j}= [Xtrain{j}; Fold{jb}];
            Ytrain{j}= [Ytrain{j}; FoldLabel{jb}];
        end;
        for ja = j+1:NFOLD
            Xtrain{j}= [Xtrain{j}; Fold{ja}];
            Ytrain{j}= [Ytrain{j}; FoldLabel{ja}];
        end;
    end;
end;

P = cell(1,NFOLD);
meanX = cell(1,NFOLD);
for j = 1:NFOLD    
    [P{j}, meanX{j}] = PCA(Xtrain{j});
end;

end

