function prediccion = clasificar_knn( X, CLASIFICADOR_KNN )
%CLASIFICAR_KNN Summary of this function goes here
%   Detailed explanation goes here
    DATOENTRADA = X';
    NUMCLASES = length(unique(CLASIFICADOR_KNN.ETIQUETAS));
    lengthDatosClase = length(CLASIFICADOR_KNN.DATOS)/NUMCLASES;
    INDICES = zeros(NUMCLASES, lengthDatosClase);
    for i = 1:NUMCLASES
        DATOSCLASE = CLASIFICADOR_KNN.DATOS(CLASIFICADOR_KNN.ETIQUETAS == i,:);
        %usar todos los datos del clasificador para clasificar
        INDICES(i,:) = 1:length(DATOSCLASE);
    end;
    
    prediccion = distancia_k(DATOENTRADA,CLASIFICADOR_KNN.DATOS, CLASIFICADOR_KNN.ETIQUETAS,INDICES, CLASIFICADOR_KNN.KOPTIMA);

end

