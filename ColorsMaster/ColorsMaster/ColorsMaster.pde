import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

//************************Imagens************************//
PImage tittleScreen[] = new PImage[2];
PImage tutorial[] = new PImage[2];

PImage resultados[] = new PImage[4];

PImage heart[] = new PImage[2];
PImage game;
//*******************************************************//

//************************Fontes************************//
PFont fonte;

//*******************************************************//

//************************Cores************************//
int valorR = 0;
String red;

int valorG = 0;
String green;

int valorB = 0;
String blue;
//****************************************************//



//************************Botao************************//
static int botao = 2;
long timeLock = 200;
long timestampBotao; 
//*****************************************************//



//************************Telas************************//
int tela;
long timestampTela;
int auxTela;
//*****************************************************//

//****************************jogo**********************//
int vidas = 3;
long timer = 40; //em segundos
long timerStart;
String timerNumber;

int randomR, randomG, randomB;
boolean sortear = true;

long timestampResultado;

//*****************************************************//

void setup() 
{
  fullScreen();
  //size(1360, 768);
  tittleScreen[0] = loadImage("TittleScreenv2.png");
  tittleScreen[1] = loadImage("TittleScreenv2_2.png");

  tutorial[0] = loadImage("Tutorial.png");
  tutorial[1] = loadImage("Tutorial_2.png");

  heart[0] = loadImage("Heart.png");
  heart[1] = loadImage("Heart_Empty.png");
  
  game = loadImage("Game.png");
  fonte = loadFont("MyriadPro-BoldIt-48.vlw");
  
  resultados[0] = loadImage("Right_Screen.png"); 
  resultados[1] = loadImage("Wrong_Screen.png");
  resultados[2] = loadImage("Wrong_Screen.png");
  resultados[3] = loadImage("Wrong_Screen.png");

  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);

  arduino.pinMode(2, Arduino.INPUT_PULLUP);

  frameRate(60);

  timestampBotao = millis();
  timestampTela = millis();
}

void draw() 
{
  background(0);

  if (arduino.digitalRead(botao) == Arduino.LOW && (millis() - timestampBotao) >= timeLock && frameCount > 180)
  {
    timestampBotao = millis();
    
    if(tela < 2)
    {
      tela++;
    }

    else
    {
      timerStart = millis();
      
      if (valorR == 127)
      {
         if (valorG == 127)
         {
           
           if (valorB == 127)
           {
             tela = 0;
           }
         }
      }
      
      else
      {
        tela = 5;
        timestampResultado = millis();
        vidas--;
      }
    }
  }

  switch(tela)
  {
  case 0: //tittle screen
    {

      imageMode(CORNER);

      if (millis() - timestampTela >= 700)
      {
        auxTela++;

        if (auxTela > 1)
        {
          auxTela = 0;
        }

        timestampTela = millis();
      }

      if (auxTela == 0)
      {
        image(tittleScreen[0], 0, 0);
      } else
      {
        image(tittleScreen[1], 0, 0);
      }

      break;
    }

  case 1: //tutorial
    {
      imageMode(CORNER);
      
      if (millis() - timestampTela >= 700)
      {
        auxTela++;

        if (auxTela > 1)
        {
          auxTela = 0;
        }

        timestampTela = millis();
      }

      if (auxTela == 0)
      {
        image(tutorial[0], 0, 0);
      } else
      {
        image(tutorial[1], 0, 0);
      }

      break;
    }

  case 2:
    {
      
      if (sortear == true)
      {
        randomR = int(random(256));
        randomG = int(random(256)); 
        randomB = int(random(256));
        
        sortear = false; 
      }
      
      if(millis() - timerStart >= 1000)
      {
        timer--;
        timerStart = millis();
        
        timerNumber = str(int(timer));
      }
      
      imageMode(CORNER);
  
      image(game, 0, 0);
      
      imageMode(CENTER);
      for(int i = 0; i < 3; i++)
      {
        if(vidas >= i+1)
        {
          image(heart[0], 1120+i*60, 70);
        }  
        
        else
        
        image(heart[1], 1120+i*60, 70);
        
      }

      float aux;
      valorR = arduino.analogRead(0);
      aux = map(float(valorR), 0.0, 1023.0, 0.0, 255.0);
      valorR = int(aux);
      red = str(valorR);
      

      valorG = arduino.analogRead(1);
      aux = map(float(valorG), 0.0, 1023.0, 0.0, 255.0);
      valorG = int(aux);
      green = str(valorG);

      valorB = arduino.analogRead(2);
      aux = map(float(valorB), 0.0, 1023.0, 0.0, 255.0);
      valorB = int(aux);
      blue = str(valorB);

      println(tela);

      textSize(40);
      fill(255, 0, 0);
      text(red, 400, 600);

      fill(0, 255, 0);
      text(green, 600, 600);

      fill(0, 0, 255);
      text(blue, 800, 600);
      
      stroke(0, 0, 0);
      strokeWeight(5);
      rectMode(CENTER);
      fill(randomR, randomG, randomB);
      rect(width/2, height/2 - 50, 250, 250);
      
      
      textFont(fonte);
      textAlign(CENTER);
      textSize(80);
      fill(0, 0, 0);
      text(timerNumber, width/2, 100);
      
      break;
    }
    
    case 3: //tela conferencia
    {
     break; //tela err
    }
    
     case 4: //tela resposta certa
    {
      imageMode(CORNER);
      image(resultados[0], 0, 0);
      
      if(millis() - timestampResultado > 3000)
      {
        tela = 2;
      }
      
     break; 
    }
    
     case 5: // tela resposta errada
    {
      imageMode(CORNER);
      image(resultados[1], 0, 0);
      
      if(millis() - timestampResultado > 3000)
      {
        tela = 2;
      }
      
     break; 
    }
    
     case 6: //tela timeup
    {
     break; 
    }
    
     case 7: //tela gameover
    {
     break; 
    }

  default:
    {
    }
  }

  print("mouse x, y: ");
  println(mouseX, mouseY);
  
  print("resposta");
  println(randomR, randomG, randomB);
}
