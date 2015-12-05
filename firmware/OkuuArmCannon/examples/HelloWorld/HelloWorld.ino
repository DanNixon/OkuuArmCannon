#include "Adafruit_NeoPixel.h"
#include "OkuuArmCannon.h"

PinConfig pinConfig = {true, 11, 12, A5, A3, A4};
OkuuArmCannon cannon(pinConfig);

void setup()
{
  Serial.begin(9600);

  cannon.begin();
  delay(1000);

  cannon.setLaser(COL_ALL, true);
}

void loop()
{
  uint16_t i, j;

  for(j = 0; j < 256; j++)
  {
    for(i = 0; i < cannon.NUM_MID_SECTIONS; i++)
      cannon.setMidSectionLights(i, wheel(((20*i)+j) & 255));
    for(i = 0; i < cannon.NUM_APERTURE_PIXELS; i++)
      cannon.setApertureLights(i, wheel(((2*i)+j) & 255));

    delay(50);
  }
}

uint32_t wheel(byte pos)
{
  pos = 255 - pos;

  if(pos < 85)
    return Adafruit_NeoPixel::Color(255 - pos * 3, 0, pos * 3);

  if(pos < 170)
  {
    pos -= 85;
    return Adafruit_NeoPixel::Color(0, pos * 3, 255 - pos * 3);
  }

  pos -= 170;
  return Adafruit_NeoPixel::Color(pos * 3, 255 - pos * 3, 0);
}
