function hist = crearHistEtiquetas( DATOS,  ETIQUETAS, trainIndexes, N, aprioris, HISTSIZE)
%CREARHISTETIQUETAS Summary of this function goes here
%   Detailed explanation goes here

%Crear histograma de los datos de entrenamiento
YY         = unique(ETIQUETAS);
NUM_CLASES = length(YY);
featuresNumber = size(DATOS,2);

NArray = [];
for k = 1:featuresNumber
    NArray = [NArray, N];
end;
NNUM_CLASESArray = [NArray, NUM_CLASES];

histClase = zeros(NNUM_CLASESArray);

minvalue = HISTSIZE.minvalue;
maxvalue = HISTSIZE.maxvalue;
rangobin = maxvalue - minvalue;



for i=1:NUM_CLASES
    DATOSCLASE = DATOS(ETIQUETAS==i,:);
    
    for ixTrainDataClass = 1: length(trainIndexes{i})
        DATOENTRADA = DATOSCLASE(trainIndexes{i}(ixTrainDataClass),:);
        
        xn = zeros(1, length(DATOENTRADA));
        xni = 0;
        for j = 1:length(DATOENTRADA)
            xi = DATOENTRADA(j);
            %menores del minimo se ponen en el primer rango y mayores en el último
            if(xi <= minvalue)
                xn(j) = 1;
            else if(xi > maxvalue)
                    xn(j) = N;
                else
                    xn(j) = ceil(xi/(rangobin/N));
                end;
            end;
            xni = xni + xn * (length(DATOENTRADA)^(j-1));
        end;   
        histClase(xni)=histClase(xni)+1;
    end;
    
    DATOSCLASE = zeros(size(DATOSCLASE,1),size(DATOSCLASE,2));
end;
hist=zeros(NArray);%histograma de etiquetas usando los apriori
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
%caso de que la probabilidad sea la misma para 2 o más clases
for iii = 1:size(histTie, 1)
    cellsTie = histTie(iii,:);
    %el tamaño de ventana de buscar los vecinos se va ajustando para
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

