const int potPin=35;
float ph;
float Value=0;
 
void setup() {
  Serial.begin(115200);
  pinMode(potPin,INPUT);
  delay(1000);
}
 void loop(){
 
    Value= analogRead(potPin);
    float voltage=Value*(3.3/4095.0);
    ph=(-7.1307*voltage)+ 25.397;
    Serial.print("El valor de voltaje es: ");
    Serial.print(voltage);
    Serial.print(" | Y el de pH es: ");
    Serial.println(ph);
    delay(1000);
 }
 
