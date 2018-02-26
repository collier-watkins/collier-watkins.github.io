

void setup(){
 size(500,500); 
 noCursor();
  
}

void draw(){
 background(0);
 stroke(255);
  
 line(mouseX,0,mouseX,height);
 line(0,mouseY,width,mouseY);
 
}