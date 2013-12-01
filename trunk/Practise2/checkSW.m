function [ output_args ] = checkSW( X, LABELS)
%CHECKSW check if Sw is singular after doing LDA to data


A = LDA(X, LABELS);

proyectedX = X*A;

% Determine size of input data
[m n] = size(proyectedX);

% Count class labels
classLabel = unique(LABELS);
CLASSNUMBER = length(classLabel);
% we calculate the mean of each class in case there is not the 
% same number of data in each class
meanX = zeros(CLASSNUMBER,n);
for i = 1:CLASSNUMBER
    DATAOFCLASS = proyectedX(LABELS==i,:);
    meanX(i,:) = mean(DATAOFCLASS);
end;
meanAll = mean(meanX);

Sb = zeros(n,n);
Sw = zeros(n,n);
for i = 1:CLASSNUMBER    
    Sb = Sb + (meanX(i,:) - meanAll)'*(meanAll-meanX(i,:));
    
    DATAOFCLASS = proyectedX(LABELS==i,:);
    d = DATAOFCLASS-repmat(meanX(i,:),size(DATAOFCLASS,1),1);
    sumd = d'*d;
    Sw = Sw + sumd;
end;
%sprintf('RANK Sw = %d', rank(Sw))
%sprintf('RCOND Sw = %d', rcond(Sw))

%sprintf('RANK ASwAt = %d', rank(A*Sw*A'))
sprintf('RCOND ASwAt = %d', rcond(A*Sw*A'))

k = min(rank(Sw), rank(Sb));
sprintf('Max k = %d', k)
St = Sw + Sb;
%sprintf('RANK St = %d', rank(St))
%sprintf('RCOND St = %d', rcond(St))
sprintf('RCOND ASwAt = %d', rcond(A*St*A'))

end

