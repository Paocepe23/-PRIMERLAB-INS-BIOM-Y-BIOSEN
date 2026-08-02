%% PARTE B - Procesamiento en MATLAB Online
% Sube primero tu archivo .csv a MATLAB Drive antes de correr esto

clear; clc; close all;

%% --- Cargar datos ---
nombre_archivo = 'respiracion_en_reposo_3.csv';  % cambia según la condición
datos = readtable(nombre_archivo);

tiempo = datos.tiempo;
senal = datos.senal;

%% --- Eliminar artefacto inicial (primeros 0.1 segundos) ---
idx_valido = tiempo > 0.1;
tiempo = tiempo(idx_valido);
senal = senal(idx_valido);

% Calcular frecuencia de muestreo real
fs = 1 / mean(diff(tiempo));
fprintf('Frecuencia de muestreo estimada: %.2f Hz\n', fs);

%% --- Graficar señal cruda ---
figure;
plot(tiempo, senal);
xlabel('Tiempo (s)');
ylabel('Valor ADC (0-1023)');
title('Señal respiratoria cruda - Habla');
grid on;

%% --- Filtro pasa-bajas ---
fc = 1;  % frecuencia de corte en Hz
orden = 4;
[b, a] = butter(orden, fc/(fs/2), 'low');
senal_filtrada = filtfilt(b, a, senal);

figure;
plot(tiempo, senal, 'Color', [0.7 0.7 0.7]); hold on;
plot(tiempo, senal_filtrada, 'b', 'LineWidth', 1.5);
xlabel('Tiempo (s)');
ylabel('Valor ADC');
title('Señal cruda vs. filtrada (pasa-bajas, fc = 1 Hz)');
legend('Cruda', 'Filtrada');
grid on;

%% --- FFT: representación en frecuencia ---
N = length(senal_filtrada);
senal_centrada = senal_filtrada - mean(senal_filtrada);
Y = fft(senal_centrada);
f = (0:N-1) * (fs/N);

mitad = 1:floor(N/2);
f_mitad = f(mitad);
magnitud = abs(Y(mitad));

figure;
plot(f_mitad, magnitud);
xlabel('Frecuencia (Hz)');
ylabel('Magnitud');
title('Espectro de frecuencia de la señal respiratoria');
xlim([0 2]);
grid on;

%% --- Identificar frecuencia dominante (ignorando el rango cercano a 0) ---
f_min = 0.1;  % Hz - ignoramos ruido/tendencia por debajo de esto
idx_validos = f_mitad >= f_min;

[~, idx_max] = max(magnitud(idx_validos));
f_validas = f_mitad(idx_validos);
f_dominante = f_validas(idx_max);
resp_por_min = f_dominante * 60;

fprintf('Frecuencia dominante (real): %.3f Hz\n', f_dominante);
fprintf('Frecuencia respiratoria estimada: %.1f respiraciones/min\n', resp_por_min);
