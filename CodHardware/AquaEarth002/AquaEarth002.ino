//incluye wifi
#include <WiFi.h>

//incluye database
#include <FirebaseESP32.h>

//credenciales wifi
#define WIFI_SSID "UPCH_CENTRAL"
#define WIFI_PASSWORD "CAYETANO2022"

//credenciales proyecto
#define FIREBASE_HOST "https://aquaearth-5e798-default-rtdb.firebaseio.com/"
#define FIREBASE_AUTH "SavF0eFbHoprVDchHbqyXPSbxq6NwczPgbHK3ub1"

//firebase data object
FirebaseData firebaseData;

String nodo="/Sensores";
bool iterar=true;

void setup() 
{
  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Conectado al Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  
  Firebase.begin(FIREBASE_HOST,FIREBASE_AUTH);
  Firebase.reconnectWiFi(true);
}

void loop() {
  while(iterar){
    //Leer datos
    Firebase.getInt(firebaseData, nodo + "/sensor_pH");
    Serial.println(firebaseData.intData());
    delay(250);
 
    Firebase.getInt(firebaseData, nodo + "/sensor_conductividad");
    Serial.println(firebaseData.intData());
    delay(250);
    
    //escribir datos
    Firebase.setInt(firebaseData, nodo + "/sensor_pH",10);
    Firebase.setInt(firebaseData, nodo + "/sensor_conductividad",1400);
    //Firebase.setBool(firebaseData, nodo + "/iterar",false);
    
    //Firebase.pushInt(firebaseData, nodo + "/lecturas"; );
    //delay(100);
    iterar=false;
    Firebase.end(firebaseData);
  }
}
