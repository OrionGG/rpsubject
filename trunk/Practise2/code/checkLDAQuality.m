function checkLDAQuality( X, LABELS)
%CHECKLDAQUALITY Summary of this function goes here
%   Detailed explanation goes here

NFOLD = 10;
[Xtest, Ytest,Xtrain, Ytrain] = PrepareData( X, LABELS, NFOLD );

classLabels = unique(LABELS);
CLASSNUMBER = length(classLabels);

rcond = zeros(NFOLD, 1);
% Vald. Cruzada 10 fold.
for f=1:NFOLD
    
    P_LDA = LDA(Xtrain{f}, Ytrain{f});
    X_train_lda = proyectarLDA(P_LDA, Xtrain{f});
    X_test_lda  = proyectarLDA(P_LDA, Xtest{f});
   
    figure;
    COLORES{1} = [255; 0; 0];
    COLORES{2} = [0; 255; 0];
    COLORES{3} = [0; 0; 255];
    COLORES{4} = [0; 0; 0];
    
    %figure with the test data in each color
    for i=1:CLASSNUMBER
        X_test_lda_class = [];
        X_test_lda_class = X_test_lda(Ytest{f}==i,:);
        
        color    = COLORES{i};
        r        = color(1)/255;
        g        = color(2)/255;
        b        = color(3)/255;
        
        plot3(X_test_lda_class(:,1), X_test_lda_class(:,2), X_test_lda_class(:,3), 'x', 'Color', [r,g,b] );
        hold on;
        
    end;
    grid on
    axis square
    hold off;
    
    
    rcond(f) = checkSW(X_test_lda, Ytest{f});
end

mean(rcond, 1)

end

