#include "OkuuArmCannon.h"

OkuuArmCannon::OkuuArmCannon(const PinConfig &pinConfig)
  : m_pinConfig(pinConfig)
  , m_aperturePixels(NULL)
  , m_midPixels(NULL)
{
}

OkuuArmCannon::~OkuuArmCannon()
{
  delete m_aperturePixels;
  delete m_midPixels;
}

void OkuuArmCannon::begin()
{
  // Setup neopixels
  m_aperturePixels = new Adafruit_NeoPixel(NUM_APERTURE_PIXELS, m_pinConfig.apertureNeoPixelPin, NEO_BRG + NEO_KHZ800);
  m_midPixels = new Adafruit_NeoPixel(NUM_MID_SECTION_PIXELS, m_pinConfig.midSectionNeoPixelPin, NEO_BRG + NEO_KHZ800);

  m_aperturePixels->begin();
  m_midPixels->begin();

  m_aperturePixels->show();
  m_midPixels->show();

  // Setup laser relays
  pinMode(m_pinConfig.redLaserPin, OUTPUT);
  digitalWrite(m_pinConfig.redLaserPin, m_pinConfig.activeLow);

  pinMode(m_pinConfig.greenLaserPin, OUTPUT);
  digitalWrite(m_pinConfig.greenLaserPin, m_pinConfig.activeLow);

  pinMode(m_pinConfig.blueLaserPin, OUTPUT);
  digitalWrite(m_pinConfig.blueLaserPin, m_pinConfig.activeLow);
}

void OkuuArmCannon::setLaser(Colour colour, bool state)
{
  uint8_t pin = -1;

  switch (colour)
  {
    case COL_ALL:
      setLaser(COL_R, state);
      setLaser(COL_G, state);
      setLaser(COL_B, state);
      return;
    case COL_R:
      pin = m_pinConfig.redLaserPin;
      break;
    case COL_G:
      pin = m_pinConfig.greenLaserPin;
      break;
    case COL_B:
      pin = m_pinConfig.blueLaserPin;
      break;
  }

  if (m_pinConfig.activeLow)
    state = !state;

  digitalWrite(pin, state);
}

void OkuuArmCannon::setApertureLights(uint8_t pixel, uint8_t r, uint8_t g, uint8_t b)
{
  setApertureLights(pixel, Adafruit_NeoPixel::Color(r, g, b));
}

void OkuuArmCannon::setApertureLights(uint8_t pixel, uint32_t colour)
{
  if (pixel == ALL_PIXELS)
  {
    for (uint8_t i = 0; i < NUM_APERTURE_PIXELS; i++)
    {
      m_aperturePixels->setPixelColor(i, colour);
      m_aperturePixels->show();
    }
  }
  else
  {
    m_aperturePixels->setPixelColor(pixel, colour);
    m_aperturePixels->show();
  }
}

void OkuuArmCannon::setMidSectionLights(uint8_t section, uint8_t r, uint8_t g, uint8_t b)
{
  setMidSectionLights(section, Adafruit_NeoPixel::Color(r, g, b));
}

void OkuuArmCannon::setMidSectionLights(uint8_t section, uint32_t colour)
{
  for (uint8_t i = 0; i < NUM_MID_SECTION_STRIPS; i++)
  {
    uint8_t pixelIdx = i * NUM_MID_SECTIONS;

    if (!(i % 2))
      pixelIdx += NUM_MID_SECTIONS - section - 1;
    else
      pixelIdx += section;

    m_midPixels->setPixelColor(pixelIdx, colour);
    m_midPixels->show();
  }
}
