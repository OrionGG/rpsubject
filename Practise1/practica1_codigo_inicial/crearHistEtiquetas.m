function hist = crearHistEtiquetas( DATOS,  ETIQUETAS, trainIndexes, N, aprioris, HISTSIZE)
%CREARHISTETIQUETAS Summary of this function goes here
%   Detailed explanation goes here

%Crear histograma de los datos de entrenamiento
histClase(:,:,3) = zeros(N,N);%histogramas por clase
minvalue = HISTSIZE.minvalue;
maxvalue = HISTSIZE.maxvalue;
rangobin = maxvalue - minvalue;


YY         = unique(ETIQUETAS);
NUM_CLASES = length(YY);

for i=1:NUM_CLASES
    DATOSCLASE = DATOS(ETIQUETAS==i,:);
    
    for ixTrainDataClass = 1: length(trainIndexes)
        DATOENTRADA = DATOSCLASE(trainIndexes(i, ixTrainDataClass),:);
        
        x = DATOENTRADA(1);
        %menores del minimo se ponen en el primer rango y mayores en el �ltimo
        if(x <= minvalue)
            xn = 1;
        else if(x > maxvalue)
                xn = N;
            else
                xn = ceil(x/(rangobin/N));
            end;
        end;
        
        %menores del minimo se ponen en el primer rango y mayores en el �ltimo
        y = DATOENTRADA(2);
        if(y <= minvalue)
            yn = 1;
        else if(y > maxvalue)
                yn = N;
            else
                yn = ceil(y/(rangobin/N));
            end;
        end;
        
        histClase(xn,yn,i)=histClase(xn,yn,i)+1;
    end;
    
    DATOSCLASE = zeros(size(DATOSCLASE,1),size(DATOSCLASE,2));
end;
hist=zeros(N,N);%histograma de etiquetas usando los apriori
histTie = [];
for ii=1:size(hist,1)
    for jj = 1:size(hist,2)
        histValues = zeros(1,size(histClase,3));
         for ixClase = 1:size(histClase,3)
             histValues(ixClase) = histClase(ii,jj,ixClase)*aprioris(ixClase);
         end;
        
        [histValues, histEtiquetas] = sort(histValues, 'descend');
        if(histValues(1) == histValues(2))
            histTie = [histTie; ii , jj];
            hist(ii,jj) = 0;
        else            
            hist(ii,jj) = histEtiquetas(1);
        end;
    end;
end;

histCopy = hist;
%caso de que la probabilidad sea la misma para 2 o m�s clases
for iii = 1:size(histTie, 1)
    cellsTie = histTie(iii,:);
    %el tama�o de ventana de buscar los vecinos se va ajustando para
    %encontrar uan etiqueta mayoritaria
    windowsSize = 3;
    maxClassFound = 0;
    while (windowsSize <= min(size(histCopy,1), size(histCopy,1)) && maxClassFound == 0)

        %se mira en las celdas vecinas
        iStart = cellsTie(1) - floor(windowsSize/2);
        if(iStart < 1) iStart=1; end;
        iEnd = cellsTie(1) + floor(windowsSize/2);
        if(iEnd >  size(histCopy,1)) iEnd=size(histCopy,1); end;
        jStart = cellsTie(2) - floor(windowsSize/2);
        if(jStart < 1) jStart=1;  end;
        jEnd = cellsTie(2) + floor(windowsSize/2);
        if(jEnd > size(histCopy,2)) jEnd = size(histCopy,2);  end;

        histCount = zeros(1, size(histClase,3));
        for iiii = iStart:iEnd
            for jjjj = jStart:jEnd
                if(histCopy(iiii,jjjj) ~= 0)
                    histCount(histCopy(iiii,jjjj)) = histCount(histCopy(iiii,jjjj))+1;
                end;
            end;
        end;

        [hCMax, hCMaxIdx] = sort(histCount, 'descend');
        if(hCMax(1) ~= hCMax(2))
            hist(cellsTie(1),cellsTie(2)) = hCMaxIdx(1);
            maxClassFound = 1;
        end;
        
        windowsSize = windowsSize+1;
    end;
    
    %si no se encuentra ninguna etiqueta mayoritaria se asigna una
    %cualquiera
    if(hist(cellsTie(1),cellsTie(2)) == 0)
        hist(cellsTie(1),cellsTie(2)) = hCMaxIdx(1);
    end;
    
end;
end

