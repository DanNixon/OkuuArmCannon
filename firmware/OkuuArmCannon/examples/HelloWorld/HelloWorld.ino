#include "Adafruit_NeoPixel.h"
#include "OkuuArmCannon.h"

PinConfig pinConfig = {true, 11, 12, A5, A3, A4};
OkuuArmCannon cannon(pinConfig);

void setup()
{
  Serial.begin(9600);

  cannon.begin();
  delay(1000);

  cannon.setLaser(COL_R, true);
  delay(1000);
  cannon.setLaser(COL_G, true);
  delay(1000);
  cannon.setLaser(COL_B, true);
  delay(1000);

  cannon.setMidSectionLights(0, 255, 255, 255);
  delay(1000);
  cannon.setMidSectionLights(1, 255, 0, 0);
  delay(1000);
  cannon.setMidSectionLights(2, 0, 255, 0);
  delay(1000);
  cannon.setMidSectionLights(3, 0, 0, 255);
  delay(1000);

  cannon.setApertureLights(0, 255, 255, 255);
}

void loop()
{
}
