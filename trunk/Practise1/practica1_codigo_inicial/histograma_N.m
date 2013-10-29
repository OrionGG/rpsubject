function LABEL = histograma_N( DATOENTRADA,hist,N,histsize)
%HISTOGRAMA_N Summary of this function goes here
%   Detailed explanation goes here
% Funcion que dado un histograma de etiquetas y un dato de entrada
% devuelve la etiqueta que le corresponde dependiendo de N
DATOSPORCLASE = histsize.maxbin - histsize.minbin;
minvalue = 1;
maxvalue = N;

xn = floor(DATOENTRADA(1)/(DATOSPORCLASE/N))+1;
if(xn < minvalue)
    xn = 1;
else if(xn > maxvalue)
        xn = maxvalue;
    end;end;

yn = floor(DATOENTRADA(2)/(DATOSPORCLASE/N))+1;
if(yn < minvalue)
    yn = 1;
else if(yn > maxvalue)
        yn = maxvalue;
    end;end;

LABEL = hist(xn, yn);
end

