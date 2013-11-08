function LABEL = parzen_h(DATOENTRADA, DATOS, ETIQUETAS, INDICES, hvalue)
%PARZEN_H Summary of this function goes here
%   Detailed explanation goes here

%   Dado un dato de entrada, una hvalue dada y sea INDICES el cojnunto de
%   indices de la lista de datos que usaremos para etiquetar el dato de
%   entrada se devuelve la etiqueta que mejor clasifica al dato dada la
%   construcción de las ventana de Parzen con longitud hvalue
[r, c] = size(INDICES);

NUMTRAININGCLASES = r;
f = zeros(NUMTRAININGCLASES);

for i = 1:NUMTRAININGCLASES
    DATOSCLASE = DATOS(ETIQUETAS==i,:);
    NUMINDICESCLASE = length(INDICES(i,:));

    for j = 1:NUMINDICESCLASE
        u = (DATOENTRADA - DATOSCLASE(INDICES(i,j),:))/hvalue;
        if(abs(u)<=1/2)
            f(i) = f(i)+1;
        end;
    end;
end;
[m, n] = sort(f);
LABEL = n;

end

