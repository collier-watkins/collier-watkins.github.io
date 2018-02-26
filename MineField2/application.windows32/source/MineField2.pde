/* @pjs preload="explosion.mp3","TIE-Fire.mp3" */

import processing.sound.*;

Player p = new Player();

int starNum = 15;

Mine[] field = new Mine[10];

Star[] stars = new Star[starNum];

boolean win;

int currentLevel;

boolean wPressed;
boolean aPressed;
boolean sPressed;
boolean dPressed;
boolean spacePressed;

SoundFile backgroundMusic;
SoundFile explosionSound;
SoundFile laserSound;

void setup(){
  
  size(500,600); 
  frameRate(60);
  
  p.x = width/2;
  p.y = 400;
  
  //The following code makes new mines in the field[] array and gives them their default locations.
  field[0] = new Mine(1,50);
  field[1] = new Mine(499,75);
  field[2] = new Mine(1,100);
  field[3] = new Mine(499,125);
  field[4] = new Mine(300,150);
  field[5] = new Mine(499,300);
  field[6] = new Mine(300,200);
  field[7] = new Mine(1,225);
  field[8] = new Mine(499,250);
  field[9] = new Mine(1,275);
   
  // The following code makes new stars in the stars[] array and uses randon() to give them starting locations
  for(int i = 0; i < starNum; i++){
   stars[i] = new Star(); 
   stars[i].x = int(random(0,width));
   stars[i].y = int(random(0,height));
  }
  
  
  currentLevel = 0;
   
  win = false;
  
  /* // music
  backgroundMusic = new SoundFile(this, "BackInBlack.mp3");
  backgroundMusic.amp(0.25);
  backgroundMusic.loop();
  */
  
  explosionSound = new SoundFile(this, "explosion.mp3");
  laserSound = new SoundFile(this, "TIE-Fire.mp3");
}


//Everything in the draw() method happens once per "frame" of the game. This game runs at 60fps
void draw(){

  if(currentLevel == 0){  //STARTSCREEN STUFF: Using the boolean, we can choose to draw the start screen, or do everything else like normal.
    startScreenDraw();
  }
  else if(currentLevel == 1){  //LEVEL 1 STUFF: The normal stuff from the game's draw() method goes inside the else.
    level1();
  }

  
}


void startScreenDraw(){
  background(0);
  textSize(32);
  text("Welcome to MineField!",50,50);
  textSize(22);
  text("Navigate your ship to ",50,height/2 - 100);
  text("  the top of the screen!",50,height/2 - 50);
  text("Press any key to play!",50,height/2);
  
  
  if(keyPressed)  // Any key is pressed
     currentLevel = 1;
}

void level1(){  //Functions for specific levels allow for scalable design
  background(0);
  for(int i = 0; i < starNum; i++){
    stars[i].moveStar();
    stars[i].drawStar();
  }

  mineMoveCheckDraw();
    
 if(p.dead){  //If player is dead
    textSize(16);
    text("Game Over.",10,400);
  }
  else{
    p.movePlayer();
    p.drawPlayer();  //If the player is not dead, then we draw the player
  }
  
  //Draw the white "finish line"
  fill(#ffffff);
  rectMode(CORNER);
  rect(0,10,width,15);

  if(p.y <= 15) win = true;    //If the player's y coordinate is above the bottom of the white line
  
  if(win) {  //If we've won
    textSize(50);
    text("You won!!!",50,400);
  }
  
  println(frameRate);
}



void keyPressed(){
 if(key == 'a' || (key == CODED && keyCode == LEFT))
   aPressed = true;
 else if(key == 'd' || (key == CODED && keyCode == RIGHT))
   dPressed = true;
 else if(key == 's' || (key == CODED && keyCode == DOWN))
   sPressed = true;
 else if(key == 'w' || (key == CODED && keyCode == UP))
   wPressed = true;
 else if(key == ' '){
   spacePressed = true; 
 }
}
void keyReleased() {
   if(key == 'a' || (key == CODED && keyCode == LEFT))
     aPressed = false;
   else if(key == 'd' || (key == CODED && keyCode == RIGHT))
     dPressed = false;
   else if(key == 's' || (key == CODED && keyCode == DOWN))
     sPressed = false;
   else if(key == 'w' || (key == CODED && keyCode == UP))
     wPressed = false;
   else if(key == ' ')
     spacePressed = false;
}

// Supporting Methods the game uses 

void mineMoveCheckDraw(){  //For every mine in the field[] array, check to see if its point is covered by the player
  for(int i = 0; i < field.length; i++){     
    if(!field[i].blownup){
       field[i].moveMine();        //Move the mine with its built-in move() method.
       if(p.coversPoint(field[i].x,field[i].y, field[i].w)){  //If the player does cover up the mine's point
         field[i].blowupAnim();   // set the mine to blown-up
         explosionSound.play();
         p.dead = true;  //set the player to dead
       }
       if(p.laser.coversPoint(field[i].x,field[i].y, field[i].w)){  //If the player's laser does cover up the mine's point
        field[i].blowupAnim();   // set the mine to blown-up
        explosionSound.play();
        p.laser.laserOn = false;  //set the laser to off
       }
       
       field[i].drawMine();       //Draw the mine on the screen using its built-in draw() method
    }
  }
}