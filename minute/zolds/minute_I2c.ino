/*
 *  DISCLAIMER
 *
 *  Copyright © 2021, Alvaro Gomes Sobral Barcellos,
 *
 *  Permission is hereby granted, free of charge, to any person obtaining
 *  a copy of this software and associated documentation files (the
 *  "Software"), to deal in the Software without restriction, including
 *  without limitation the rights to use, copy, modify, merge, publish,
 *  distribute, sublicense, and/or sell copies of the Software, and to
 *  permit persons to whom the Software is furnished to do so, subject to
 *  the following conditions"
 *
 *  The above copyright notice and this permission notice shall be
 *  included in all copies or substantial portions of the Software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 *  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 *  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 *  NON INFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 *  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 *  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 *
 *  //-\--/\-//-\/-/\\\\/-\--\\\-///\-/-/\/--/\\\\/-\-//-/\//-/\//--//-///--\\\-///\-/-/\/
 *
 *  This work is licensed under a 
 *  Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License.
 *  http://creativecommons.org/licenses/by-nc-sa/4.0/
 *
 */

/*
 *  
 *
 *  Minute Side Box for split keyboards*
 *
 *
 */


#include <Arduino.h>

// for USB ???

// for preserve keys, leds, states
#include <EEPROM.h>

// for basic I2C
#include <Wire.h>

/*  
 *   Wire library only buffers 32 bytes 
 *   main controller does not have a address
 *   side devices must have address from 8 to 127
*/

#define MYSPEED 10000

#include "minute.h"

/* define the pins for the side devices */

#define PIN_INT0 2
#define PIN_INT1 3

/*
 * Arduino pro mini pins 
 *
 * 1 PD1 TX, 2 PD2 RX, 3 PC6 RST, 4 GND, 5 PD2 INT0, 6 PD3 INT1, 
 * 7 PD4 T0, 8 PD5 T1, 9 PD6 AIN0, 10 PD7 AIN1, 11 PB0 CLK0, 12 PB1 OC1A,
 * 13 PB2 OC1B, 14 PB3 MOSI , 15 PB4 MISO, 16 PB5 SCK, 17 PC0 A0, 18 PC1 A1,
 * 19 PC2 A2, 20 PC3 A4, 21 VCC, 22 PC6 RST, 23 GND, 24 RAW
 * 25 PC4 SDA, 26 PC5 SCL,
 * 
 */

/*
 * array for pins to switches, starts at 1, last must be 0, as a asciiz. 
 *
 * switches are wired direct 
 *  
 *  as Pin -----> switch ----> GND
 *  
 *  put in PULL UP before read
*/

int buttons[] = { 4, 5, 6, 7, 8, 9, 11, 12, 13, 0 }; 

// define hand is (main or left or right)

int hand = is_main;

// common variables

int v, n, m;

byte a, b, c, d, hasdata;


void buttonReset(void) {
  
  n = 0;
  
  while (buttons[n]) {
      digitalWrite (buttons[n], HIGH);
      n++;
      }
}

int buttonRead(void) {
  
  n = 0;
  m = 0;
  v = 0;
  
  while (buttons[n]) {
      m = digitalRead (buttons[n]);
      v = v | (m << n);
      n++;
      }
  return (v);
}

void blink (int isdelay) {
  digitalWrite(LED_BUILTIN, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(isdelay);                    // wait for a second
  digitalWrite(LED_BUILTIN, LOW);    // turn the LED off by making the voltage LOW
  delay(isdelay);                    // wait for a second
}

// those are ISR functions

// buffers
byte cnt, snd[32], rcv[32];

// called from a requestFrom
void requestEvent (void) {
  for (int n = 0; n < cnt; n++) {
    Wire.write(snd[n]);
    }
  }

// called from a beginTransmission
void receiveEvent (void) {
  // who
  a = Wire.read();
  // what
  b = Wire.read();
  // how
  c = Wire.read();
  
  hasdata = 3;
  
  }

#define MAX 8
  
// put your setup code here, to run once:
void setup() {
 
  reset();
  
// for tests, initialize digital pin LED_BUILTIN as an output.
  
  pinMode(LED_BUILTIN, OUTPUT);
  
  Serial.begin(9600);

}

// pulse count
void pulse ( byte n ) {
  while (n--) {
      blink (500);
    }
}

// check 
void check ( void ) {

  if (b != 'V') {
    Serial.print (" Error: from [");
    Serial.print (a);
    Serial.println ("]");
    }
    
  c = c % MAX;

  d = ++c;
    
  pulse (c--);
      
}  


int talk (void) {

  if (hasdata) check();

// send a counter to left

  if (hand == is_main) {
    Wire.beginTransmission(is_left); 
    Wire.write (hand);
    Wire.write('V');
    Wire.write(d);
    Wire.endTransmission();
  }

  return (0);

}

// the loop function runs over and over again forever
void loop() {
  
  talk ();
   
  delay (1000);

} // end loop

void reset( void ) {

  // I'm alive

  Wire.begin(hand);  

  Wire.onRequest(requestEvent);
  
  Wire.onReceive(receiveEvent);
  
  Wire.setClock(MYSPEED);

}
    
void query( void ) {

  buttonReset();

  buttonRead();

};
    
void light( void ) {
 
};
    
void wsleds( void ) {

};
    
void save( void ) {
 
};

void load( void ) {
 
};

void verify( void ) {

};
    
    
// called when have data

void wherever (void) {

  switch (c)  {

    case 'R' : reset(); break;
    
    case 'Q' : query(); break;
    
    case 'B' : light(); break;
    
    case 'W' : wsleds(); break;
    
    case 'S' : save(); break;
    
    case 'L' : load(); break;
    
    case 'V' : verify(); break;
    
    default:
    
      break;
    }

  hasdata = 0;

}
