
# Aplicación de Métodos de Dinámica No Lineal (Dimensión Fractal) Para Clasificar Imágenes de Retinopatía Diabética

Este repositorio contiene los algoritmos desarrollados en MATLAB para el procesamiento digital de imágenes de fondo de ojo de la retina humana con retinopatía diabética y la cuantificación de la complejidad geométrica de la arquitectura vascular, utilizando el método de conteo de cajas (Box-Counting) para el cálculo de la Dimensión Fractal ($D_f$).


## 8.2 Algoritmo de Preprocesamiento de la Imagen

En esta sección del proyecto, el algoritmo se encarga de limpiar y mejorar las imágenes de fondo de ojo de la retina humana con retinopatía diabética.
El algoritmo sigue una estructura lineal como se muestra en el diagrama de flujo de la Figura 1:

<figure align="center">
  <img width="347" height="850" alt="Diagrama de flujo del preprocesamiento" src="https://github.com/user-attachments/assets/1ba52560-da69-4f2b-95e3-83f058c5ba16" />
  <figcaption>
    <b>Figura 1.</b> Diagrama de flujo del algoritmo de preprocesamiento de imágenes de retina. Se detallan las etapas secuenciales implementadas en MATLAB para la mejora de contraste y reducción de ruido.
  </figcaption>
</figure>

### 8.2.1 Etapas del Algoritmo de Preprocesamiento
El preprocesamiento se diseñó para estandarizar las imágenes de la retina humana con retinopatía diabética y resaltar la morfología vascular. El flujo lógico, implementado en MATLAB, se divide en los siguientes pasos:

**1. Lectura de imagen(imread):** Se ingresa la imagen original de la retina humana con retinopatía diabética en formato RGB.

**2. Extracción del canal verde:** Se aisla el canal verde de la matriz RBG (Imagen_original(:,:,2)). Se seleccionó este canal debido a que presenta una menor absorción lumínica por parte de los pigmentos de la retina, ofreciendo así el mayor contraste natural entre los vasos sanguíneos y el fondo. El canal rojo suele estar demasiado brillante y el azul tiene mucho ruido.

**3. Ecualización adaptativa (CLAHE - adapthisteq):** Se aplica la técnica Ecualización adaptativa de histograma limitada por el contraste con un límite de contraste de 0.01. A diferencia de la ecualización global, resaltando detalles finos y capilares en áreas de baja iluminación sin saturar las zonas brillantes.

**4. Filtrado de mediana (medfilt2):** Se emplea un núcleo de  $5 \times 5$  píxeles para la reducción de ruido, es fundamental para eliminar artefactos manteniendo la integridad de los bordes de la arquitectura vascular.

**5. Sustitución del canal verde:** Se sustituye el canal verde original por el componente procesado y filtrado (I_green(:,:,2) = Filtro), integrándolo nuevamente en la estructura de la imagen para su ajuste final.

**6. Ajuste de intensidad (imadjust):** La función imadjust estira los niveles de brillo para que la imagen ocupe todo el rango visual posible, logrando que los puntos negros sean más profundos y los detalles más brillantes, facilitando la detección de bordes.

**7. Mostrar imágenes (imshow):** El algoritmo genera una comparativa que permite la validación cualitativa entre la imagen original, la extracción del canal verde y la imagen final mejorada.

## Algoritmo Para el Aislamiento de la Arquitectura Vascular y Cálculo de la Dimensión Fractal

Este algoritmo mide la complejidad de la arquitectura vascular de la retina. Primero, traza un mapa binario de los vasos sanguíneos (segmentación). Luego, coloca cuadrículas de diferentes tamaños sobre ese mapa y cuenta cuántos cuadros son tocados por los vasos. Al analizar cómo cambia este número conforme los cuadros se hacen más pequeños, el algoritmo calcula la Dimensión Fractal ($D_f$), un valor numérico que indica qué tan sana o congestionada está la red vascular del paciente. Se divide en dos etapas:

### 8.3.1 Aislamiento de la Arquitectura Vascular

**1. Generación de máscara de control interior:** Se aplicó un suavizado gaussiano (imgaussfilt) con $\sigma = 2$ para reducir variaciones locales de intensidad. Mediante el método de Otsu (graythresh), se generó una máscara binaria del disco retiniano, la cual fue refinada mediante el relleno de huecos (imfill) y una erosión morfológica (imerode) con un elemento estructurante de disco de radio 10. Esto asegura que el análisis se limite al área útil de la retina, eliminando bordes externos ruidosos.

**2. Segmentación híbrida de vasos:** Se implementó una operación lógica combinada entre el detector de bordes de Canny (edge) y una máscara de intensidad basada en un segundo umbral de Otsu. Esta intersección garantiza que solo se conserven estructuras que posean una discontinuidad de borde definida y un nivel de intensidad superior al fondo.

**3. Post-procesado morfológico:** La arquitectura extraída se sometió a una limpieza mediante bwareaopen, eliminando objetos menores a 100 píxeles considerados ruido. Finalmente, se aplicó un cierre morfológico (imclose) con un disco de radio 1 para conectar segmentos vasculares pequeños y suavizar las ramificaciones finales.

### 8.4.1 Cálculo de la Dimensión Fractal ($D_f$)

La cuantificación de la complejidad geométrica se realizó mediante el método de Box-Counting (Conteo de Cajas), siguiendo un proceso de análisis multiescalar.

**1. Acondicionamiento y relleno (Padding):** Para garantizar un conteo exacto, la imagen binaria se sometió a un proceso de relleno simétrico (padarray). Esto permitió que las dimensiones de la imagen fueran múltiplos exactos del número de cajas ($k$) por eje, evitando errores de truncamiento en los bordes de la cuadrícula.

**2. Conteo de cajas:** Se definieron 20 niveles de resolución diferentes, variando el número de cajas desde $k = 5$ hasta $k = 100$. El algoritmo recorrió sistemáticamente la cuadrícula para cada escala $l = 1/k$, contabilizando el número de cajas ocupadas $N(l)$ que contenían al menos un píxel perteneciente a la vasculatura.

**3. Ajuste por mínimos cuadrados:** A partir de los datos experimentales, se realizó un análisis de regresión lineal sobre el espacio logarítmico ($-\ln(l)$ vs $\ln(N(l))$). La pendiente de la recta de mejor ajuste representa la Dimensión Fractal ($D_f$).

**4. Validación Estadística:** La fiabilidad del cálculo se determinó mediante el coeficiente de correlación de Pearson ($r$). Un valor de $r$ cercano a la unidad confirma que la arquitectura vascular posee un comportamiento fractal consistente en el rango de escalas analizado.
