import processing.serial.*;
import cc.arduino.*;
Arduino arduino;

//************************Imagens************************//
PImage tittleScreen[] = new PImage[2];
PImage tutorial[] = new PImage[2];

PImage resultados[] = new PImage[4];

PImage heart[] = new PImage[2];
PImage game[] = new PImage[2];

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
long timestampBotaoAlto; 
boolean buttonLock = true;
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

int randomR = 0, randomG = 0, randomB = 0;
boolean sortear = true;

long timestampResultado;

int pontuacao = 0;

int erro = 100;
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

  game[0] = loadImage("Game.png");
  game[1] = loadImage("GameResults.png");
  fonte = loadFont("MyriadPro-BoldIt-48.vlw");

  resultados[0] = loadImage("Right_Screen.png"); 
  resultados[1] = loadImage("Wrong_Screen.png");
  resultados[2] = loadImage("Timeup.png");
  resultados[3] = loadImage("GameOver.png");

  println(Arduino.list());
  arduino = new Arduino(this, Arduino.list()[0], 57600);

  arduino.pinMode(2, Arduino.INPUT_PULLUP);

  frameRate(60);

  timestampBotao = millis();
  timestampTela = millis();
  timestampBotaoAlto = millis();
}

void draw() 
{
  background(0);

  if (arduino.digitalRead(botao) == Arduino.HIGH)
  {
    if (millis() - timestampBotaoAlto >= timeLock)
    {
      buttonLock = false;
    }
  }

  if (arduino.digitalRead(botao) == Arduino.LOW && buttonLock == false/*(millis() - timestampBotaoAlto) >= timeLock*/ && frameCount > 180)
  {
    timestampBotao = millis();
    buttonLock = true;

    println("pressionou");

    if (tela < 2)
    {
      tela++;
      
      if (tela == 3)
      {
        tela = 2;
      }
    } 
    
    else if (tela == 2)
    { 
      //timerStart = millis();

      if (valorR >= randomR - erro && valorR <= randomR + erro)
      {
        if (valorG >= randomG - erro && valorG <= randomG + erro)
        {

          if (valorB >= randomB - erro && valorB <= randomB + erro)
          {
            tela = 4;
            timestampResultado = millis();
          } else
          {
            tela = 5;
            timestampResultado = millis();
          }
        } else
        {
          tela = 5;
          timestampResultado = millis();
        }
      } else
      {
        tela = 5;
        timestampResultado = millis();
      }
    }
    
  }

  switch(tela)
  {
  case 0: //tittle screen
    {

      vidas = 3;
      timer = 40;
      pontuacao = 0;

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

        timer = 40;
        timerNumber = str(int(timer));
        timerStart = millis();
      }

      if (millis() - timerStart >= 1000)
      {
        timer--;
        timerStart = millis();

        timerNumber = str(int(timer));

        if (timer == 0)
        {
          tela = 6;
          timestampResultado = millis();
          break;
        }
      }

      imageMode(CORNER);
      image(game[0], 0, 0);

      imageMode(CENTER);
      for (int i = 0; i < 3; i++)
      {
        if (vidas >= i+1)
        {
          image(heart[0], 1120+i*60, 70);
        } else
        {
          image(heart[1], 1120+i*60, 70);
        }
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
      text(red, 450, 630);

      fill(0, 255, 0);
      text(green, 750, 630);

      fill(0, 0, 255);
      text(blue, 1050, 630);

      stroke(0, 0, 0);
      strokeWeight(5);
      rectMode(CENTER);
      fill(randomR, randomG, randomB);
      rect(width/2, height/2 - 50, 250, 250);


      textFont(fonte);
      textAlign(CENTER);
      textSize(80);
      if (timer < 16)
      {
        fill(255, 0, 0);
      } else
      {
        fill(0, 0, 0);
      }
      text(timerNumber, width/2, 100);

      textFont(fonte);
      textAlign(CENTER);
      textSize(36);
      fill(0, 0, 0);
      text(str(pontuacao), 250, 95);

      break;
    }

  case 3: //tela conferencia
    {
   
      imageMode(CORNER);
      image(game[1], 0, 0);

      imageMode(CENTER);
      
      for (int i = 0; i < 3; i++)
      {
        if (vidas >= i+1)
        {
          image(heart[0], 1120+i*60, 70);
        } else
        {
          image(heart[1], 1120+i*60, 70);
        }
      }

     
      red = str(valorR);
      green = str(valorG);
      blue = str(valorB);

      println(tela);

      textSize(40);
      fill(255, 0, 0);
      text(red, 450, 630);

      fill(0, 255, 0);
      text(green, 750, 630);

      fill(0, 0, 255);
      text(blue, 1050, 630);

      stroke(0, 0, 0);
      strokeWeight(5);
      rectMode(CENTER);
      fill(randomR, randomG, randomB);
      rect(width/4, height/2 - 50, 250, 250);
      
      stroke(0, 0, 0);
      strokeWeight(5);
      rectMode(CENTER);
      fill(valorR, valorG, valorB);
      rect(width/4 + 700, height/2 - 50, 250, 250);


      textFont(fonte);
      textAlign(CENTER);
      textSize(80);
      if (timer < 16)
      {
        fill(255, 0, 0);
      } else
      {
        fill(0, 0, 0);
      }
      text(timerNumber, width/2, 100);

      textFont(fonte);
      textAlign(CENTER);
      textSize(36);
      fill(0, 0, 0);
      text(str(pontuacao), 250, 95);
      
      break;
      
    }

  case 4: //tela resposta certa
    {
      imageMode(CORNER);
      image(resultados[0], 0, 0);

      if (millis() - timestampResultado > 2000)
      {
        tela = 3;
        sortear = true;

        pontuacao += timer;
      }

      break;
    }

  case 5: // tela resposta errada
    {


      imageMode(CORNER);
      image(resultados[1], 0, 0);

      if (millis() - timestampResultado > 2000)
      {
        tela = 3;
        sortear = true;

        vidas--;
      }

      if (vidas == 0)
      {
        tela = 7;
        timestampResultado = millis();
      };

      break;
    }

  case 6: //tela timeup
    {
      imageMode(CORNER);
      image(resultados[2], 0, 0);

      if (millis() - timestampResultado > 2000)
      {
        tela = 3;
        sortear = true;

        vidas--;
        timer = 40;
      }

      if (vidas == 0)
      {

        tela = 7;
        timestampResultado = millis();
      };

      break;
    }

  case 7: //tela gameover
    {
      background(0);
      imageMode(CORNER);
      image(resultados[3], 0, 0);

      if (millis() - timestampResultado > 2000)
      {
        tela = 0;
        sortear = true;
      }

      break;
    }

  default:
    {
    }
  }

  //print("mouse x, y: ");
  //println(mouseX, mouseY);

  //print("resposta");
  //println(randomR, randomG, randomB);
  println(arduino.digitalRead(botao));
}
