% Preprocesamiento de la imagen
clear;
close all;
clc;
% 1. Lectura de Imagen
Imagen_original = imread('35.jpg');
% 2. Extracción del canal verde
Green =Imagen_original(:,:,2); 
% 3. Ecualización adaptativa (CLAHE)
J = adapthisteq(Green, 'ClipLimit', 0.01); 
% 4. Filtrado de mediana
Filtro = medfilt2(J, [5 5]); 
I_green = Imagen_original;
% 5. Sustitución del canal verde
I_green(:,:,2) = Filtro; 
% 6. Ajuste de intensidad
I_green = imadjust(I_green, [0.05 0.05 0.05; 0.9 0.9 0.9], []);

% 7. Mostrar imágenes 
figure;
subplot(1,3,1); imshow(Imagen_original); title('Imagen Original');
subplot(1,3,2); imshow(Green); title('Imagen Extracción Canal Verde');
subplot(1,3,3); imshow(I_green); title('Imagen Mejorada');
