function Practise2
%PRACTISE2 Summary of this function goes here
%   Detailed explanation goes here
%X = [2 4 3; 4 5 6; 2 5 6; 3 5 8; 4 3 2; 7 4 1;];
%y = [1;1;2;2;3;3];

[X, LABELS]= LoadImages;

%checkLDAQuality(X, LABELS);

%TestLDA(X, LABELS);

PCAPercentages = [70, 75, 80, 85, 90, 95];
TestPCA(X, LABELS, PCAPercentages);

for i = 1: length(PCAPercentages)
    PCAPercentage = PCAPercentages(i);
    A = PCA(X, PCAPercentage);
    XPCA = X * A;
end;


end

