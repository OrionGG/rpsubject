function CLASIFICADOR_KNN = entrenar_clasificador_knn(DATOS, ETIQUETAS, VALORES_K_EN_KNN)
%ENTRENAR_CLASIFICADOR_KNN Summary of this function goes here
%   Detailed explanation goes here
% Entrena un clasificador KNN con los datos de entrenamiento con el
% objetivo de obtener el k que nos da mejor rendimiento


YY         = unique(ETIQUETAS);
NUM_CLASES = length(YY);

NFOLD = 10;

KPERCENTAGES = zeros(length(VALORES_K_EN_KNN),2);
PERCENTAGES = zeros(1,NFOLD);

for ki=1:length(VALORES_K_EN_KNN)
     kvalue = VALORES_K_EN_KNN(ki);
%     mdl = ClassificationKNN.fit(DATOS,ETIQUETAS,'NumNeighbors',kvalue, 'Distance','euclidean');
%     cvKNN = crossval(mdl, 'kfold',NFOLD)
%     L = kfoldLoss(cvtree)
    
    indices = crossvalind('Kfold',ETIQUETAS,NFOLD);
    cp = classperf(ETIQUETAS);
    for i = 1:10
        test = (indices == i); train = ~test;
        class = knnclassify(DATOS(test,:),DATOS(train,:),ETIQUETAS(train,:), kvalue);
        classperf(cp,class,test)
    end
    cp.ErrorRate
    
    KPERCENTAGES(ki,:) = [1-cp.ErrorRate, kvalue];
end;
KPERCENTAGES
figure;
plot(KPERCENTAGES(:,2), KPERCENTAGES(:,1));
[mKPerc, nKPerc] = max(KPERCENTAGES(:,1));
CLASIFICADOR_KNN.KOPTIMA = KPERCENTAGES(nKPerc,2);
CLASIFICADOR_KNN.DATOS = DATOS;
CLASIFICADOR_KNN.ETIQUETAS = ETIQUETAS;
end

