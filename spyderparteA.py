# -*- coding: utf-8 -*-
"""
Created on Tue Jul 28 12:04:25 2026

@author: PAOLA
"""

import serial
import time
import csv
import matplotlib.pyplot as plt

# --- Configuración ---
puerto = "COM6"       # cambia esto al puerto de tu Arduino
baudrate = 9600
duracion = 30          # segundos
nombre_archivo = "respiracion_en_lectura_3.csv"  # cambia según la condición

# --- Conexión ---
ser = serial.Serial(puerto, baudrate, timeout=1)
time.sleep(2)  # espera a que se estabilice la conexión
ser.reset_input_buffer()

print("Iniciando captura en 3 segundos...")
time.sleep(3)
print("¡Capturando! Habla o lee en voz alta frente al sensor...")

datos = []
tiempos = []
t_inicio = time.time()

while (time.time() - t_inicio) < duracion:
    linea = ser.readline().decode('utf-8').strip()
    if linea.isdigit():
        datos.append(int(linea))
        tiempos.append(time.time() - t_inicio)

ser.close()
print(f"Captura terminada. {len(datos)} muestras guardadas.")

# --- Guardar en CSV ---
with open(nombre_archivo, 'w', newline='') as f:
    writer = csv.writer(f)
    writer.writerow(['tiempo', 'senal'])
    for t, v in zip(tiempos, datos):
        writer.writerow([t, v])

print(f"Archivo guardado como {nombre_archivo}")

# --- Graficar señal ---
plt.figure(figsize=(10, 4))
plt.plot(tiempos, datos)
plt.xlabel('Tiempo (s)')
plt.ylabel('Valor ADC (0-1023)')
plt.title('Señal respiratoria - Habla')
plt.grid(True)
plt.show()
