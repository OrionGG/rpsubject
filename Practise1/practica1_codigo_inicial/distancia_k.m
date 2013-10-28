function LABEL = distancia_k(DATOENTRADA, DATOS, ETIQUETAS, INDICES, kvalue )
%DISTANCIA_K Summary of this function goes here
%   Detailed explanation goes here

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
% Devolvemos la etiqueta de la clase con mayor cuenta
[mMax, nMax] = max(a);
LABEL = b(nMax);

end

