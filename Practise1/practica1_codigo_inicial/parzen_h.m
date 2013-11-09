function [LABEL, fnh] = parzen_h(DATOENTRADA, DATOS, ETIQUETAS, INDICES, hvalue)
%PARZEN_H Summary of this function goes here
%   Detailed explanation goes here

%   Dado un dato de entrada, una hvalue dada y sea INDICES el cojnunto de
%   indices de la lista de datos que usaremos para etiquetar el dato de
%   entrada se devuelve la etiqueta que mejor clasifica al dato dada la
%   construcción de las ventana de Parzen con longitud hvalue
[r, c] = size(INDICES);

NUMTRAININGCLASES = r;
%f = zeros(1,NUMTRAININGCLASES);
%dist = ones(1,NUMTRAININGCLASES)*bitmax;
fn = zeros(1,NUMTRAININGCLASES);

for i = 1:NUMTRAININGCLASES
    DATOSCLASE = DATOS(ETIQUETAS==i,:);
    NUMINDICESCLASE = length(INDICES(i,:));
    
    COV = cov(DATOSCLASE);
    
    for j = 1:NUMINDICESCLASE
        %         Primera aproximación
        %         u = norm(DATOENTRADA - DATOSCLASE(INDICES(i,j),:))/hvalue;
        %         if(abs(u)<=1/2)
        %             f(i) = f(i)+1;
        %             dist(i) = dist(i)+ (u*hvalue);
        %         end;
        %Aproximación con una gausiana normal
        fn(i) = fn(i) + mvnpdf(DATOENTRADA/hvalue,DATOSCLASE(INDICES(i,j),:)/hvalue,COV);
    end;
end;
%[m, n] = sort(f,'descend');
[m, n] = sort(fn,'descend');

% Devolvemos la etiqueta de la clase con mayor cuenta
LABEL = n(1);
% Devolvemos tambien el valor de la funcion de probabilidad en ese punto
[ndatos,d] = size(DATOSCLASE);
fnh = 1/(ndatos*(hvalue^d))*m(1);
%fnh = m(1);
end

