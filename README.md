# Laboratorio 1 - Monitoreo del Patrón y Frecuencia Respiratoria

## Objetivos

### Objetivo General
Evaluar los cambios que se presentan en el patrón respiratorio cuando se esta hablando y cuando se esta en reposo.

### Objetivos Específicos
Reconocer las variables físicas principalmente involucradas en el proceso respiratorio.
Desarrollar un sistema que extraiga el patrón respiratorio y la frecuencia respiratoria.
Identificar tareas de verbalización a partir del patrón o la frecuencia respiratoria.

## Metodología
Para la parte fisica se utilizó una mascara inhaladora para poder contener con mayor facilidad el co2 generado por el sujeto de prueba, ya que al dejar el sensor expuesto en el ambiente podria modificar la toma de los datos. Además de esto se puso en un ponto fijo para evitar aun mas el ruido por parte de la manipulación del sensor, posterior a este paso se conecta el sensor a nuestra placa con base a los pines y requeridos para prosesar las señales respiratorias.

Se llevó a cabo una revisión bibliográfica sobre el proceso respiratorio y las variables físicas asociadas a su medición, con el fin de seleccionar el sensor más adecuado. Se seleccionó un sensor de gas de la serie MQ en este caso MQ 135, cuyo principio de funcionamiento se basa en la variación de la resistencia de un elemento sensible ante cambios en la concentración de gases del aire. Se aprovechó este principio para detectar de forma indirecta el patrón respiratorio, a partir de las variaciones en la concentración de dióxido de carbono (CO2) presente en el aire exhalado por el sujeto de prueba.
El sensor se alimentó con un voltaje de 5 VDC, conectándose su pin VCC a la salida de 5V del Arduino y su pin GND a tierra. La salida analógica del sensor (pin AO) se conectó al pin analógico A0 del Arduino, utilizado posteriormente para la digitalización de la señal mediante el conversor análogo-digital (ADC) integrado de 10 bits (resolución 0-1023) de la placa.

Se programó la placa Arduino UNO para realizar lecturas periódicas del pin A0 cada 20 ms (frecuencia de muestreo aproximada de 50 Hz), enviando cada valor leído a través del puerto serial a una tasa de 9600 baudios. Previo a la toma de datos  se dejó estabilizar térmicamente el sensor durante un período de calentamiento (warm-up) de aproximadamente 2 a 3 minutos, tiempo necesario para que el elemento sensible alcanzara una lectura base estable, según lo recomendado para sensores de esta familia.
Una vez estabilizada la señal, se ubicó el sensor a una distancia de entre 1 y 2centímetros de la nariz y boca del sujeto de prueba  con el fin de captar las variaciones de concentración de CO2 producidas durante la respiración.

Se registraron dos condiciones experimentales, cada una con una duración de captura de 30 segundos:
Reposo: el sujeto de prueba respiró de manera normal, sin hablar, mientras se contabilizó manualmente el número de ciclos respiratorios (inhalación-exhalación) durante el intervalo de captura.
Verbalización: el sujeto de prueba leyó en voz alta un texto durante el mismo intervalo de tiempo, manteniendo el sensor en la misma posición.
Para cada condición, la captura de datos se realizó mediante un script desarrollado en Python, empleando la librería pyserial para establecer comunicación con el puerto serial del Arduino. Los datos capturados (tiempo y valor ADC) se almacenaron en archivos con formato .csv.

El procesamiento de las señales se realizó en el entorno de MATLAB Online, dado que la captura en tiempo real desde MATLAB no fue posible al no contar este entorno con acceso a los puertos seriales locales. Los archivos .csv generados en la etapa de adquisición se cargaron en MATLAB mediante la función readtable.
Se eliminaron los primeros 0.1 segundos de cada señal, correspondientes a una lectura artefacto generada al inicio de la comunicación serial  (esto indicado por el profesor). Posteriormente se aplicó un filtro digital pasa-bajas tipo Butterworth de cuarto orden, con una frecuencia de corte de 1 Hz, mediante las funciones butter y filtfilt  con el objetivo de atenuar componentes de alta frecuencia no asociados al proceso respiratorio (rango fisiológico esperado: 0.1-0.5 Hz).
Sobre la señal filtrada se calculó la Transformada Rápida de Fourier (FFT) mediante la función fft, obteniéndose la representación en el dominio de la frecuencia. Se identificó la frecuencia dominante correspondiente al pico de mayor magnitud dentro del espectro, excluyendo el rango inferior a 0.1 Hz para evitar la interferencia de componentes de tendencia  de baja frecuencia propios de la estabilización del sensor. A partir de la frecuencia dominante obtenida, se calculó la frecuencia respiratoria en respiraciones por minuto  multiplicando dicho valor por 60.

## Resultados

### Datos obtenidos en reposo
<img width="700" height="432" alt="image" src="WhatsApp Image 2026-08-04 at 7.46.18 PM.jpeg" />

<img width="651" height="430" alt="image" src="WhatsApp Image 2026-08-04 at 7.46.38 PM.jpeg" />


<img width="666" height="431" alt="image" src="WhatsApp Image 2026-08-04 at 7.46.58 PM.jpeg" />


<img width="612" height="96" alt="image" src="https://github.com/user-attachments/assets/9577eb16-5dcf-4945-9185-f6d1827881dc" />

### Datos obtenidos en lectura 


<img width="672" height="438" alt="image" src="WhatsApp Image 2026-08-04 at 7.48.51 PM.jpeg" />


<img width="666" height="432" alt="image" src="WhatsApp Image 2026-08-04 at 7.49.07 PM.jpeg" />


<img width="653" height="435" alt="image" src="WhatsApp Image 2026-08-04 at 7.49.29 PM.jpeg" />

<img width="630" height="66" alt="image" src="https://github.com/user-attachments/assets/8dadfce5-04c7-4e28-a01b-48bb2cc5239e" />




**Condición de reposo:** Se obtuvo una frecuencia dominante de 0.201 Hz, 
equivalente a 12.0 respiraciones por minuto.

**Condición de habla:** Se obtuvo una frecuencia dominante de 0.100 Hz, 
equivalente a 6.0 respiraciones por minuto

Para la condición de **reposo**, se obtuvo una frecuencia de muestreo estimada 
de 50.00 Hz. El análisis espectral de la señal filtrada evidenció una 
frecuencia dominante de 0.201 Hz, equivalente a una frecuencia respiratoria 
estimada de 12.0 respiraciones por minuto, valor que se encuentra dentro 
del rango normal.

Para la condición de **lectura en voz alta**, se obtuvo una frecuencia de 
muestreo estimada de 49.99 Hz. El análisis espectral evidenció una frecuencia 
dominante de 0.100 Hz, equivalente a una frecuencia respiratoria estimada 
de 6.0 respiraciones por minuto.

Se observó una disminución de la frecuencia respiratoria durante la 
condición de lectura respecto a la condición de reposo (de 12.0 a 
6.0 respiraciones/min), lo cual se discute en la siguiente parte.

## Discusión

**¿Son los patrones respiratorios y frecuencias respiratorias iguales o 
diferentes en cada caso? ¿A qué se debe esto?**

Se encontraron diferencias marcadas entre las dos condiciones evaluadas. 
En reposo se obtuvo una frecuencia respiratoria de 12.0 respiraciones 
por minuto valor que se ubica dentro del rango normal reportado para 
un adulto sano en estado de reposo (12-20 resp/min) [1]. Durante la 
lectura en voz alta la frecuencia respiratoria disminuyó a 6.0 
respiraciones por minuto.

La comparación de ambas condiciones muestra una diferencia de 6.0 respiraciones por minuto entre el estado de reposo y la lectura en voz alta, correspondiente a una reducción aproximada del 50 % respecto al valor obtenido durante el reposo. En términos de frecuencia, el componente dominante pasó de 0.201 Hz en reposo a 0.100 Hz durante la verbalización.

Sin embargo, esta diferencia debe interpretarse con precaución debido a que cada condición tuvo una duración de captura de únicamente 30 segundos. Además, durante la lectura en voz alta la respiración puede presentar un comportamiento menos periódico, por lo que la frecuencia dominante identificada mediante FFT puede no representar completamente todos los ciclos respiratorios realizados por el sujeto.

Esto es consistente con lo reportado en la literatura. Bernardi 
et al. [2] encontraron que en comparación con la respiración espontánea
la frecuencia respiratoria disminuye de forma significativa durante la 
lectura en voz alta y el habla libre  desplazándose a valores cercanos 
a 0.07 Hz (equivalentes a aproximadamente 4 respiraciones por minuto), 
resultado muy similar al obtenido en la presente práctica (0.100 Hz, 
6.0 resp/min).

Esta disminución se explica fisiológicamente por el hecho de que durante 
el habla el control de la respiración deja de ser predominantemente 
automático (regulado por el tallo cerebral en función de los niveles de 
CO2 y O2) y pasa a subordinarse a las demandas del acto de fonación. 
Para producir frases completas de forma inteligible el hablante requiere 
inhalaciones más profundas y espaciadas seguidas de exhalaciones 
prolongadas y controladas que sostienen el flujo de aire necesario para 
la producción de la voz a lo largo de toda la frase [3]. Como consecuencia 
el número de ciclos respiratorios por minuto disminuye aunque el volumen 
de aire movilizado  tienda a aumentar.

**¿Cuáles serían las ventajas y desventajas de emplear múltiples sensores 
para el monitoreo del proceso respiratorio? ¿Cuáles podrían ser las razones?**

El sistema desarrollado empleó un único sensor de gas para la detección 
indirecta del patrón respiratorio a partir de las variaciones en la 
concentración de CO2 exhalado. Se observó que la señal obtenida presentó 
una respuesta asimétrica con incrementos de voltaje relativamente rápidos 
ante la exhalación y decaimientos más lentos durante la inhalación y la 
disipación del gas atribuible a la dinámica de difusión de los gases y 
al tiempo de respuesta propio del elemento sensible del sensor MQ.

Una limitación importante del sistema implementado está relacionada con el principio de funcionamiento del sensor MQ-135. Aunque las variaciones de su señal pueden utilizarse para detectar indirectamente cambios asociados con el aire exhalado, el sensor no realiza una medición específica y directa de la concentración de CO₂. Su respuesta puede verse afectada por diferentes gases presentes en el ambiente, la temperatura, la humedad, la distancia respecto al sujeto y el movimiento del aire.

Además, la dinámica de respuesta del sensor introduce un retardo y una respuesta temporal que pueden modificar la morfología de la señal respiratoria. Esto resulta particularmente relevante durante la verbalización, donde existen cambios rápidos en el flujo de aire y períodos de exhalación prolongados. Por esta razón, el sistema desarrollado resulta adecuado para demostrar la posibilidad de extraer información relacionada con el patrón respiratorio, pero presenta limitaciones para realizar una medición clínica precisa de la frecuencia respiratoria o de la concentración de CO₂.

El uso de múltiples sensores por ejemplo combinando el sensor de gas con 
un sensor de movimiento torácico  puede ser banda piezoeléctrica o acelerómetro, 
presentaría como ventaja la posibilidad de contrastar dos variables 
fisiológicas distintas composición del aire exhalado y movimiento mecánico 
de la caja torácica, lo cual permitiría validar de forma cruzada la 
frecuencia respiratoria obtenida y reducir la incertidumbre asociada a las 
limitaciones individuales de cada sensor. De igual forma  un sensor de movimiento 
podría capturar de forma más fiel la morfología de la señal respiratoria
al no depender de fenómenos de difusión gaseosa.

Como desventaja el uso de múltiples sensores incrementa la complejidad 
del sistema de adquisición tanto en términos de acondicionamiento de 
señal cada sensor puede requerir distintas etapas de amplificación y 
filtrado como de sincronización temporal de los datos además de 
incrementar el costo y el consumo energético del sistema. Para aplicaciones 
clínicas donde se requiere alta confiabilidad esta redundancia podría 
justificarse pero para un sistema de monitoreo básico o portátil 
la adición de sensores debe evaluarse en función de la mejora real que 
aporte frente a la complejidad adicional que introduce.




## Conclusión

A partir de los resultados obtenidos se concluye que la frecuencia 
respiratoria de un individuo sano varía significativamente entre las 
condiciones de reposo y verbalización disminuyendo durante esta última 
como consecuencia de la subordinación del control respiratorio a las 
demandas del habla. En cuanto a la variable física más adecuada para la 
detección de posibles anomalías respiratorias se considera que el 
movimiento mecánico de la caja torácica medido mediante sensores de 
presión, piezoeléctricos o de inductancia resulta más confiable que la 
variación en la concentración de gases exhalados dado que refleja de 
forma más directa y con menor retardo la dinámica del ciclo respiratorio 
mientras que los sensores de gas como el empleado en esta práctica
presentan limitaciones asociadas a la respuesta asimétrica del elemento 
sensible y a su sensibilidad ante corrientes de aire ambientales ajenas 
al proceso respiratorio del sujeto.


## Referencias

[1] C. G. Lausted y A. T. Johnson, "Respiratory System," en Biomedical 
Engineering Fundamentals, J. D. Bronzino, Ed. Boca Raton, FL, USA: CRC 
Press, 2006. https://doi.org/10.1201/9781420003857

[2] L. Bernardi, J. Wdowczyk-Szulc, C. Valenti, S. Castoldi, C. Passino, 
G. Spadacini, y P. Sleight, "Effects of controlled breathing, mental 
activity and mental stress with or without verbalization on heart rate 
variability," Journal of the American College of Cardiology, vol. 35, 
no. 6, pp. 1462–1469, May 2000. https://doi.org/10.1016/S0735-1097(00)00595-7

[3] L. L. Kuhlmann y J. Iwarsson, "Effects of Speaking Rate on Breathing 
and Voice Behavior," Journal of Voice, vol. 38, no. 2, pp. 346–356, 2024. 
https://doi.org/10.1016/j.jvoice.2021.09.005
Engineering Fundamentals, J. D. Bronzino, Ed. Boca Raton, FL, USA: CRC 
Press, 2006.
