
class Star{
  int x = int(random(0,width));
  int y = int(random(0,height));
  int speed = int(random(3,6));

 void move(){
  if(y < height){
    y += speed;
  }
  else{
   y = -10;
   x = int(random(0,width));
  }
 }
 
 void draw(){
  fill(255);
  ellipse(x,y,5,5);
 }
  
}

Star stars[] = new Star[25];

void setup(){
 size(500,500);
 for(int i = 0; i < stars.length; i++){
  stars[i] = new Star(); 
 }
}

void draw(){
  background(0);
 for(int i = 0; i < stars.length; i++){
  stars[i].move();
  stars[i].draw();
 }
  
  
}