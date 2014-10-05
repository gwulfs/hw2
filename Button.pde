
class RectButton{

  int x, y;
  int size;
  int bheight, bwidth;
  color basecolor, highlightcolor;
  color currentcolor;
  boolean over = false;
  boolean pressed = false; 
  String buttText;  

  RectButton(int ix, int iy, int isize, color icolor, color ihighlight){
    x = ix;
    y = iy;
    size = isize;
    bwidth = isize;
    bheight = isize;
    basecolor = icolor;
    highlightcolor = ihighlight;
    currentcolor = basecolor;
  }
  RectButton(int ix, int iy, int iwidth, int iheight, color icolor, color ihighlight){
    x = ix;
    y = iy;
    bwidth = iwidth;
    bheight = iheight;
    basecolor = icolor;
    highlightcolor = ihighlight;
    currentcolor = basecolor;
  }


  boolean overRect(int x, int y, int width, int height){
    if (mouseX >= x && mouseX <= x+width && 
      mouseY >= y && mouseY <= y+height) {
      return true;
    } 
    else {
      return false;
    }
  }

  boolean over(){
    if( overRect(x, y, bwidth, bheight) ) {
      over = true;
      return true;
    } 
    else {
      over = false;
      return false;
    }
  }

  void display() {
    stroke(255);
    if(over()){ fill(highlightcolor);}
    else{fill(currentcolor);}
    rect(x, y, bwidth, bheight,5);

    fill(255);
    textAlign(CENTER,CENTER);
    text(buttText,(x + bwidth/2), (y+bheight)/2);
  }

}