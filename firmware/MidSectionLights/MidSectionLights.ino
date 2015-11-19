#include <SoftwareSerial.h>
#include <MIDI.h>
#include <LunaController_MIDI.h>
#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
  #include <avr/power.h>
#endif

#define NEOPIXEL_PIN 6

const uint8_t g_numSectors = 4;
const uint8_t g_numStrips = 3;
const uint8_t g_numPixels = g_numSectors * g_numStrips;

SoftwareSerial g_midiSerial(2, 3);
LunaController_MIDI<SoftwareSerial> g_luna(g_midiSerial, 1);

Adafruit_NeoPixel g_pixels = Adafruit_NeoPixel(g_numPixels, NEOPIXEL_PIN, NEO_BRG + NEO_KHZ800);

uint8_t g_rgbBuffer[g_numSectors * 3];

void setup()
{
  Serial.begin(9600);
  Serial.println(g_luna.setCallback(&handle));

  g_pixels.begin();
  g_pixels.show();

  for (uint8_t i = 0; i < g_numSectors * 3; i++)
    g_rgbBuffer[i] = 0;
}

void loop()
{
  g_luna.poll();
}

void handle(lunachannel_t channel, lunachannelvalue_t value)
{
  Serial.print("Channel ");
  Serial.print(channel);
  Serial.print(" = ");
  Serial.println(value);

  g_rgbBuffer[channel] = value;

  uint8_t sectorIdx = channel % g_numSectors;
  setSector(sectorIdx, g_rgbBuffer[sectorIdx], g_rgbBuffer[sectorIdx+1], g_rgbBuffer[sectorIdx+2]);
}

void setSector(uint8_t sector, uint8_t r, uint8_t g, uint8_t b)
{
  for (uint8_t i = 0; i < g_numStrips; i++)
  {
    uint8_t pixelIdx = i * g_numSectors;

    if (i % 2)
      pixelIdx += g_numSectors - sector - 1;
    else
      pixelIdx += sector;

    g_pixels.setPixelColor(pixelIdx, g_pixels.Color(r, g, b));
    g_pixels.show();
  }
}
