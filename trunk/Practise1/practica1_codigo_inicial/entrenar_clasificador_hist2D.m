function CLASIFICADOR_HIST = entrenar_clasificador_hist2D(DATOS, ETIQUETAS, DIVISIONES_HISTOGRAMA, HISTSIZE)
%ENTRENAR_CLASIFICADOR_HIST2D Summary of this function goes here
%   Detailed explanation goes here

YY         = unique(ETIQUETAS);
NUM_CLASES = length(YY);

NFOLD = 5;

NPERCENTAGES = zeros(length(DIVISIONES_HISTOGRAMA),2);
PERCENTAGES = zeros(1,NFOLD);

aprioris = zeros(1,length(unique(ETIQUETAS)));


for i = 1:NUM_CLASES
    aprioris(i) = length(ETIQUETAS(ETIQUETAS==i))/length(ETIQUETAS);
end;

for ni=1:length(DIVISIONES_HISTOGRAMA)
    N = DIVISIONES_HISTOGRAMA(ni);
    
    nTrue = 0;
    
    %escogemos los datos aleatoriamente para hacer el n-fold
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
        
        %crear el histogroama de etiquetas
        hist = crearHistEtiquetas(DATOS,  ETIQUETAS, trainIndexes, N, aprioris, HISTSIZE);
        
        %Evaluar los datos de test
        for i=1:NUM_CLASES
            DATOSCLASE = DATOS(ETIQUETAS==i,:);
            
            NUMTESTDATACLASS = length(testIndexes);
            for ixTestDataClass = 1:NUMTESTDATACLASS
                DATOENTRADA =DATOSCLASE(testIndexes(i,ixTestDataClass),:);
                histsize.minvalue = HISTSIZE.minvalue;
                histsize.maxvalue = HISTSIZE.maxvalue;
                LABEL = histograma_N(DATOENTRADA, hist,N, histsize);
                nTrue = nTrue + (LABEL == i);
            end;
            DATOSCLASE = zeros(size(DATOSCLASE,1),size(DATOSCLASE,2));
        end;
        PERCENTAGES(j) = nTrue/(NUM_CLASES * (length(DATOSCLASE)/NFOLD));
        nTrue = 0;
    end;
    %we take the max percentage of the n-fold
    MEANPERCENTAGE = mean(PERCENTAGES);
    NPERCENTAGES(ni,:) = [MEANPERCENTAGE, N];
end;
%plot(NPERCENTAGES(:,1));
NPERCENTAGES
[mNPerc, nNPerc] = max(NPERCENTAGES(:,1));
CLASIFICADOR_HIST.NOPTIMA = NPERCENTAGES(nNPerc,2);

%crear el histogroama de etiquetas par todos los datos
lengthMeanByClass = length(DATOS)/NUM_CLASES;
TODOSLOSINDICES = zeros(NUM_CLASES, lengthMeanByClass);
for i = 1:NUM_CLASES        
    DATOSCLASE = DATOS(ETIQUETAS == i,:);
    %usar todos los datos del clasificador para crear el histograma
    TODOSLOSINDICES(i,:) = 1:length(DATOSCLASE);
end;
hist = crearHistEtiquetas(DATOS,  ETIQUETAS, TODOSLOSINDICES, CLASIFICADOR_HIST.NOPTIMA, aprioris, HISTSIZE);

%Crear histograma con todos los datos
CLASIFICADOR_HIST.hist = hist;
CLASIFICADOR_HIST.HISTSIZE.minvalue = 0;
CLASIFICADOR_HIST.HISTSIZE.maxvalue = 50;

%CLASIFICADOR_HIST{1}.binsize = 0;
%CLASIFICADOR_HIST{1}.minbin = 0;
%CLASIFICADOR_HIST{1}.maxbin = 0;
%CLASIFICADOR_HIST{2}.binsize = 0;
%CLASIFICADOR_HIST{2}.minbin = 0;
%CLASIFICADOR_HIST{2}.maxbin = 0;
%CLASIFICADOR_HIST{3}.binsize = 0;
%CLASIFICADOR_HIST{3}.minbin = 0;
%CLASIFICADOR_HIST{3}.maxbin = 0;
end

