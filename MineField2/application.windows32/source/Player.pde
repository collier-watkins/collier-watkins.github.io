class Player{
 int x;
 int y;
 int w = 16;  //Width. Even numbers are best
 
 boolean dead = false;
 
 int x_speed = 0;
 int y_speed = 0;
 
 Laser laser = new Laser();

 void movePlayer(){
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
 boolean coversPoint(int X, int Y, int W){
  if((X - W/2 <= x+w && X + W/2 >= x-w) && (Y + W/2 >= y-w && Y - W/2 <= y+w)){
      return true; 
  }
  else
    return false;
 }
 
 //Draw method just for the player. I can make the player look however I want here.
 void drawPlayer(){
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