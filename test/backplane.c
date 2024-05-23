#include <stdio.h>
#include <stdint.h>
#include <string.h>

#include "jakestering.h"

void outputCount( uint8_t count, int offset );

int main( int argc, char *argv[] )
{
  setupIO();

  for ( int i = 0; i < 28; i++ )
  {
    pinMode( i, OUTPUT );
    digitalWrite( i, LOW );
  }

  for ( int i = 1; i < argc; i++ )
  {
    if ( strcmp( argv[i], "-1" ) == 0 )
    {
      uint8_t counter = 0;
      while (1)
      {
        outputCount( counter, 0 );
        outputCount( counter, 8 );
        outputCount( counter, 16 );

        for ( int i = 0; i < 4; i++ )
        {
          uint8_t bit = ( counter >> ( 7 - i ) ) & 1;
          digitalWrite( i + 24, bit );
        }
        
        counter++;
        delay(10);
      }
    }

    if ( strcmp( argv[i], "-2" ) == 0 )
    {
      uint8_t counter = 0;
      while (1)
      {
        outputCount( counter, 0 );
        outputCount( counter, 9 );
        outputCount( counter, 18 );
        digitalWrite( 27, HIGH );

        counter++;
        delay(10);
        digitalWrite( 27, LOW );
      }
    }

    if ( strcmp( argv[i], "-3" ) == 0 )
    {
      for ( int i = 0; i < 28; i++ )
      {
        digitalWrite( i, LOW );
      }
    }
    
    if ( strcmp( argv[i], "-4" ) == 0 )
    {
      for ( int i = 0; i < 28; i++ )
      {
        pinMode( i, INPUT );
      }
    }
  }
}

void outputCount( uint8_t count, int offset )
{
  for ( int i = 0; i < 8; i++ )
  {
    uint8_t bit = ( count >> ( i ) ) & 1;
    digitalWrite( i + offset, bit );
  }
}

