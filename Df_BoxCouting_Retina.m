% Calculo de la Dimensión Fractal de la Retina Humana (Método Box-Counting)
clear;
close all; 
clc;

imagen = imread('35_mejorada.png');

imagen_gris = im2gray(imagen); 
imagen_gris = im2double(imagen_gris); 

% Trazado de la arquitectura vascular
imagen_suavizada = imgaussfilt(imagen_gris, 2); % Suavizado gaussiano
umbral_disco = graythresh(imagen_suavizada); % Umbral de Otsu

mascara_disco = imagen_suavizada > umbral_disco; % Máscara binaria utilizando umbral
mascara_disco = imfill(mascara_disco,'holes'); % Rellena huecos
mascara_disco = bwareaopen(mascara_disco,5000); % Elimina ruido

se = strel('disk',10); % Elemento estructurante 
mascara_disco_interior = imerode(mascara_disco,se); % Erosión morfológica

% Segmentación de vasos sanguíneos
umbral_otsu = graythresh(imagen_gris); % Umbral automático de Otsu
mascara_intensidad = imagen_gris > umbral_otsu; % Máscara binaria usando umbral

bordes_canny = edge(imagen_gris,'Canny'); % Detección de bordes método Canny
vasos = bordes_canny & mascara_intensidad & mascara_disco_interior; % Detección de vasos sanguíneos

% Post-procesado morfológico
vasos = bwareaopen(vasos,100); % Elimina ruido pequeño
vasos = imclose(vasos,strel('disk',1));

figure;
subplot(1,3,1); imshow(imagen, []); title('Imagen Mejorada de la Retina');
subplot(1,3,2); imshow(imagen_gris, []); title('Imagen de la Retina en Escala de Grises');
subplot(1,3,3);imshow(vasos); title('Arquitectura Vascular de la Retina');


% Método Box-Counting
[filas, columnas] = size(vasos);
vasos = logical(vasos);
num_cajas = [5 10 15 20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 95 100]; % l = 1/k
num_escalas = length(num_cajas);

N = zeros(1,num_escalas); % N(l) -> Número de cajas ocupadas
l = zeros(1,num_escalas); % l -> Escala (longitud de caja) 

for i=1:num_escalas
    k = num_cajas(i); % Número de cajas por eje
    l(i) = 1/k; % Tamaño de la caja
    tam_caja = ceil(max(filas, columnas) / k); % Tamaño de caja en pixeles
    filas_pad = k * tam_caja;
    columnas_pad = k * tam_caja;
    pad_filas = filas_pad - filas; % Filas a rellenar
    pad_columnas = columnas_pad - columnas; % Columnas a rellenar
    pad_sup = floor(pad_filas/2);
    pad_inf = ceil(pad_filas/2);
    pad_izq = floor(pad_columnas/2);
    pad_der = ceil(pad_columnas/2);
    imagen_pad = padarray(vasos, [pad_sup pad_izq], 0, 'pre');
    imagen_pad = padarray(imagen_pad, [pad_inf pad_der], 0, 'post');
    % Conteo de cajas
    contador = 0;
    for r=1:k % Recorre filas de la cuadrícula
        for c=1:k % Recorre columnas de la cuadrícula
            r_ini = (r-1)*tam_caja + 1; % Fila inicial de la caja
            r_fin   = r*tam_caja; % Fila final de la caja
            c_ini = (c-1)*tam_caja + 1; % Columna inicial de la caja
            c_fin   = c*tam_caja; % Columna final de la caja
            bloque = imagen_pad(r_ini:r_fin, c_ini:c_fin);
            if any(bloque(:)) % Si hay un pixel vascular
                contador = contador + 1;
            end
        end
    end
    N(i) = contador; % Guarda el número total de cajas ocupadas
    % Visualizar cuadrículas
    figure;
    imshow(imagen_pad, []);
    hold on
    % Dibujar cuadrículas
    for r=0:k
        y = r * tam_caja + 0.5;
        line([1 columnas_pad],[y y],'Color','y','LineWidth',0.5);
    end
    for c=0:k
        x = c * tam_caja + 0.5;
        line([x x],[1 filas_pad],'Color','y','LineWidth',0.5);
    end

    title(['l = 1/',num2str(k),', N(l) = ',num2str(contador)])
end

% Tabla de resultados (ajuste log-log)
x = -log(l);
y = log(N);

l_frac = strings(num_escalas,1);
for i = 1:num_escalas
    l_frac(i) = "1/" + num2str(num_cajas(i));
end

fprintf('\nTabla de conteo de cajas (Box-Counting)\n');
fprintf('%6s %8s %10s %12s\n','l','N(l)','-ln(l)','ln(N(l))');
fprintf('---------------------------------------------\n');

for i = 1:num_escalas
    fprintf('%6s %8d %10.4f %12.4f\n', ...
        l_frac{i}, N(i), x(i), y(i));
end
fprintf('---------------------------------------------\n\n');
% Ajuste por mínimos cuadrados
n = num_escalas;
X = x;
Y = y;

q  = sum(X .* Y);
q1 = sum(X) * sum(Y);
z  = sum(X.^2);
z1 = (sum(X))^2;

a1 = (n*q - q1) / (n*z - z1); % Pendiente (Dimensión Fractal)
a0 = mean(Y) - a1 * mean(X);  % Intercepto

Y_RL = a0 + a1 * X; % Recta de mejor ajuste

% Gráfica
figure;
plot(X, Y, 'bo','MarkerFaceColor','b')
hold on
plot(X, Y_RL, 'r','LineWidth',1.5)
grid on
xlabel('-ln(l)')
ylabel('ln(N(l))')
title('Recta de mejor ajuste – Método Box-Counting (Retina)')
legend('Datos experimentales','Recta ajustada','Location','NorthWest')

% Coeficiente de correlación
r = (n*sum(X.*Y) - sum(X)*sum(Y)) / ...
    (sqrt(n*sum(X.^2) - (sum(X))^2) * ...
     sqrt(n*sum(Y.^2) - (sum(Y))^2));

% Resultados 
disp(['Dimensión fractal Df = ', num2str(a1)])
disp(['Intercepto a0 = ', num2str(a0)])
disp(['Coeficiente de correlación r = ', num2str(r)])

