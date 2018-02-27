

def setup():
    size(500,500)
    noCursor()
    
def draw():
    background(0)
    stroke(0,255,0)
    line(0,mouseY,width,mouseY)
    line(mouseX,0,mouseX,height)
    