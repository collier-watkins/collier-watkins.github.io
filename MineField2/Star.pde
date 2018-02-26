class Star{
  int x;
  int y;
  int r = 5;
  int speed = 5;
  
  void drawStar(){
   ellipse(x,y,r,r); 
  }
  
  void moveStar(){
   if(y < height)
     y += speed;
    else
     y = -5;
  }
  
}