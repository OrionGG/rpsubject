function prediccion = clasificar_Parzen( X, CLASIFICADOR_PARZEN )
%CLASIFICAR_PARZEN Summary of this function goes here
%   Detailed explanation goes here

% CLASIFICADOR_KNN el valor del k optimo para clasificar junto con el
% conjunto de datos y etiquetas de entrenamiento
    DATOENTRADA = X';
    NUMCLASES = length(unique(CLASIFICADOR_PARZEN.ETIQUETAS));
    lengthDatosClase = length(CLASIFICADOR_PARZEN.DATOS)/NUMCLASES;
    INDICES = zeros(NUMCLASES, lengthDatosClase);
    for i = 1:NUMCLASES
        DATOSCLASE = CLASIFICADOR_PARZEN.DATOS(CLASIFICADOR_PARZEN.ETIQUETAS == i,:);
        %usar todos los datos del clasificador para clasificar
        INDICES(i,:) = 1:length(DATOSCLASE);
    end;
    
    prediccion = parzen_h(DATOENTRADA,CLASIFICADOR_PARZEN.DATOS, CLASIFICADOR_PARZEN.ETIQUETAS,INDICES, CLASIFICADOR_PARZEN.HOPTIMA);

end

