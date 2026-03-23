
# Aplicación de Métodos de Dinámica No Lineal (Dimensión Fractal) Para Clasificar Imágenes de Retinopatía Diabética

Este repositorio contiene los algoritmos desarrollados en MATLAB para el procesamiento digital de imágenes de fondo de ojo y la cuantificación de la complejidad geométrica de la arquitectura vascular, utilizando el método de conteo de cajas (Box-Counting) para el cálculo de la dimensión fractal.


## Algoritmo de Preprocesamiento de la Imagen

En esta sección del proyecto, el algoritmo se encarga de limpiar y mejorar las imágenes de fondo de ojo (retina).
El proceso sigue una estructura lineal como se muestra en el diagrama de flujo de la siguiente figura:

<img width="347" height="850" alt="Preprocesamiento de la imagen" src="https://github.com/user-attachments/assets/1ba52560-da69-4f2b-95e3-83f058c5ba16" />

Para lograr la imagen final mejorada, el algoritmo realiza las siguientes tareas:
1. Lee la imagen de la retina humana. La imagen entra al programa como una matriz de datos en formato RGB (Rojo, Verde y Azul).
2. Extracción del canal verde, ya que ofrece el contraste más alto para ver los vasos sanguíneos y las lesiones (como microaneurismas), que aparecen oscuras sobre el fondo más claro de la retina. El canal rojo suele estar demasiado brillante y el azul tiene mucho ruido.
3. Aplicar CLAHE. Es una técnica de Ecualización Adaptativa de Histograma. A diferencia de una ecualización normal que brilla toda la foto por igual, el CLAHE divide la imagen en pequeñas secciones y ajusta el contraste en cada una. Esto permite resaltar detalles en áreas que originalmente estaban muy oscuras sin "quemar" las zonas que ya estaban claras.
4. Filtro de mediana. Se aplica un filtro espacial de 5 x 5 píxeles para limpiar la imagen. Su objetivo es eliminar el "ruido" (puntos blancos o negros aleatorios) causado por el sensor de la cámara. Lo elegimos porque es excelente eliminando impurezas sin desenfocar los bordes de las venas y arterias, manteniendo la nitidez necesaria para el diagnóstico.
5. Sustituir canal verde. Tomamos la imagen original y reemplazamos su canal verde viejo por el canal que ya limpiamos y mejoramos.
6. Ajuste de intensidad. La función imadjust estira los niveles de brillo para que la imagen ocupe todo el rango visual posible, logrando que los puntos negros sean más profundos y los detalles más brillantes.
7.Mostrar imágenes. Es la salida visual del programa. Presenta tres vistas comparativas: la original, el canal verde crudo y la imagen final procesada. Esto permite al usuario validar que el proceso de mejora fue exitoso y que las lesiones son ahora más fáciles de identificar.
## Algoritmo Para el Aislamiento de la Arquitectura Vascular y Cálculo de la Dimensión Fractal
 
Este algoritmo mide la complejidad de la arquitectura vascular de la retina. Primero, 'dibuja' un mapa binario de los vasos sanguíneos (segmentación). Luego, coloca cuadrículas de diferentes tamaños sobre ese mapa y cuenta cuántos cuadros son tocados por los vasos. Al analizar cómo cambia este número conforme los cuadros se hacen más pequeños, el programa calcula la Dimensión Fractal, un valor numérico que indica qué tan sana o congestionada está la red vascular del paciente.
