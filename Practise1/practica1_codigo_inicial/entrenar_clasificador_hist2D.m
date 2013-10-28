function CLASIFICADOR_HIST = entrenar_clasificador_hist2D(DATOS, ETIQUETAS, DIVISIONES_HISTOGRAMA);
%ENTRENAR_CLASIFICADOR_HIST2D Summary of this function goes here
%   Detailed explanation goes here

YY         = unique(ETIQUETAS);
NUM_CLASES = length(YY);

NFOLD = 5;

KPERCENTAGES = zeros(length(DIVISIONES_HISTOGRAMA),2);;
PERCENTAGES = zeros(1,NFOLD);

aprioris = zeros(1,length(unique(ETIQUETAS)));


for i = 1:NUM_CLASES
    aprioris(i) = length(ETIQUETAS(ETIQUETAS==i))/length(ETIQUETAS);
end;

for ni=1:length(DIVISIONES_HISTOGRAMA)
    N = DIVISIONES_HISTOGRAMA(ni);
    
    nTrue = 0;
    
    %%ordenamos los datos aleatoriamente para hacer el n-fold
    randpermClases = zeros(NUM_CLASES,length(DATOS)/NUM_CLASES);
    for i=1:NUM_CLASES
        DATOSCLASE = DATOS(ETIQUETAS==i,:);
        randpermClases(i,:) = randperm(length(DATOSCLASE));
        DATOSCLASE = zeros(size(DATOSCLASE,1),size(DATOSCLASE,2));
    end;
    
    
    NFOLD = 5;
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
        
        %Crear histograma de los datos de entrenamiento
        histClase(:,:,3) = zeros(N,N);%histogramas por clase
        minvalue = 1;
        maxvalue = N;
        for i=1:NUM_CLASES
            DATOSCLASE = DATOS(ETIQUETAS==i,:);
            DATOSPORCLASE = length(DATOSCLASE);
            for ixTrainDataClass = 1: length(trainIndexes)
                DATO = DATOSCLASE(trainIndexes(i, ixTrainDataClass),:);
                xn = floor(DATO(1)/(DATOSPORCLASE/N))+1;
                if(xn < minvalue)
                    xn = 1;
                else if(xn > maxvalue)
                        xn = maxvalue;
                    end;end;
                
                yn = floor(DATO(2)/(DATOSPORCLASE/N))+1;
                if(yn < minvalue)
                    yn = 1;
                else if(yn > maxvalue)
                        yn = maxvalue;
                    end;end;
                
                histClase(xn,yn,i)=histClase(xn,yn,i)+1;
            end;
            
            DATOSCLASE = zeros(size(DATOSCLASE,1),size(DATOSCLASE,2));
        end;
        hist=zeros(N,N);%histograma de etiquetas usando los apriori
        for ii=1:size(hist,1)
            for jj = 1:size(hist,2)
                maxEtiqueta = 0;
                maxValue = -1;
                for ixClase = 1:size(histClase,3)
                    if(maxValue < (histClase(ii,jj,ixClase)*aprioris(ixClase)))
                        maxEtiqueta = ixClase;
                        maxValue = histClase(ii,jj,ixClase)*aprioris(ixClase);
                    end;
                end;
                hist(ii,jj) = maxEtiqueta;
            end;
        end;
        
        %Evaluar los datos de test
        for i=1:NUM_CLASES
            DATOSCLASE = DATOS(ETIQUETAS==i,:);
            NUMTESTDATACLASS = length(testIndexes);
            for ixTestDataClass = 1:NUMTESTDATACLASS
                DATOENTRADA =DATOSCLASE(testIndexes(i,ixTestDataClass),:);
                LABEL = histograma_N(DATOENTRADA, DATOS, ETIQUETAS, hist,N);
                nTrue = nTrue + (LABEL == i);
            end;
            DATOSCLASE = zeros(size(DATOSCLASE,1),size(DATOSCLASE,2));
        end;
        PERCENTAGES(j) = nTrue/(NUM_CLASES * (length(DATOSCLASE)/NFOLD));
        nTrue = 0;
    end;
    %we take the max percentage of the n-fold
    MEANPERCENTAGE = mean(PERCENTAGES);
    KPERCENTAGES(ni,:) = [MEANPERCENTAGE, N];
end;
[mKPerc, nKPerc] = max(KPERCENTAGES(:,1));

%Crear histograma con todos los datos
CLASIFICADOR_HIST{1}.hist = 0;
CLASIFICADOR_HIST{1}{1}.binsize = 0;
CLASIFICADOR_HIST{1,1}.minbin = 0;
CLASIFICADOR_HIST{1,1}.maxbin = 0;
end

