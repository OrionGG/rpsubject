function checkLDAQuality( X, LABELS)
%CHECKLDAQUALITY Summary of this function goes here
%   Detailed explanation goes here

NFOLD = 10;

% Count class labels
classLabels = unique(LABELS);
CLASSNUMBER = length(classLabels);

% We select data randomly to do n-fold
randpermClases = zeros(CLASSNUMBER,length(X)/CLASSNUMBER);
for i=1:CLASSNUMBER
    DATAOFCLASS = X(LABELS==i,:);
    randpermClases(i,:) = randperm(length(DATAOFCLASS));
    DATAOFCLASS = zeros(size(DATAOFCLASS,1),size(DATAOFCLASS,2));
end;

for j = 1:NFOLD   
    lengthMeanByClass = length(X)/NUM_CLASES;
    lengthMeanByClassByFold = lengthMeanByClass/NFOLD;
    
    testIndexes = zeros(NUM_CLASES, lengthMeanByClassByFold);
    trainIndexes = zeros(NUM_CLASES, lengthMeanByClass - lengthMeanByClassByFold);
    
    %Generación de indices de entrenamiento y test
    for i=1:NUM_CLASES
        DATAOFCLASS = X(LABELS==i,:);
        
        lengthByClassByFoldTest = length(DATAOFCLASS)/NFOLD;
        lengthByClassByFoldTrain = length(DATAOFCLASS) - length(DATAOFCLASS)/NFOLD;
        
        %indices de los datos para datos de test
        testIndexes(i,:) = randpermClases(i, (1+((j-1)*lengthByClassByFoldTest)):j*lengthByClassByFoldTest);
        %indices de los datos para los datos de entrenamiento
        trainIndexes(i,1:((j-1)*lengthByClassByFoldTest)) = randpermClases(i,1:((j-1)*lengthByClassByFoldTest));
        trainIndexes(i,(1+((j-1)*lengthByClassByFoldTest)):lengthByClassByFoldTrain) = randpermClases(i,(j*lengthByClassByFoldTest)+1:length(DATAOFCLASS));
        
        DATAOFCLASS = zeros(size(DATAOFCLASS,1),size(DATAOFCLASS,2));
    end;
end;


end

