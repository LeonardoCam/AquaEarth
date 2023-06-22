#include <ETH.h>
#include <WiFi.h>
#include <WiFiAP.h>
#include <WiFiClient.h>
#include <WiFiGeneric.h>
#include <WiFiMulti.h>
#include <WiFiScan.h>
#include <WiFiServer.h>
#include <WiFiSTA.h>
#include <WiFiType.h>
#include <WiFiUdp.h>

//incluye wifi
#include <WiFi.h>

//incluye database
#include "FirebaseESP32.h"

//credenciales wifi
#define WIFI_SSID "leocam07"
#define WIFI_PASSWORD "123456789"

//credenciales proyecto
#define FIREBASE_HOST "https://aquaearth-5e798-default-rtdb.firebaseio.com/"
#define FIREBASE_AUTH "SavF0eFbHoprVDchHbqyXPSbxq6NwczPgbHK3ub1"
firebaseData AquaEarthFull;

//firebase data object
FirebaseData firebaseData;

String nodo="/Sensores";
bool iterar=true;

void setup() 
{
  Serial.begin(115200);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  
  Firebase.begin(FIREBASE_HOST,FIREBASE_AUTH)
  Firebase.reconnectWiFi(true);
}

void loop() {
  while(iterar)
  {
    Firebase.getInt(firebaseData, nodo + "/sensor_pH");
    Serial.println(firebaseData.intData());
    delay(250);
    
 
    Firebase.getInt(firebaseData, nodo + "/sensor_conductividad");
    Serial.println(firebaseData.intData());
    delay(250);
    
    //escribir datos
    Firebase.setInt(firebaseData, nodo + "/sensor_pH",3.4)
    Firebase.setString(firebaseData, nodo + "/sensor_conductividad", 330);
    Firebase.setBool(firebaseData, nodo + "/iterar",false);
    
    //Firebase.pushInt(firebaseData, nodo + "/lecturas"; );
    //delay(100);
    //iterar=false;
    //Firebase.end(firebaseData);
  }
}
