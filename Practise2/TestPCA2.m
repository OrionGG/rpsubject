function [ output_args ] = TestPCA2( X, LABELS, features)
%TESTPCA2 Summary of this function goes here
%   Detailed explanation goes here

NFOLD = 10;
[Xtest, Ytest,Xtrain, Ytrain, P, meanX] = PrepareDataPCA( X, LABELS, NFOLD );
i = 1;

dvalues = 1:size(X, 2)-1;
kvalues = 1:10:41;
MEANPERCENTAGEKFOLD = zeros(length(dvalues)*length(kvalues), 3);
for di=1:length(dvalues) % Datos por columnas. Es el núm. de características
    d = dvalues(di);
    for ki=1:length(kvalues)
        k = kvalues(ki);
        PERCENTAGESKFOLD = zeros(NFOLD,2);
        % Vald. Cruzada 5 fold.
        for f=1:NFOLD
            X_test_pca = proyectarPCA(P{f}(:,1:d), meanX{f}, Xtest{f});
            X_train_pca = proyectarPCA(P{f}(:,1:d), meanX{f}, Xtrain{f});
            
            P_LDA = LDA(X_train_pca, Ytrain{f});
            X_train_pca_lda = proyectarLDA(P_LDA, X_train_pca);
            X_test_pca_lda  = proyectarLDA(P_LDA, X_test_pca);
            
            ETIQUETAS_KNN = knnclassify(X_test_pca_lda, X_train_pca_lda, Ytrain{f}, k);
            [Error_KNN, MatrizConfusion_KNN] = crearMatrizConfusion(Ytest{f}, ETIQUETAS_KNN);
            
            PERCENTAGESKFOLD(f,1) = 1 - Error_KNN;
            PERCENTAGESKFOLD(f,2) = f;
        end
        meanPercentage = mean(PERCENTAGESKFOLD(:,1));
        meanPercentage
        MEANPERCENTAGEKFOLD(i,1) = meanPercentage;
        MEANPERCENTAGEKFOLD(i,2) = d;
        MEANPERCENTAGEKFOLD(i,3) = k;
        i= i+1;
    end
end
end

