function [ output_args ] = TestPCA( X, LABELS, PCAPercentages)
%TESTPDA Summary of this function goes here
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

for pi=1:length(PCAPercentages)
    pvalue = PCAPercentages(pi);
    PERCENTAGESKNN = zeros(NFOLD,2);
    for j = 1:NFOLD
        %get a PDA proyection of the test data from the trining data
        [XPCA] = GetPCAProyectionsJFold(j, randpermClases, X, LABELS, pvalue, NFOLD);
        
        %get a LDA proyection of the test data from the trining data
        [proyectionTest, labelsTest, proyectionTrain, labelsTrain] = GetLDAProyectionsJFold(j, randpermClases, XPCA, LABELS, NFOLD);
        dataTest = [];
        dataTrain = [];
        for i=1:CLASSNUMBER
            dataTest = [dataTest;proyectionTest{i}];
            dataTrain = [dataTrain;proyectionTrain{i}];
        end;
        %------------------------------------------------------------------------
        % Clasification with K-NN
        %------------------------------------------------------------------------
        VALORES_K_EN_KNN              = [2, 3, 5, 7, 11, 13, 17, 19, 21, 23, 29, 31];
        tic
        CLASIFICADOR_KNN = entrenar_clasificador_knn(dataTrain, labelsTrain, VALORES_K_EN_KNN);
        ETIQUETAS_KNN = knnclassify(dataTest, dataTrain, labelsTrain, CLASIFICADOR_KNN.KOPTIMA);
        [Error_KNN, MatrizConfusion_KNN] = crearMatrizConfusion(labelsTest, ETIQUETAS_KNN);
        toc
        Error_KNN
        MatrizConfusion_KNN
        sprintf('K-NN - K = %d', CLASIFICADOR_KNN.KOPTIMA)
        PERCENTAGESKNN(j,1) = 1 - Error_KNN;
        PERCENTAGESKNN(j,2) = j;
    end;
    % figure with the diferents results of the kfold
    figure;
    plot(PERCENTAGESKNN(:,2), PERCENTAGESKNN(:,1));
    %we take the mean percentage of the n-fold
    MEANPERCENTAGEKNN = mean(PERCENTAGESKNN(:,1))
end;

end

