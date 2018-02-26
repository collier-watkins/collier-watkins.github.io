import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import processing.sound.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class MineField2 extends PApplet {

/* @pjs preload="explosion.mp3","TIE-Fire.mp3" */



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

public void setup(){
  
   
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
   stars[i].x = PApplet.parseInt(random(0,width));
   stars[i].y = PApplet.parseInt(random(0,height));
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
public void draw(){

  if(currentLevel == 0){  //STARTSCREEN STUFF: Using the boolean, we can choose to draw the start screen, or do everything else like normal.
    startScreenDraw();
  }
  else if(currentLevel == 1){  //LEVEL 1 STUFF: The normal stuff from the game's draw() method goes inside the else.
    level1();
  }

  
}


public void startScreenDraw(){
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

public void level1(){  //Functions for specific levels allow for scalable design
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
  fill(0xffffffff);
  rectMode(CORNER);
  rect(0,10,width,15);

  if(p.y <= 15) win = true;    //If the player's y coordinate is above the bottom of the white line
  
  if(win) {  //If we've won
    textSize(50);
    text("You won!!!",50,400);
  }
  
  println(frameRate);
}



public void keyPressed(){
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
public void keyReleased() {
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

public void mineMoveCheckDraw(){  //For every mine in the field[] array, check to see if its point is covered by the player
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
class Laser{
 int x;
 int y;
 int speed = 10;
 
 boolean laserOn = false;
 
 public void fire(int shipX, int shipY){
  x = shipX;
  y = shipY;
  laserOn = true;
 }
 
 public void drawLaser(){
  if(laserOn){
    fill(255,0,0);
    ellipse(x,y+7,7,10);
    fill(255,255,255);
    ellipse(x,y,5,5);
  }
 }
  
 public void moveLaser(){
   if(laserOn){
     y -= speed; 
     if(y < -10){
      laserOn = false; 
     }
   }
 }
 
 public boolean coversPoint(int testX, int testY, int testW){
  if(laserOn){
    if(testX + testW/2 >= x-5 && testX - testW/2 <= x+5){
     if(testY + testW/2 >= y-5 && testY - testW/2 <= y+5){
       return true;
     }
    }
  }
  return false;
 }
 
}
class Mine{
 int x;
 int y;
 int w = 10;
 
 int speed = 5;
 
 boolean blownup = false;
 
 int blowupFrame = 30;

 
 //Mine's constructor allows us to input a coordinate when the mine is created
 Mine(int locX, int locY){
  x = locX;
  y = locY;
 }
 
 //draw method just for the mines
 public void drawMine(){
   fill(150,150,150);
   rectMode(RADIUS);
   rect(x,y,w,w);
   fill(255,0,0);
   rect(x,y,5,5);
 }
 
 public void moveMine(){
  if(x <= 0 || x >= width){  //If the mine hits one of the edges of the window
    speed = speed * (-1);  //Change its direction
  }
  x = x + speed;
 }
 
 public void blowupAnim(){  //Functio n used to make a sort of animation of the mine exploding
  if(blowupFrame >= 14){
   fill(255,255,0);
   ellipse(x,y,25,25);
   blownup = true;
   blowupFrame--;
   blowupAnim();
   return;
  }
  else if(blowupFrame >= 0){
   fill(255,130,0);
   ellipse(x,y,15,15);
   blowupFrame--;
   blowupAnim();
   return;
  }
 }
 
 
}
class Player{
 int x;
 int y;
 int w = 16;  //Width. Even numbers are best
 
 boolean dead = false;
 
 int x_speed = 0;
 int y_speed = 0;
 
 Laser laser = new Laser();

 public void movePlayer(){
   x_speed = 0;
   y_speed = 0;
   
   if(wPressed){
     y_speed = -5; 
     fill(237, 89, 26);
     triangle(x,y+w/3,x-w/2,y+w+w/2,x+w/2,y+w+w/2);
   }
   if(aPressed){
     if(x > 0)
       x_speed = -5; 
   }
   if(sPressed){
     if(y < height)
       y_speed = 5; 
   }
   if(dPressed){
     if(x < width)
       x_speed = 5; 
   }
   if(spacePressed){
     if(laser.laserOn == false){
        laserSound.play();
        laser.fire(x,y);
     }
   }
  
   x += x_speed;
   y += y_speed;
   
   laser.moveLaser();
 }

 //Checks to see if a point is covered by the player's square
 public boolean coversPoint(int X, int Y, int W){
  if((X - W/2 <= x+w && X + W/2 >= x-w) && (Y + W/2 >= y-w && Y - W/2 <= y+w)){
      return true; 
  }
  else
    return false;
 }
 
 //Draw method just for the player. I can make the player look however I want here.
 public void drawPlayer(){
   laser.drawLaser();
   fill(150,150,150);
   rectMode(CENTER);
   rect(x,y,w,w);
   fill(146, 207, 229);
   triangle(x,y-w-w/4,x-w/2,y-w/2,x+w/2,y-w/2);  //nose cone
   triangle(x-w/2,y-w/2,x-w/2,y+w/2,x-w-w/4,y+w);  //Left wing
   triangle(x+w/2,y-w/2,x+w/2,y+w/2,x+w+w/4,y+w);  //Right wing
   
   fill(255,0,0);
   ellipse(x,y,w/2,w/2);
 }
 
  
}
class Star{
  int x;
  int y;
  int r = 5;
  int speed = 5;
  
  public void drawStar(){
   ellipse(x,y,r,r); 
  }
  
  public void moveStar(){
   if(y < height)
     y += speed;
    else
     y = -5;
  }
  
}
  public void settings() {  size(500,600); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "MineField2" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
