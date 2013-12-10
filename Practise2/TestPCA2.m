function [ output_args ] = TestPCA2( X, LABELS, features)
%TESTPCA2 Summary of this function goes here
%   Detailed explanation goes here

NFOLD = 10;
[Xtest, Ytest,Xtrain, Ytrain, P, meanX] = PrepareDataPCA( X, LABELS, NFOLD );

for d=1:size(X, 2)-1 % Datos por columnas. Es el núm. de características
  for k=1:10:41
    % Vald. Cruzada 5 fold.
    for f=1:NFOLD
      X_test_pca = proyectarPCA(P{f}(:,1:d), meanX{f}, Xtest{f});
      X_train_pca = proyectarPCA(P{f}(:,1:d), meanX{f}, Xtrain{f});

      P_LDA = LDA(X_train_pca, Ytrain{f});
      X_train_pca_lda = proyectarLDA(P_LDA, X_train_pca);
      X_test_pca_lda  = proyectarLDA(P_LDA, X_test_pca);

      CLASIFICADOR = entrenar_knn_simple(X_train_pca_lda, Y_train, k);
      estimado     = clasificar_knn(CLASIFICADOR, X_test_pca_lda);

      % Registrar error/acierto del test ...
      % ...
    end
  end
end
end

