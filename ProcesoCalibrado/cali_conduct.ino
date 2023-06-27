const int potPin=34;
float Conduct;
int value;

void setup() {
  Serial.begin(115200);
  pinMode(potPin, INPUT);
  delay(1000);
}

void loop() {
  value= analogRead(potPin);
  float voltage= value*(3.3/4095.0);
  Conduct=1603.4*voltage + 2;
  Serial.print("Voltaje es: ");
  Serial.print(voltage);
  Serial.print("| Y la de conductividad es: ");
  Serial.println(Conduct);
  delay(1000);
}
