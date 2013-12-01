function [Error, MatrizConfusion] = crearMatrizConfusion(ETIQUETAS_REALES, ETIQUETAS_CLASIFICADOR);
%CREARMATRIZCONFUSION Summary of this function goes here
%   Detailed explanation goes here
% Funcion para crear la matriz de confusión despues de clasificar los datos
% con un determinado clasificador
[m,n] = size(ETIQUETAS_REALES);
NUM_CLASES = length(unique(ETIQUETAS_CLASIFICADOR));

falsePositives = 0;
MatrizConfusion = zeros(NUM_CLASES, NUM_CLASES);

for i = 1:m
    for j = 1:n
        if(ETIQUETAS_REALES(i,j) ~= ETIQUETAS_CLASIFICADOR(i,j))
            falsePositives = falsePositives + 1;
        end;
        MatrizConfusion(ETIQUETAS_REALES(i,j), ETIQUETAS_CLASIFICADOR(i,j)) = MatrizConfusion(ETIQUETAS_REALES(i,j), ETIQUETAS_CLASIFICADOR(i,j)) +1;
    end;
end;

Error = falsePositives/(m*n);

end

