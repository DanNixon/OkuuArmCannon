#ifndef _OKUUARMCANNON_H_
#define _OKUUARMCANNON_H_

#include <Arduino.h>
#include <Adafruit_NeoPixel.h>
#ifdef __AVR__
#include <avr/power.h>
#endif

enum Colour
{
  COL_ALL,
  COL_R,
  COL_G,
  COL_B
};

struct PinConfig
{
  bool activeLow;

  uint8_t apertureNeoPixelPin;
  uint8_t midSectionNeoPixelPin;

  uint8_t redLaserPin;
  uint8_t blueLaserPin;
  uint8_t greenLaserPin;
};

class OkuuArmCannon
{
public:
  static const size_t NUM_MID_SECTIONS = 4;
  static const size_t NUM_MID_SECTION_STRIPS = 3;
  static const size_t NUM_MID_SECTION_PIXELS =
      NUM_MID_SECTIONS * NUM_MID_SECTION_STRIPS;
  static const size_t NUM_APERTURE_PIXELS = 24;
  static const uint8_t ALL_PIXELS = -1;

  OkuuArmCannon(const PinConfig &pinConfig);
  ~OkuuArmCannon();

  void begin();

  void setLaser(Colour colour, bool state);

  void setApertureLights(uint8_t pixel, uint8_t r, uint8_t g, uint8_t b);
  void setApertureLights(uint8_t pixel, uint32_t colour);

  void setMidSectionLights(uint8_t section, uint8_t r, uint8_t g, uint8_t b);
  void setMidSectionLights(uint8_t section, uint32_t colour);

private:
  const PinConfig &m_pinConfig;

  Adafruit_NeoPixel *m_aperturePixels;
  Adafruit_NeoPixel *m_midPixels;
};

#endif
