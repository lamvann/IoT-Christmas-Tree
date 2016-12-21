#include <SPI.h>
#include <WiFi101.h>

#define PIN 6

char ssid[] = "network name goes here";      // your network SSID (name)
char pass[] = "password goes here";            // your network password
int counter = 0;
int status = WL_IDLE_STATUS;

WiFiServer server(2200);

void setup() {
  //Initialize serial and wait for port to open:
  pinMode(PIN, OUTPUT);
  
  Serial.begin(9600);
  while (!Serial) {
    ; // wait for serial port to connect. Needed for native USB port only
  }

  // check for the presence of the shield:
  if (WiFi.status() == WL_NO_SHIELD) {
    Serial.println("WiFi shield not present");
    // don't continue:
    while (true);
  }

  // attempt to connect to Wifi network:
  while ( status != WL_CONNECTED) {
    Serial.print("Attempting to connect to SSID: ");
    Serial.println(ssid);
    // Connect to WPA/WPA2 network. Change this line if using open or WEP network:
    status = WiFi.begin(ssid, pass);

    // wait 10 seconds for connection:
    delay(2000);
  }
  Serial.print("Connected to: ");
  Serial.println(ssid);
  server.begin();
  Serial.println("Ready to accept incoming connections...");
  
}


void loop() {
  // listen for incoming incomings
  WiFiClient incoming = server.available();
  if (incoming) {
    Serial.println("\nNew Connection Made");
    incoming.write("You are successfully connected to Arduino\n");
    while (incoming.connected()) {
      if (incoming.available()) {
        char c = incoming.read();
        Serial.write(c);
        if(!incoming.available()) { 
          incoming.print("Message received!\n");
          if(c == '1') {
            digitalWrite(PIN, HIGH);
          } else if (c == '0'){
            digitalWrite(PIN, LOW);
          }
          //Close the connection
          incoming.stop();
          Serial.println("incoming disconnected");
        }
      }
    }
  }
}
