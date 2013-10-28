function [DATOS, ETIQUETAS] = generar_muestra_gaussiana(NUM_DATOS_POR_CLASE, GAUSSIANAS, STD_RUIDO)

NUM_CLASES       = length(GAUSSIANAS);

%figure; 
DATOS       = [];
ETIQUETAS   = [];
for i=1:NUM_CLASES
  DATOS_i         = mvnrnd(GAUSSIANAS{i}.media, GAUSSIANAS{i}.cov, NUM_DATOS_POR_CLASE); 
  if (nargin == 3)
    RUIDO_i       = mvnrnd([0;0], diag(STD_RUIDO), NUM_DATOS_POR_CLASE); 
    DATOS_i       = DATOS_i + RUIDO_i;
  end
  DATOS           = [DATOS; DATOS_i]; 
  ETIQUETAS       = [ETIQUETAS; i.*ones(NUM_DATOS_POR_CLASE, 1)];
end





