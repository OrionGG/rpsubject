function [ output_args ] = TestPCA( X, LABELS)
%TESTPCA Summary of this function goes here
%   Detailed explanation goes here

NFOLD = 10;
[Xtest, Ytest,Xtrain, Ytrain, P, meanX] = PrepareDataPCA( X, LABELS, NFOLD );


classLabels = unique(LABELS);
CLASSNUMBER = length(classLabels);
%featuresStart = CLASSNUMBER;
%featuresStart = CLASSNUMBER + round(((size(X, 2)-1)/5)/10);
%featuresEnd = size(X, 2)-1;
%featuresEnd = round((size(X, 2)-1)/5);
%interval = floor((featuresEnd-featuresStart)/39);
featuresStart = 16;
featuresEnd = 124;
interval = 1;


dvalues = featuresStart:interval:featuresEnd;
kvalues = 5:10:50;

i = 1;
MEANPERCENTAGEFOLD = zeros(length(dvalues)*length(kvalues), 4);
PERCENTAGEK = zeros(length(kvalues),length(dvalues)+1);
for di=1:length(dvalues) % Datos por filas. Es el n�m. de caracter�sticas
    d = dvalues(di);
    for ki=1:length(kvalues)
        k = kvalues(ki);
        PERCENTAGESFOLD = zeros(NFOLD,2);
        % Vald. Cruzada 10 fold.
        for f=1:NFOLD
            X_test_pca = proyectarPCA(P{f}(:,1:d), meanX{f}, Xtest{f});
            X_train_pca = proyectarPCA(P{f}(:,1:d), meanX{f}, Xtrain{f});
            
            P_LDA = LDA(X_train_pca, Ytrain{f});
            X_train_pca_lda = proyectarLDA(P_LDA, X_train_pca);
            X_test_pca_lda  = proyectarLDA(P_LDA, X_test_pca);
            
            ETIQUETAS_KNN = knnclassify(X_test_pca_lda, X_train_pca_lda, Ytrain{f}, k);
            [Error_KNN, MatrizConfusion_KNN] = crearMatrizConfusion(Ytest{f}, ETIQUETAS_KNN);
            
            PERCENTAGESFOLD(f,1) = 1 - Error_KNN;
            PERCENTAGESFOLD(f,2) = f;
            
            PERCENTAGEK(ki, di) = 1 - Error_KNN;
        end
        meanPercentage = mean(PERCENTAGESFOLD(:,1));
        MEANPERCENTAGEFOLD(i,1) = meanPercentage;
        MEANPERCENTAGEFOLD(i,2) = d;
        MEANPERCENTAGEFOLD(i,3) = k;
        MEANPERCENTAGEFOLD(i,4) = i;
        i= i+1;
    end;
end;
figure;
PERCENTAGEK(:,length(dvalues)+1) = mean(PERCENTAGEK(:, 1:length(dvalues)),2);
plot(kvalues,PERCENTAGEK(:,length(dvalues)+1));

figure;
plot(MEANPERCENTAGEFOLD(:,1));
[B, IX] = sort(MEANPERCENTAGEFOLD,1, 'descend');
MEANPERCENTAGEFOLD(IX(:,1),:)
%MEANPERCENTAGEKFOLD

end

