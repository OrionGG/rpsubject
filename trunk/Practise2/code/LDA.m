function A = LDA( X, y )
% Input: X, m feature vectors by columns. 
% y label's vector
% Output: A, proyection matrix

% Determine size of input data
[m n] = size(X);

% Count class labels
classLabel = unique(y);
lengthy = length(classLabel);

% we calculate the mean of each class in case there is not the 
% same number of data in each class
meanX = zeros(lengthy,n);
for i = 1:lengthy
    DATAOFCLASS = X(y==i,:);
    meanX(i,:) = mean(DATAOFCLASS);
end;
meanAll = mean(meanX);

Sb = zeros(n,n);
Sw = zeros(n,n);
for i = 1:lengthy    
    Sb = Sb + (meanX(i,:) - meanAll)'*(meanAll-meanX(i,:));
    
    DATAOFCLASS = X(y==i,:);
    d = DATAOFCLASS-repmat(meanX(i,:),size(DATAOFCLASS,1),1);
    sumd = d'*d;
    Sw = Sw + sumd;
end;
invSw=inv(Sw);
v=invSw*Sb;

% find eigne values and eigen vectors of the (v)
[evec,eval]=eig(v);

% Sort eigen vectors according to eigen values (ascending order)
[evaluesSort, evaluesSortIdx]= sort(diag(eval), 'ascend');
% neglect eigen vectors according to small eigen values
if lengthy-1 < size(evec,2)
    % we take the n-(c-1) eigen vectors with smaller eigen values
    featuresToDelete = (size(evec,2) - (lengthy-1));
    evecSortIdxSub = evaluesSortIdx(1:featuresToDelete);
    
    % we delete them from eigen vector
    
    evec(:, evecSortIdxSub) = [];
end

A=evec;

end

