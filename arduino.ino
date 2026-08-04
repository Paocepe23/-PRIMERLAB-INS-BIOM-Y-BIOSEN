const int pinSensor = A0;
unsigned long tiempoAnterior = 0;
const int intervaloMs = 20; // ~50 muestras/segundo

void setup() {
  Serial.begin(9600);
}

void loop() {
  unsigned long tiempoActual = millis();
  if (tiempoActual - tiempoAnterior >= intervaloMs) {
    tiempoAnterior = tiempoActual;
    int valor = analogRead(pinSensor);
    Serial.println(valor);
  }
}
