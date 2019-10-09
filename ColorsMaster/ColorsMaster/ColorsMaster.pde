import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

PImage tittleScreen;


int valor = 0;

void setup() 
{
  
   size(1360, 768);
  tittleScreen = loadImage("TittleScreenv2.png");
  
   println(Arduino.list());
   arduino = new Arduino(this, Arduino.list()[4], 57600);
}

void draw() 
{
   imageMode(CORNER);
   image(tittleScreen, 0, 0);
  
   valor = arduino.analogRead(0);
   ellipse(320,240,valor,valor);
}
