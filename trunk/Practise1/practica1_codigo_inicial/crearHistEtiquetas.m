function hist = crearHistEtiquetas( DATOS,  ETIQUETAS, trainIndexes)
%CREARHISTETIQUETAS Summary of this function goes here
%   Detailed explanation goes here

%Crear histograma de los datos de entrenamiento
histClase(:,:,3) = zeros(N,N);%histogramas por clase
minvalue = 1;
maxvalue = N;
for i=1:NUM_CLASES
    DATOSCLASE = DATOS(ETIQUETAS==i,:);
    DATOSPORCLASE = length(DATOSCLASE);
    for ixTrainDataClass = 1: length(trainIndexes)
        DATO = DATOSCLASE(trainIndexes(i, ixTrainDataClass),:);
        xn = floor(DATO(1)/(DATOSPORCLASE/N))+1;
        if(xn < minvalue)
            xn = 1;
        else if(xn > maxvalue)
                xn = maxvalue;
            end;end;
        
        yn = floor(DATO(2)/(DATOSPORCLASE/N))+1;
        if(yn < minvalue)
            yn = 1;
        else if(yn > maxvalue)
                yn = maxvalue;
            end;end;
        
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

