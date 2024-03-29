function CLASIFICADOR_PARZEN = entrenar_clasificador_Parzen( DATOS, ETIQUETAS, VALORES_H_EN_PARZEN )
%ENTRENAR_CLASIFICADOR_PARZEN Summary of this function goes here
%   Detailed explanation goes here
YY         = unique(ETIQUETAS);
NUM_CLASES = length(YY);

NFOLD = 5;

HPERCENTAGES = zeros(length(VALORES_H_EN_PARZEN),3);
PERCENTAGES = zeros(1,NFOLD);
PRODPROBFUNCTIONS = zeros(1,NFOLD);

for hi=1:length(VALORES_H_EN_PARZEN)    
    hvalue = VALORES_H_EN_PARZEN(hi);
    
    %escogemos los datos aleatoriamente para hacer el n-fold
    randpermClases = zeros(NUM_CLASES,length(DATOS)/NUM_CLASES);
    for i=1:NUM_CLASES
        DATOSCLASE = DATOS(ETIQUETAS==i,:);
        randpermClases(i,:) = randperm(length(DATOSCLASE));
        DATOSCLASE = zeros(size(DATOSCLASE,1),size(DATOSCLASE,2));
    end;
    
    for j = 1:NFOLD
        nTrue = 0;
        fnhTotal = 1;
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
                [LABEL, fnh] = parzen_h(DATOENTRADA, DATOS, ETIQUETAS, INDICES, hvalue);
                %si la etiqueta se corresponde a la verdadera sumamos 1
                if(LABEL == i)
                    nTrue = nTrue + (LABEL == i);
                    fnhTotal = fnhTotal * fnh;
                end;
            end;
            DATOSCLASE = zeros(size(DATOSCLASE,1),size(DATOSCLASE,2));
        end;
        PERCENTAGES(j) = nTrue/(NUM_CLASES * (length(DATOSCLASE)/NFOLD));
        %PRODPROBFUNCTIONS(j) = fnhTotal;
        nTrue = 0;
        %fnhTotal = 1;
    end;
    %we take the max percentage of the n-fold
    MEANPERCENTAGE = mean(PERCENTAGES);
    %MEANPRODPROBFUNCTIONS = mean(PRODPROBFUNCTIONS);
    PRODPROBFUNCTIONS = fnhTotal;
    fnhTotal = 1;
    HPERCENTAGES(hi,:) = [MEANPERCENTAGE, hvalue, PRODPROBFUNCTIONS];
end;
HPERCENTAGES
figure;
plot(HPERCENTAGES(:,2), HPERCENTAGES(:,1));
figure;
plot(HPERCENTAGES(:,2), HPERCENTAGES(:,3));
[mHPercSort, nHPercSort] = sort(HPERCENTAGES(:,1), 'descend');
if(1 < length(mHPercSort) && mHPercSort(1) == mHPercSort(2))
    BESTSH = HPERCENTAGES(HPERCENTAGES(:,1) == mHPercSort(1),:);
    [mHPerc, nHPerc] = max(BESTSH(:,3));
    CLASIFICADOR_PARZEN.HOPTIMA = BESTSH(nHPerc,2);
else
    CLASIFICADOR_PARZEN.HOPTIMA = HPERCENTAGES(nHPercSort(1),2);
end;
CLASIFICADOR_PARZEN.DATOS = DATOS;
CLASIFICADOR_PARZEN.ETIQUETAS = ETIQUETAS;
end

