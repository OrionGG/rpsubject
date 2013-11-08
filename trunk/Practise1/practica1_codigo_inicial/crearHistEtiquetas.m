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
        %menores del minimo se ponen en el primer rango y mayores en el último
        if(x <= minvalue)
            xn = 1;
        else if(x > maxvalue)
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
        
        histClase(xn,yn,i)=histClase(xn,yn,i)+1;
    end;
    
    DATOSCLASE = zeros(size(DATOSCLASE,1),size(DATOSCLASE,2));
end;
hist=zeros(N,N);%histograma de etiquetas usando los apriori
histZeros = [];
for ii=1:size(hist,1)
    for jj = 1:size(hist,2)
        maxEtiqueta = randperm(3,1);    %maxEtiqueta = 0;
        maxValue = 0;                   %maxValue = -1;
        for ixClase = 1:size(histClase,3)
            if(maxValue < (histClase(ii,jj,ixClase)*aprioris(ixClase)))
                maxEtiqueta = ixClase;
                maxValue = histClase(ii,jj,ixClase)*aprioris(ixClase);
            end;
        end;
        if(maxValue == 0)
            histZeros = [histZeros; ii , jj];
            hist(ii,jj) = 0;
        else            
            hist(ii,jj) = maxEtiqueta;
        end;
    end;
end;
for iii = 1:size(histZeros, 1)
    cellsZero = histZeros(iii,:);
    
    windowsSize = 3;
    iStart = floor(cellsZero(1) - windowsSize/2);
    if(iStart < 1) iStart=1; end;
    iEnd = floor(cellsZero(1) + windowsSize/2);
    if(iEnd >  size(hist,1)) iEnd=size(hist,1); end;
    jStart = floor(cellsZero(2) - windowsSize/2);
    if(jStart < 1) jStart=1;  end;
    jEnd = floor(cellsZero(2) + windowsSize/2);
    if(jEnd > size(hist,2)) jEnd = size(hist,2);  end;
    
    histCount = zeros(1, size(histClase,3));
    for iiii = iStart:iEnd
        for jjjj = jStart:jEnd
            if(hist(iiii,jjjj) ~= 0)
                histCount(hist(iiii,jjjj)) = histCount(hist(iiii,jjjj))+1;
            end;
        end;
    end;
    
    [hCMax, hCMaxIdx] = max(histCount);
    if(hCMax)
        hist(cellsZero(1),cellsZero(2)) = hCMaxIdx;
    end;
end;
end

