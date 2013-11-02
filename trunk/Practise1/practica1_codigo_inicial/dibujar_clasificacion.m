function [mEtiquetas] = dibujar_clasificacion(D, COLORES_CLASES, DATOS_CLASIFICADOR, func_clasificar, nombre_experimento)
%
% Este script clasifica todos los puntos en una rejilla [1,D]x[1,D]
% llamando a la función: func_clasificar(DATOS_CLASIFICADOR, [i;j]);
%
mEtiquetas = zeros(D,D);

Prediccion = zeros(D, D, 3);
for i=1:D
  for j=1:D
    % For all Gaussians ...
    predicted            = func_clasificar([i; j], DATOS_CLASIFICADOR);
    
    Prediccion(i,j,1)    = COLORES_CLASES{predicted}(1);
    Prediccion(i,j,2)    = COLORES_CLASES{predicted}(2);
    Prediccion(i,j,3)    = COLORES_CLASES{predicted}(3);
    
    mEtiquetas(i,j) = predicted;
  end
end

imagesc(double(Prediccion)./255);
axis image;
axis xy;
title(nombre_experimento);
xlabel('X');
ylabel('Y');

grid on;


