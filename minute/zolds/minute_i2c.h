#ifndef MINUTE
    #define MINUTE
#endif

// define hand is main or left or right, 
// for I2C main is the controller and left or right are devices
// valid address 8 to 120, 0-7 reserved and 121-127 reserved
//
// http://www.gammon.com.au/i2c  says it could just talks any to any
//

#define is_main 0x10

#define is_left 0x12

#define is_right 0x14

// eeprom banks for preserve keys, leds, states

#define bank_one 0x0000
#define bank_two 0x0100
#define bank_six 0x0200
#define bank_ten 0x0300

// function prototypes

void reset( void );

void query( void );

void light( void );

void wsleds( void );

void save( void );

void load( void );

void verify( void );

void wherever (void);
