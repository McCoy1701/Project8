#include <stdio.h>
#include <jakestering.h>

#define RW  24
#define CLK 25
#define IRQB 26
#define NMIB 27

int DATA[] = { 7, 6, 5, 4, 3, 2, 1, 0 };
int ADDR[] = { 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 9, 8 };

typedef struct _pinData
{
  unsigned int data;
  unsigned int addr;
  int r_w;
  int clk;
}Pin_data_t;

int pressed = 0;

void logic_analyzer_handler(void);
void fillPinData( Pin_data_t *data );

int main( int argc, char *argv[] )
{
  setupIO();

  for ( int i = 0; i < 28; i++ )
  {
    pinMode( i, INPUT );
    //digitalWrite( i, LOW );
  }

  pinMode(  RW, INPUT );
  pudController( RW, PUD_DOWN );
  pinMode( CLK, INPUT );
  pudController( CLK, PUD_DOWN );
  pinMode(  IRQB, INPUT );
  pudController( IRQB, PUD_DOWN );
  pinMode( NMIB, INPUT );
  pudController( NMIB, PUD_DOWN );
  
/*  digitalWrite( 7, HIGH );
  digitalWrite( 6, HIGH );
  digitalWrite( 5, HIGH );
  digitalWrite( 4, LOW  );
  digitalWrite( 3, HIGH );
  digitalWrite( 2, LOW  );
  digitalWrite( 1, HIGH );
  digitalWrite( 0, LOW  );
  */

  jakestering_ISR( CLK, RISING_EDGE, &logic_analyzer_handler );
  
  while (1)
  {
    delay(1000);
  }
}

void logic_analyzer_handler(void)
{
  Pin_data_t current;
  fillPinData( &current );
  printf(" | CLK: %d | R/W: %c | ADDR: %04x | DATA: %02x pressed: %d\n", current.clk, current.r_w ? 'r' : 'W', current.addr, current.data, pressed );
  pressed++;
}

void fillPinData( Pin_data_t *data )
{
  data->data = 0;
  for ( int i = 0; i < 8; i++ )
  {
    int bit = digitalRead( DATA[i] ) ? 1 : 0;
    printf( "%d", bit );
    data->data = ( data->data << 1 ) + bit;
  }
  
  data->addr = 0;
  printf(" | ");
  for ( int i = 0; i < 16; i++ )
  {
    int bit = digitalRead( ADDR[i] ) ? 1 : 0;
    printf( "%d", bit );
    data->addr = ( data->addr << 1 ) + bit;
  }

  data->r_w = digitalRead( RW );
  data->clk = digitalRead( CLK );
}

