
function prediccion = clasificar_gaussianas(X, GAUSSIANAS)
% X, es un vector de características
% GAUSSIANAS, es un cell-array con los parámetros de las gaussianas 
%             que representan a las diferentes clases.
%

probs = zeros(length(GAUSSIANAS), 1);  
for j=1:length(GAUSSIANAS)
  % mvnpdf calcula la función de densidad de una gausiana multidimensional
  % (media, Matriz Covarianzas)
  probs(j) = mvnpdf(X, GAUSSIANAS{j}.media, GAUSSIANAS{j}.cov) * GAUSSIANAS{j}.apriori;
end

% probs es una matriz k * N donde k es el número de clases 
% (k = length(GAUSSIANAS)) y N es el número de datos de entrenamiento 
% (N = size(X, 2)).
%
% Por tanto, el valor probs(i,j) es la probabilidad a posteriori de que el 
% vector de características X(:,j) pertenezca a la clase i.
probs = probs./sum(probs);

% Devolvemos la etiqueta de la clase com mayor probabilidad a posteriori
% (el máximo).
[val, prediccion] = max(probs);
