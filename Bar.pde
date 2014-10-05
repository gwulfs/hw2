
class Bar{
    public String label;
    public float value;

    public float x, y;
    public float barWidth, barHeight;
    public color col;

    Bar(String inputLabel, float inputValue){
        label = inputLabel;
        value = inputValue;
        barWidth = 10;
    }

    boolean contains(float xloc, float yloc){
       if(xloc >= x && xloc <= (x + barWidth) ){
          if(yloc > y && yloc < (y + barHeight)){
             return true;
          }
       }
       return false;
    }
    
    void display(){
        boolean isHover = false;
        if(contains(mouseX, mouseY)){
          isHover= true;
          fill(255, 204, 0); 
        }
        fill(col);
        rect(x, y, barWidth, barHeight);
        if(isHover){
          fill(255);
          String coords = " (" + label + "," + int(value) +") ";
          float strw = textWidth(coords);
          rect(mouseX, mouseY - f.getSize(), strw, f.getSize());
          fill(0);
          textAlign(LEFT, TOP);
          text(coords, mouseX, mouseY - f.getSize()); 
        }
        fill(0);
    }
};
