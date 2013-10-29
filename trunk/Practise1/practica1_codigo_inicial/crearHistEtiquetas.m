function hist = crearHistEtiquetas( DATOS,  ETIQUETAS, trainIndexes, N, aprioris)
%CREARHISTETIQUETAS Summary of this function goes here
%   Detailed explanation goes here

%Crear histograma de los datos de entrenamiento
histClase(:,:,3) = zeros(N,N);%histogramas por clase
minvalue = 0;
maxvalue = 49;%CAMBIAR----
rangobin = maxvalue - minvalue;


YY         = unique(ETIQUETAS);
NUM_CLASES = length(YY);

for i=1:NUM_CLASES
    DATOSCLASE = DATOS(ETIQUETAS==i,:);
    
    for ixTrainDataClass = 1: length(trainIndexes)
        DATOENTRADA = DATOSCLASE(trainIndexes(i, ixTrainDataClass),:);
        
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
        
        histClase(xn,yn,i)=histClase(xn,yn,i)+1;
    end;
    
    DATOSCLASE = zeros(size(DATOSCLASE,1),size(DATOSCLASE,2));
end;
hist=zeros(N,N);%histograma de etiquetas usando los apriori
for ii=1:size(hist,1)
    for jj = 1:size(hist,2)
        maxEtiqueta = 0;
        maxValue = -1;
        for ixClase = 1:size(histClase,3)
            if(maxValue < (histClase(ii,jj,ixClase)*aprioris(ixClase)))
                maxEtiqueta = ixClase;
                maxValue = histClase(ii,jj,ixClase)*aprioris(ixClase);
            end;
        end;
        hist(ii,jj) = maxEtiqueta;
    end;
end;
end

