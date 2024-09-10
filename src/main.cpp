//#include <Adafruit_LittleFS.h>
#include <InternalFileSystem.h>
#include <Adafruit_TinyUSB.h> // for Serial

//using namespace Adafruit_LittleFS_Namespace;

void enterDfuMode()
{
    enterUf2Dfu();
}

// the setup function runs once when you press reset or power the board
void setup()
{
  Serial.begin(115200);
  while ( !Serial ) delay(10);   // for nrf52840 with native usb
  Serial.println("Meshtastic nRF52 Factory Erase firmware for the Meshtastic project.");
  Serial.println();

  // Initialize Internal File System
  InternalFS.begin();

  Serial.print("Formating ... ");
  delay(1); // for message appear on monitor

  // Format
  InternalFS.format();

  Serial.println("Done, rebooting device into DFU mode");
  delay(1); // for message appear on monitor
  enterDfuMode();
}

// the loop function runs over and over again forever
void loop()
{
  // nothing to do
}
