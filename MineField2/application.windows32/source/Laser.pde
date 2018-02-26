class Laser{
 int x;
 int y;
 int speed = 10;
 
 boolean laserOn = false;
 
 void fire(int shipX, int shipY){
  x = shipX;
  y = shipY;
  laserOn = true;
 }
 
 void drawLaser(){
  if(laserOn){
    fill(255,0,0);
    ellipse(x,y+7,7,10);
    fill(255,255,255);
    ellipse(x,y,5,5);
  }
 }
  
 void moveLaser(){
   if(laserOn){
     y -= speed; 
     if(y < -10){
      laserOn = false; 
     }
   }
 }
 
 boolean coversPoint(int testX, int testY, int testW){
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