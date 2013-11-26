function prediccion = clasificar_hist( X, CLASIFICADOR_HIST )
% X, es un vector de características
% CLASIFICADOR_HIST el histograma de etiquetas junto con los margenes
DATOENTRADA = X';
prediccion = histograma_N(DATOENTRADA, CLASIFICADOR_HIST.hist,CLASIFICADOR_HIST.NOPTIMA, CLASIFICADOR_HIST.HISTSIZE);

end

