import java.util.Comparator; 

class PointComparator implements Comparator {
 int compare(Object object1, Object object2){
   Data_Point point1 = (Data_Point) object1;
   Data_Point point2 = (Data_Point) object2;
   float val1 = point1.x;
   float val2 = point2.x;
   return int(val1 - val2);
 }
}//


class Data_Point {
    public float x;
    public String xstr;
    public color col = #000000;
    public float y;
    public float xpos;
    public float ypos;
    public float diam;
    
    private boolean isxstr;
     private St st;
    private boolean inTransition = false;
    
    Data_Point(float x_val, float y_val){
      isxstr = false;
      x = x_val;
      y = y_val;
      diam = 1;
    } 
    
    Data_Point(String x_val, float y_val){
      //x = x_val;
      isxstr = true;
      xstr = x_val;
      y = y_val;
      diam = 1;
    } 
    
    boolean contains(float xloc, float yloc){
      float val1 = pow((xloc - xpos),2)/pow(diam,2);
      float val2 = pow((yloc - ypos),2)/pow(diam,2);
      if((val1 + val2)<= 1){
        return true;
      }
      else{
        return false;
      }
    }

    void transition(Shape next, float timeDelay){
      inTransition = true;
      st = new St(ez_ellipse(xpos, ypos,diam,diam,col));
      next.rotation = random(PI, -PI);
      st.then(next, timeDelay);
    }

    boolean isTrans(){
      float yo = st.gett();
      if(yo < 1){return true;}
      else{return false;}
    }
    float transVal(){
      return st.gett();
    }

    void stopTransition(){
      inTransition = false;
    }

    
    void display(){
      if(!inTransition){
        fill(col);
        if(contains(mouseX, mouseY)){
            fill(255);
            String xval = isxstr ? xstr:str(x);
            String coords = "(" + xval + "," + y+")";
            float strw = textWidth(coords);
            rect(xpos + diam, ypos - diam - 10, strw, f.getSize());
            fill(0);
            textAlign(LEFT, TOP);
            text(coords, xpos + diam, ypos - diam - 10);
            fill(255, 204, 0);
        }
        ellipseMode(CENTER);
        ellipse(xpos, ypos,diam,diam);
      }
      else{
        st.draw();
      }
    }
}//
