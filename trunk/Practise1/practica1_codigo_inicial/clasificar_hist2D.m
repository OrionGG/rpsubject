function prediccion = clasificar_hist2D( X, CLASIFICADOR_HIST )
%CLASIFICAR_HIST2D Summary of this function goes here
%   Detailed explanation goes here
DATOENTRADA = X';
prediccion = histograma_N(DATOENTRADA, CLASIFICADOR_HIST.hist,CLASIFICADOR_KNN.NOPTIMA);

end

