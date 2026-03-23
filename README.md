
# Aplicación de Métodos de Dinámica No Lineal (Dimensión Fractal) Para Clasificar Imágenes de Retinopatía Diabética

Este repositorio contiene los algoritmos desarrollados en MATLAB para el procesamiento digital de imágenes de fondo de ojo y la cuantificación de la complejidad geométrica de la arquitectura vascular, utilizando el método de conteo de cajas (Box-Counting) para el cálculo de la dimensión fractal.


## Algoritmo de Preprocesamiento de la Imagen

En esta sección del proyecto, el algoritmo se encarga de limpiar y mejorar las imágenes de fondo de ojo (retina).
El proceso sigue una estructura lineal como se muestra en el diagrama de flujo de la siguiente figura:

<img width="325" height="797" alt="image" src="https://github.com/user-attachments/assets/10c24231-e348-4ce2-9d94-f6c4aa9dd94c" />

Para lograr la imagen final mejorada, el algoritmo realiza las siguientes tareas:
1. Lee la imagen de la retina humana. La imagen entra al programa como una matriz de datos en formato RGB (Rojo, Verde y Azul).
2. Extracción del canal verde, ya que ofrece el contraste más alto para ver los vasos sanguíneos y las lesiones (como microaneurismas), que aparecen oscuras sobre el fondo más claro de la retina. El canal rojo suele estar demasiado brillante y el azul tiene mucho ruido.
3. Aplicar CLAHE. Es una técnica de Ecualización Adaptativa de Histograma. A diferencia de una ecualización normal que brilla toda la foto por igual, el CLAHE divide la imagen en pequeñas secciones y ajusta el contraste en cada una. Esto permite resaltar detalles en áreas que originalmente estaban muy oscuras sin "quemar" las zonas que ya estaban claras.
4. Filtro de mediana. Se aplica un filtro espacial de 5 x 5 píxeles para limpiar la imagen. Su objetivo es eliminar el "ruido" (puntos blancos o negros aleatorios) causado por el sensor de la cámara. Lo elegimos porque es excelente eliminando impurezas sin desenfocar los bordes de las venas y arterias, manteniendo la nitidez necesaria para el diagnóstico.
5. Sustituir canal verde. Tomamos la imagen original y reemplazamos su canal verde viejo por el canal que ya limpiamos y mejoramos.
## Algoritmo Para el Aislamiento de la Arquitectura Vascular y Cálculo de la Dimensión Fractal
 
