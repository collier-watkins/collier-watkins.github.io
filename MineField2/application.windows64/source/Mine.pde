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
 void drawMine(){
   fill(150,150,150);
   rectMode(RADIUS);
   rect(x,y,w,w);
   fill(255,0,0);
   rect(x,y,5,5);
 }
 
 void moveMine(){
  if(x <= 0 || x >= width){  //If the mine hits one of the edges of the window
    speed = speed * (-1);  //Change its direction
  }
  x = x + speed;
 }
 
 void blowupAnim(){  //Functio n used to make a sort of animation of the mine exploding
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