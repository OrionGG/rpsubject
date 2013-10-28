
function [GAUSSIANAS, COLORES] = generar_gaussianas_reales(TIPO, D)

COLORES{1} = [255; 0; 0];
COLORES{2} = [0; 255; 0];
COLORES{3} = [0; 0; 255];

if (TIPO == 2) % Gaussianas covarianzas iguales
  C = [D D/2; ...
       D/2 D];
 
  GAUSSIANAS{1}.media   = [D/4; D/4]; % (row, col)
  GAUSSIANAS{1}.cov     = C; 
  GAUSSIANAS{1}.apriori = 1/4;

  GAUSSIANAS{2}.media   = [D/4; 3*(D/4)]; % (row, col)
  GAUSSIANAS{2}.cov     = C;
  GAUSSIANAS{2}.apriori = 1/4;

  GAUSSIANAS{3}.media   = [sqrt((D/2)^2-(D/4)^2) + D/4; D/2]; % (row, col)
  GAUSSIANAS{3}.cov     = C;
  GAUSSIANAS{3}.apriori = 1/2;
          
elseif (TIPO==1) % Covarianzas muy diferentes 
  
  GAUSSIANAS{1}.media   = [D/4; D/4]; % (row, col)
  GAUSSIANAS{1}.cov     = [D D/4; D/4 D/8]; 
  GAUSSIANAS{1}.apriori = 1/4;

  GAUSSIANAS{2}.media   = [D/4; 3*(D/4)]; % (row, col)
  GAUSSIANAS{2}.cov     = [D/8 D/8; D/8 D];
  GAUSSIANAS{2}.apriori = 1/2;

  GAUSSIANAS{3}.media   = [sqrt((D/2)^2-(D/4)^2) + D/4; D/2]; % (row, col)
  GAUSSIANAS{3}.cov     = [D/8 D/8; D/8 D/3];
  GAUSSIANAS{3}.apriori = 1/4;
end; 

