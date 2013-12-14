function [ output_args ] = TestLDA2( X, LABELS)
%TESTLDA Summary of this function goes here
%   Detailed explanation goes here
NFOLD = 10;
[Xtest, Ytest,Xtrain, Ytrain] = PrepareData( X, LABELS, NFOLD );


classLabels = unique(LABELS);
CLASSNUMBER = length(classLabels);

kvalues = 5:5:75;

MEANPERCENTAGEKFOLD = zeros(length(kvalues), 2);

for ki=1:length(kvalues)
    k = kvalues(ki);
    PERCENTAGESKFOLD = zeros(NFOLD,2);
    % Vald. Cruzada 5 fold.
    for f=1:NFOLD
        
        P_LDA = LDA(Xtrain{f}, Ytrain{f});
        X_train_lda = proyectarLDA(P_LDA, Xtrain{f});
        X_test_lda  = proyectarLDA(P_LDA, Xtest{f});
        
        ETIQUETAS_KNN = knnclassify(X_test_lda, X_train_lda, Ytrain{f}, k);
        [Error_KNN, MatrizConfusion_KNN] = crearMatrizConfusion(Ytest{f}, ETIQUETAS_KNN);
        
        PERCENTAGESKFOLD(f,1) = 1 - Error_KNN;
        PERCENTAGESKFOLD(f,2) = f;
    end
    meanPercentage = mean(PERCENTAGESKFOLD(:,1));
    MEANPERCENTAGEKFOLD(ki,1) = meanPercentage;
    MEANPERCENTAGEKFOLD(ki,2) = k;
end
figure;
plot(MEANPERCENTAGEKFOLD(:,2),MEANPERCENTAGEKFOLD(:,1));
[B, IX] = sort(MEANPERCENTAGEKFOLD,1, 'descend');
MEANPERCENTAGEKFOLD(IX(:,1),:)
%MEANPERCENTAGEKFOLD
mean(MEANPERCENTAGEKFOLD(:,1))

end

