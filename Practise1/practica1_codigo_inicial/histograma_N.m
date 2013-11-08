function LABEL = histograma_N( DATOENTRADA,hist,N,HISTSIZE)
%HISTOGRAMA_N Summary of this function goes here
%   Detailed explanation goes here
% Funcion que dado un histograma de etiquetas y un dato de entrada
% devuelve la etiqueta que le corresponde dependiendo de N

minvalue = HISTSIZE.minvalue;
maxvalue = HISTSIZE.maxvalue;
rangobin = maxvalue - minvalue;

%menores del minimo se ponen en el primer rango y mayores en el último
x = DATOENTRADA(1);
if(x <= minvalue)
    xn = 1;
else if(x >= maxvalue)
        xn = N;
    else
        xn = ceil(x/(rangobin/N));
    end;
end;

%menores del minimo se ponen en el primer rango y mayores en el último
y = DATOENTRADA(2);
if(y <= minvalue)
    yn = 1;
else if(y > maxvalue)
        yn = N;
    else
        yn = ceil(y/(rangobin/N));
    end;
end;

LABEL = hist(xn, yn);
end

