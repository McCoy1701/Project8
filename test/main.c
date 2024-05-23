#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>

#define THIRTY_TWO_KILOBYTES 32768

uint8_t rom[THIRTY_TWO_KILOBYTES] = {0};

uint8_t code[] = { 0xa9, 0xff,
                   0x8d, 0x02, 0x60,
                   0xa9, 0x55,
                   0x8d, 0x00, 0x60,
                   0xa9, 0xaa,
                   0x8d, 0x00, 0x60,};

int main()
{
  for ( int i = 0; i <= THIRTY_TWO_KILOBYTES; i++ )
  {
    if ( i <= sizeof(code) && i >= 0 )
    {
      rom[i] = code[i];
    }
    
    else
    {
      rom[i] = 0xea;
    }
  }

  rom[0x7ffc] = 0x00;
  rom[0x7ffd] = 0x80;

  FILE *file;
  file = fopen( "rom.bin", "wb" );
  fwrite( rom, sizeof(uint8_t), sizeof(rom), file );
  fclose(file);
}

