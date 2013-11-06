function LABEL = distancia_k(DATOENTRADA, DATOS, ETIQUETAS, INDICES, kvalue )
%DISTANCIA_K Summary of this function goes here
%   Detailed explanation goes here
%   Dado un dato de entrada, una kvalue dada y sea INDICES el cojnunto de
%   indices de la lista de datos que usaremos para etiquetar el dato de
%   entrada se devuelve la etiqueta de los kvalue vecinos mas cercanos

[r, c] = size(INDICES);

NUMTRAININGCLASES = r;
NUMDATOS = length(DATOS);
dist = ones(1, NUMDATOS)*bitmax;

for i = 1:NUMTRAININGCLASES
    DATOSCLASE = DATOS(ETIQUETAS==i,:);
    NUMDATOSCLASE = length(DATOSCLASE);
    NUMINDICESCLASE = length(INDICES(i,:));
    for j = 1:NUMINDICESCLASE
        dist((i-1)*NUMDATOSCLASE + INDICES(i,j)) = norm(DATOENTRADA - DATOSCLASE(INDICES(i,j),:));
    end;
end;
[m, n] = sort(dist);
NEIGHBOURS = n(1:kvalue);
[a,b]=hist(ETIQUETAS(NEIGHBOURS),unique(ETIQUETAS(NEIGHBOURS)));
histSort = sort(a,'descend');
if(1 < length(histSort) && histSort(1) == histSort(2))
    % En caso de empate nos quedamos con la etiqueta de menor distancia
    LABEL = ETIQUETAS(NEIGHBOURS(1));
else
    % Devolvemos la etiqueta de la clase con mayor cuenta
    [mMax, nMax] = max(a);
    LABEL = b(nMax);
end;

end

