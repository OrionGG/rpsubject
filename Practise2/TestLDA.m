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
    
    [proyectionTest, labelsTest, proyectionTrain, labelsTrain] = GetLDAProyectionsJFold(j, randpermClases, X, LABELS, NFOLD);
    dataTest = [];
    dataTrain = [];
    for i=1:CLASSNUMBER
        dataTest = [dataTest;proyectionTest{i}];
        dataTrain = [dataTrain;proyectionTrain{i}];
    end;
       
    %------------------------------------------------------------------------
    % Pruebas con K-NN
    %------------------------------------------------------------------------
    
    VALORES_K_EN_KNN              = [2, 3, 5, 7, 11, 13, 17, 19, 21, 23, 29, 31];
    tic
    CLASIFICADOR_KNN = entrenar_clasificador_knn(dataTrain, labelsTrain, VALORES_K_EN_KNN)
    ETIQUETAS_KNN = knnclassify(dataTest, dataTrain, labelsTrain, CLASIFICADOR_KNN.KOPTIMA)
    %ETIQUETAS_KNN = dibujar_clasificacion(D, COLORES_CLASES, CLASIFICADOR_KNN, @clasificar_knn, sprintf('K-NN - %d datos - K = %d', NUM_DATOS_ENTRENA_POR_CLASE(i), CLASIFICADOR_KNN.KOPTIMA));
    [Error_KNN, MatrizConfusion_KNN] = crearMatrizConfusion(labelsTest, ETIQUETAS_KNN);
    toc
    Error_KNN
    MatrizConfusion_KNN
    sprintf('K-NN - K = %d', CLASIFICADOR_KNN.KOPTIMA)
    PERCENTAGESKNN(j) = 1 - Error_KNN;
end;

%we take the mean percentage of the n-fold
MEANPERCENTAGEHIST = mean(PERCENTAGESHIST)
MEANPERCENTAGEKNN = mean(PERCENTAGESKNN)

end

