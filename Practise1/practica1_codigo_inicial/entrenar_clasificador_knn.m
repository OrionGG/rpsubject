function CLASIFICADOR_KNN = entrenar_clasificador_knn(DATOS, ETIQUETAS, VALORES_K_EN_KNN)
%ENTRENAR_CLASIFICADOR_KNN Summary of this function goes here
%   Detailed explanation goes here
% Entrena un clasificador KNN con los datos de entrenamiento con el
% objetivo de obtener el k que nos da mejor rendimiento


YY         = unique(ETIQUETAS);
NUM_CLASES = length(YY);

NFOLD = 5;

KPERCENTAGES = zeros(length(VALORES_K_EN_KNN),2);
PERCENTAGES = zeros(1,NFOLD);

for ki=1:length(VALORES_K_EN_KNN)
    kvalue = VALORES_K_EN_KNN(ki);
    
    nTrue = 0;
    
    %escogemos los datos aleatoriamente para hacer el n-fold
    randpermClases = zeros(NUM_CLASES,length(DATOS)/NUM_CLASES);
    for i=1:NUM_CLASES
        DATOSCLASE = DATOS(ETIQUETAS==i,:);
        randpermClases(i,:) = randperm(length(DATOSCLASE));
        DATOSCLASE = zeros(size(DATOSCLASE,1),size(DATOSCLASE,2));
    end;
    
    for j = 1:NFOLD
        lengthMeanByClass = length(DATOS)/NUM_CLASES;
        lengthMeanByClassByFold = lengthMeanByClass/NFOLD;
        
        testIndexes = zeros(NUM_CLASES, lengthMeanByClassByFold);
        trainIndexes = zeros(NUM_CLASES, lengthMeanByClass - lengthMeanByClassByFold);
        
        %Generación de indices de entrenamiento y test
        for i=1:NUM_CLASES
            DATOSCLASE = DATOS(ETIQUETAS==i,:); 
            
            lengthByClassByFoldTest = length(DATOSCLASE)/NFOLD;
            lengthByClassByFoldTrain = length(DATOSCLASE) - length(DATOSCLASE)/NFOLD;
            
            %indices de los datos para datos de test
            testIndexes(i,:) = randpermClases(i, (1+((j-1)*lengthByClassByFoldTest)):j*lengthByClassByFoldTest);
            %indices de los datos para los datos de entrenamiento
            trainIndexes(i,1:((j-1)*lengthByClassByFoldTest)) = randpermClases(i,1:((j-1)*lengthByClassByFoldTest));
            trainIndexes(i,(1+((j-1)*lengthByClassByFoldTest)):lengthByClassByFoldTrain) = randpermClases(i,(j*lengthByClassByFoldTest)+1:length(DATOSCLASE));
             
            DATOSCLASE = zeros(size(DATOSCLASE,1),size(DATOSCLASE,2));
        end;
                
        %Evaluar los datos de test   
        for i=1:NUM_CLASES
            DATOSCLASE = DATOS(ETIQUETAS==i,:); 
            NUMTESTDATACLASS = length(testIndexes);
            for ixTestDataClass = 1:NUMTESTDATACLASS
                DATOENTRADA =DATOSCLASE(testIndexes(i,ixTestDataClass),:);
                INDICES = trainIndexes;
                %devolvemos la equiqueta de los kvalue vecinos mas cercanos
                LABEL = distancia_k(DATOENTRADA, DATOS, ETIQUETAS, INDICES, kvalue);
                %si la etiqueta se corresponde a la verdadera sumamos 1
                nTrue = nTrue + (LABEL == i);
            end;
            DATOSCLASE = zeros(size(DATOSCLASE,1),size(DATOSCLASE,2));
        end;
        PERCENTAGES(j) = nTrue/(NUM_CLASES * (length(DATOSCLASE)/NFOLD));
        nTrue = 0;
    end;
    %we take the max percentage of the n-fold
    MEANPERCENTAGE = mean(PERCENTAGES);
    KPERCENTAGES(ki,:) = [MEANPERCENTAGE, kvalue];
end;
KPERCENTAGES
figure;
plot(KPERCENTAGES(:,2), KPERCENTAGES(:,1));
[mKPerc, nKPerc] = max(KPERCENTAGES(:,1));
CLASIFICADOR_KNN.KOPTIMA = KPERCENTAGES(nKPerc,2);
CLASIFICADOR_KNN.DATOS = DATOS;
CLASIFICADOR_KNN.ETIQUETAS = ETIQUETAS;
end

