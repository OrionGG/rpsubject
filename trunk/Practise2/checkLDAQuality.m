function checkLDAQuality( X, LABELS)
%CHECKLDAQUALITY Summary of this function goes here
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

% Determine size of input data
[m n] = size(X);

for j = 1:NFOLD
    
    [proyectionTest, labelsTest, proyectionTrain, labelsTrain] = GetLDAProyectionsJFold(j, randpermClases, X, LABELS, NFOLD);
    
    figure
    COLORES{1} = [255; 0; 0];
    COLORES{2} = [0; 255; 0];
    COLORES{3} = [0; 0; 255];
    COLORES{4} = [0; 0; 0];
    
    for i=1:CLASSNUMBER
        
        color    = COLORES{i};
        r        = color(1)/255;
        g        = color(2)/255;
        b        = color(3)/255;
        
        plot3(proyectionTest{i}(:,1), proyectionTest{i}(:,2), proyectionTest{i}(:,3), 'x', 'Color', [r,g,b] );
        hold on;
       
    end;
    grid on
    axis square
    hold off;
end;
end

