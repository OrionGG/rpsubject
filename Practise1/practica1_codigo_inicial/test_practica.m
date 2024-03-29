
function test_practica()

D = 50;

% Cambiar este valor a 1 o 2 dependiendo del conjunto de gaussianas a usar
CONJUNTO_GAUSSIANAS = 1;

% Cuando generamos los datos de las gaussianas añadimos un ruido
% de medida gaussiano de media cero y matriz de cov. diagonal
% Estos dos valores son la desviación típica en la diagonal.
% STD_RUIDO             = [2; 3];

NUM_DATOS_ENTRENA_POR_CLASE   = [50, 200, 1000];
NUM_DATOS_TEST_POR_CLASE      = 100;
VALORES_H_EN_PARZEN           = [0.5, 1, 2];
%VALORES_K_EN_KNN              = [1, 5, 11, 21, 31];
VALORES_K_EN_KNN              = [1, 3, 5, 7, 11, 13, 17, 19, 21, 23, 29, 31];
%DIVISIONES_HISTOGRAMA         = [3, 5, 10, 20, 30];
DIVISIONES_HISTOGRAMA         = 3:30;
HISTSIZE.minvalue             = 0;
HISTSIZE.maxvalue             = D;

%--------------------------------------------------------------------------
% Establecer las distribuciones gaussianas
%--------------------------------------------------------------------------
[GAUSSIANAS_REALES, COLORES_CLASES] = generar_gaussianas_reales(CONJUNTO_GAUSSIANAS, D);

figure;
subplot(1,2,1);
dibujar_densidad_prob_gaussianas(D, COLORES_CLASES, GAUSSIANAS_REALES);

subplot(1,2,2);
h = gca;
set(h, 'FontSize', 20);
dibujar_clasificacion(D, COLORES_CLASES, GAUSSIANAS_REALES, @clasificar_gaussianas, 'Clasificador ideal');

%--------------------------------------------------------------------------
% Generar datos muestreados de las gaussianas (de cada clase).
% Usaremos diferente número de muestras.
%--------------------------------------------------------------------------
DATOS_ENTRENA     = cell(1, length(GAUSSIANAS_REALES));
ETIQUETAS_ENTRENA = cell(1, length(GAUSSIANAS_REALES));
DATOS_TEST        = cell(1, length(GAUSSIANAS_REALES));
ETIQUETAS_TEST    = cell(1, length(GAUSSIANAS_REALES));
for i=1:length(NUM_DATOS_ENTRENA_POR_CLASE)
    [DATOS_ENTRENA{i}, ETIQUETAS_ENTRENA{i}] = generar_muestra_gaussiana(NUM_DATOS_ENTRENA_POR_CLASE(i), ...
        GAUSSIANAS_REALES); %, STD_RUIDO);
    [DATOS_TEST{i}, ETIQUETAS_TEST{i}] = generar_muestra_gaussiana(NUM_DATOS_TEST_POR_CLASE, ...
        GAUSSIANAS_REALES); %, STD_RUIDO);
end


for i=1:length(NUM_DATOS_ENTRENA_POR_CLASE)
    % preparar una nueva figura
    nfigure = figure;
    h = gca;
    set(h, 'FontSize', 20);
    
    % Dibujar fronteras de indecisión del clasificador de min error
    % (usando el modelo de Gaussianas real)
    figure(nfigure);
    subplot(2, 3, 1);
    ETIQUETAS_REALES = dibujar_clasificacion(D, COLORES_CLASES, GAUSSIANAS_REALES, @clasificar_gaussianas, 'Clasificador ideal');
    
    %------------------------------------------------------------------------
    % Pruebas con K-NN
    %------------------------------------------------------------------------
    tic
    CLASIFICADOR_KNN = entrenar_clasificador_knn(DATOS_ENTRENA{i}, ETIQUETAS_ENTRENA{i}, VALORES_K_EN_KNN);
    figure(nfigure);
    subplot(2, 3, 4);
    ETIQUETAS_KNN = dibujar_clasificacion(D, COLORES_CLASES, CLASIFICADOR_KNN, @clasificar_knn, sprintf('K-NN - %d datos - K = %d', NUM_DATOS_ENTRENA_POR_CLASE(i), CLASIFICADOR_KNN.KOPTIMA));
    [Error_KNN, MatrizConfusion_KNN] = crearMatrizConfusion(ETIQUETAS_REALES, ETIQUETAS_KNN);
    toc
    Error_KNN
    MatrizConfusion_KNN
    sprintf('K-NN - %d datos - K = %d', NUM_DATOS_ENTRENA_POR_CLASE(i), CLASIFICADOR_KNN.KOPTIMA)
    %
    %   %------------------------------------------------------------------------
    %   % Pruebas con histogramas 2-D
    %   %------------------------------------------------------------------------
    tic
    CLASIFICADOR_HIST = entrenar_clasificador_hist2D(DATOS_ENTRENA{i}, ETIQUETAS_ENTRENA{i}, DIVISIONES_HISTOGRAMA, HISTSIZE);
    figure(nfigure);
    subplot(2, 3, 5);
    ETIQUETAS_HIST = dibujar_clasificacion(D, COLORES_CLASES, CLASIFICADOR_HIST, @clasificar_hist2D, sprintf('Hist - %d datos - N = %d', NUM_DATOS_ENTRENA_POR_CLASE(i), CLASIFICADOR_HIST.NOPTIMA));
    [Error_HIST, MatrizConfusion_HIST] = crearMatrizConfusion(ETIQUETAS_REALES, ETIQUETAS_HIST);
    toc
    Error_HIST
    MatrizConfusion_HIST
    sprintf('Hist - %d datos - N = %d', NUM_DATOS_ENTRENA_POR_CLASE(i), CLASIFICADOR_HIST.NOPTIMA)
    
    
    %------------------------------------------------------------------------
    % Pruebas con Gaussianas cov completa.
    %------------------------------------------------------------------------
    tic
    CLASIFICADOR_GAUSS = entrenar_clasificador_gaussianas(DATOS_ENTRENA{i}, ETIQUETAS_ENTRENA{i}, 1);
    figure(nfigure);
    subplot(2, 3, 6);
    ETIQUETAS_GAUSS = dibujar_clasificacion(D, COLORES_CLASES, CLASIFICADOR_GAUSS, @clasificar_gaussianas, sprintf('Gauss - %d datos', NUM_DATOS_ENTRENA_POR_CLASE(i)));
    [Error_GAUSS, MatrizConfusion_GAUSS] = crearMatrizConfusion(ETIQUETAS_REALES, ETIQUETAS_GAUSS);
    toc
    Error_GAUSS
    MatrizConfusion_GAUSS
     %------------------------------------------------------------------------
    % Pruebas con Parzen
    %------------------------------------------------------------------------
    tic
    CLASIFICADOR_PARZEN = entrenar_clasificador_Parzen(DATOS_ENTRENA{i}, ETIQUETAS_ENTRENA{i}, VALORES_H_EN_PARZEN);
    figure(nfigure);
    subplot(2, 3, 2);
    ETIQUETAS_PARZEN = dibujar_clasificacion(D, COLORES_CLASES, CLASIFICADOR_PARZEN, @clasificar_Parzen, sprintf('PARZEN - %d datos - H = %0.3g', NUM_DATOS_ENTRENA_POR_CLASE(i), CLASIFICADOR_PARZEN.HOPTIMA));
    [Error_PARZEN, MatrizConfusion_PARZEN] = crearMatrizConfusion(ETIQUETAS_REALES, ETIQUETAS_PARZEN);
    toc
    Error_PARZEN
    MatrizConfusion_PARZEN
end;