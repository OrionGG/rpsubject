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
    
    [proyectionTest, proyectionTrain, labelsTrain] = GetLDAProyectionsJFold(j, randpermClases, X, LABELS, NFOLD);
    dataTrain = [];
    for i=1:CLASSNUMBER
        dataTrain = [dataTrain;proyectionTrain{i}];
    end;
        %
    %   %------------------------------------------------------------------------
    %   % Pruebas con histogramas 2-D
    %   %------------------------------------------------------------------------
    DIVISIONES_HISTOGRAMA         = 3:30;
    
    HISTSIZE.minvalue             = 0;
    HISTSIZE.maxvalue             = 255;
    tic
    CLASIFICADOR_HIST = entrenar_clasificador_hist(dataTrain, labelsTrain, DIVISIONES_HISTOGRAMA, HISTSIZE);
    figure(nfigure);
    subplot(2, 3, 5);
    ETIQUETAS_HIST = dibujar_clasificacion(D, COLORES_CLASES, CLASIFICADOR_HIST, @clasificar_hist, sprintf('Hist - %d datos - N = %d', NUM_DATOS_ENTRENA_POR_CLASE(i), CLASIFICADOR_HIST.NOPTIMA));
    [Error_HIST, MatrizConfusion_HIST] = crearMatrizConfusion(ETIQUETAS_REALES, ETIQUETAS_HIST);
    toc
    Error_HIST
    MatrizConfusion_HIST
    sprintf('Hist - %d datos - N = %d', NUM_DATOS_ENTRENA_POR_CLASE(i), CLASIFICADOR_HIST.NOPTIMA)
    
end;

end

