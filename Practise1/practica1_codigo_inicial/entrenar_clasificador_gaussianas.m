function GAUSSIANAS = entrenar_clasificador_gaussianas(DATOS, ETIQUETAS, TIPO)

if nargin==2
  TIPO = 1;
end

YY         = unique(ETIQUETAS);
NUM_CLASES = length(YY);

GAUSSIANAS = cell(NUM_CLASES, 1);
for i=1:NUM_CLASES
  GAUSSIANAS{i}.media   = mean(DATOS(ETIQUETAS==i,:))';
  GAUSSIANAS{i}.apriori = 1/NUM_CLASES;

  if (TIPO == 1) % Generar covarianzas diferentes (las muestrales)
    GAUSSIANAS{i}.cov     = cov(DATOS(ETIQUETAS==i,:)); 
  elseif (TIPO == 2) % Generar covarianzas iguales (la total)
    GAUSSIANAS{i}.cov     = cov(DATOS);       
  elseif (TIPO == 3)
    GAUSSIANAS{i}.cov     = diag(std(DATOS));
  end
end