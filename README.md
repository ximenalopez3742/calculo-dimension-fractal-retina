
# Aplicación de Métodos de Dinámica No Lineal (Dimensión Fractal) Para Clasificar Imágenes de Retinopatía Diabética

Este repositorio contiene los algoritmos desarrollados en MATLAB para el procesamiento digital de imágenes de fondo de ojo de la retina humana con retinopatía diabética y la cuantificación de la complejidad geométrica de la arquitectura vascular, utilizando el método de conteo de cajas (Box-Counting) para el cálculo de la dimensión fractal ($D_f$).


## 8.2 Algoritmo de Preprocesamiento de la Imagen

En esta sección del proyecto, el algoritmo se encarga de limpiar y mejorar las imágenes de fondo de ojo de la retina humana con retinopatía diabética.
El algoritmo sigue una estructura lineal como se muestra en el diagrama de flujo de la siguiente figura:

<img width="347" height="850" alt="Preprocesamiento de la imagen" src="https://github.com/user-attachments/assets/1ba52560-da69-4f2b-95e3-83f058c5ba16" />

### 8.2.1 Etapas del Algoritmo de Preprocesamiento
El preprocesamiento se diseñó para estandarizar las imágenes de la retina humana con retinopatía diabética y resaltar la morfología vascular. El flujo lógico, implementado en MATLAB, se divide en los siguientes pasos:

**1. Lectura de imagen(imread):** Se ingresa la imagen original de la retina humana con retinopatía diabética en formato RGB.

**2. Extracción del canal verde:** Se aisla el canal verde de la matriz RBG (Imagen_original(:,:,2)). Se seleccionó este canal debido a que presenta una menor absorción lumínica por parte de los pigmentos de la retina, ofreciendo así el mayor contraste natural entre los vasos sanguíneos y el fondo. El canal rojo suele estar demasiado brillante y el azul tiene mucho ruido.

**3. Ecualización adaptativa (CLAHE - adapthisteq):** Se aplica la técnica Ecualización adaptativa de histograma limitada por el contraste con un límite de contraste de 0.01. A diferencia de la ecualización global, resaltando detalles finos y capilares en áreas de baja iluminación sin saturar las zonas brillantes.

**4. Filtrado de mediana (medfilt2):** Se emplea un núcleo de $5 \times 5$ píxeles para la reducción de ruido, es fundamental para eliminar artefactos manteniendo la integridad de los bordes de la arquitectura vascular.

**5. Sustitución del canal verde:** Se sustituye el canal verde original por el componente procesado y filtrado (I_green(:,:,2) = Filtro), integrándolo nuevamente en la estructura de la imagen para su ajuste final.

**6. Ajuste de intensidad (imadjust):** La función imadjust estira los niveles de brillo para que la imagen ocupe todo el rango visual posible, logrando que los puntos negros sean más profundos y los detalles más brillantes, facilitando la detección de bordes.

**Mostrar imágenes (imshow):** El algoritmo genera una comparativa que permite la validación cualitativa entre la imagen original, la extracción del canal verde y la imagen final mejorada.

## Algoritmo Para el Aislamiento de la Arquitectura Vascular y Cálculo de la Dimensión Fractal

Este algoritmo mide la complejidad de la arquitectura vascular de la retina. Primero, 'dibuja' un mapa binario de los vasos sanguíneos (segmentación). Luego, coloca cuadrículas de diferentes tamaños sobre ese mapa y cuenta cuántos cuadros son tocados por los vasos. Al analizar cómo cambia este número conforme los cuadros se hacen más pequeños, el programa calcula la Dimensión Fractal, un valor numérico que indica qué tan sana o congestionada está la red vascular del paciente.
