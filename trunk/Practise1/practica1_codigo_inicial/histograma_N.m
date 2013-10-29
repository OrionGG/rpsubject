function LABEL = histograma_N( DATOENTRADA,hist,N,histsize)
%HISTOGRAMA_N Summary of this function goes here
%   Detailed explanation goes here
% Funcion que dado un histograma de etiquetas y un dato de entrada
% devuelve la etiqueta que le corresponde dependiendo de N
rangobin = histsize.maxbin - histsize.minbin;
minvalue = 0;
maxvalue = 50;
rangobin = maxvalue - minvalue;

x = DATOENTRADA(1);
if(x < minvalue)
    xn = 1;
else if(x >= maxvalue)
        xn = N;
    else
        xn = floor(x/(rangobin/N))+1;
    end;
end;

y = DATOENTRADA(2);
if(y < minvalue)
    yn = 1;
else if(y >= maxvalue)
        yn = N;
    else
        yn = floor(y/(rangobin/N))+1;
    end;
end;

LABEL = hist(xn, yn);
end

