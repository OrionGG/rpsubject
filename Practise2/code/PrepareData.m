function [Xtest, Ytest,Xtrain, Ytrain] = PrepareData( X, LABELS, NFOLD )
%PREPAREDATALDA Summary of this function goes here
%   This funtion prepare data to do a nfold evaluation


% Count class labels
classLabels = unique(LABELS);
CLASSNUMBER = length(classLabels);

Xtest  = cell(1,NFOLD);
Ytest  = cell(1,NFOLD);
Xtrain  = cell(1,NFOLD);
Ytrain  = cell(1,NFOLD);

% We select data randomly to do n-fold
for c=1:CLASSNUMBER
    DATAOFCLASS = X(LABELS==c,:);
    NumDataInClass = size(DATAOFCLASS,1);
    randpermClases{c} = randperm(NumDataInClass);
    
    NumDataInTest = round(NumDataInClass/NFOLD);
    
    for f = 1:NFOLD
        
        endTestIndexes = min(NumDataInClass, f * NumDataInTest);
        FoldIndexes{f} = randpermClases{c}((1+((f-1)* NumDataInTest)):endTestIndexes);
        Fold{f} = DATAOFCLASS(FoldIndexes{f},:);
        
        LABELCLASS = LABELS(LABELS==c);
        FoldLabel{f} = LABELCLASS(FoldIndexes{f}, :);
        
    end;
    
    for f = 1:NFOLD
        Xtest{f} = [Xtest{f};Fold{f}];
        Ytest{f} = [Ytest{f};FoldLabel{f}];
        for jb = 1:f-1
            Xtrain{f}= [Xtrain{f}; Fold{jb}];
            Ytrain{f}= [Ytrain{f}; FoldLabel{jb}];
        end;
        for ja = f+1:NFOLD
            Xtrain{f}= [Xtrain{f}; Fold{ja}];
            Ytrain{f}= [Ytrain{f}; FoldLabel{ja}];
        end;
    end;
end;

end

