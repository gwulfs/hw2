
class BarChart{
    public ArrayList<Bar> bars;

    public String xAxis = "L1";
    public String yAxis = "L2";

    public int dispWidth;
    public int dispHeight;
    private int maxY = 0;
    
    private int offleft, offbottom;
    private int offright, offtop;

    private int yticks = 10;
    private int xticks;
    private float ytickrange;
    private float yupper;

    public color [] colarray = null;


    BarChart(int left, int bottom){
      bars = new ArrayList<Bar>();
      offleft = left;
      offbottom = bottom;
      offright = left;
      offtop = bottom;
    }

    BarChart(int left, int right, int top, int bottom){
      bars = new ArrayList<Bar>();
      offleft = left;
      offbottom = bottom;
      offright = right;
      offtop = top;
    }
    
    void addvals(String[] inputLabels, int[] inputValues){
        for(int i = 0; i < inputLabels.length; i += 1){
            Bar newBar = new Bar(inputLabels[i], inputValues[i]);
            if(colarray != null){
              newBar.col = colarray[i];
            }
            else{ newBar.col = color(0);}
            bars.add(newBar);
            if(maxY < inputValues[i]){
                maxY = inputValues[i];
            }
        }
        setYaxisbounds();
        xticks = inputLabels.length;
        dispWidth = width;
        dispHeight = height;
    }
    


    void addvals(String[] inputLabels, int[] inputValues, color [] colors){
        colarray = colors;
        for(int i = 0; i < inputLabels.length; i += 1){
            Bar newBar = new Bar(inputLabels[i], inputValues[i]);
            if(colarray != null){
              newBar.col = colarray[i];
            }
            else{ newBar.col = color(0);}
            bars.add(newBar);
            if(maxY < inputValues[i]){
                maxY = inputValues[i];
            }
        }
        setYaxisbounds();
        xticks = inputLabels.length;
        dispWidth = width;
        dispHeight = height;
    }
    
    float getTickRange(float range, float numticks) {
      float unroundedticks = range/(numticks - 1);
      float x = ceil((log(unroundedticks)/log(10))-1);
      float pow10x = pow(10, x);
      float roundedTickRange = ceil(unroundedticks / pow10x) * pow10x;
      //float unroundedticks = range/(numticks - 1);
      // float roundedTickRange = unroundedticks;
      return roundedTickRange;
    }
    
    void setYaxisbounds(){
      int minY = 0;
      int yrange = maxY - minY;
      ytickrange = getTickRange(yrange, yticks);  
      yupper = ytickrange * yticks;
    }
    
    
    void drawVerticals(int xleft, int xright, int ybottom, int ytop) {
      for (int j = 0; j < bars.size(); j++) {
        float xpos = ((xright - xleft)/bars.size()) * (j);
        line(xleft + xpos, ybottom, xleft + xpos, ytop);
        textAlign(CENTER);
        text(bars.get(j).label, xleft + xpos +(((xright - xleft)/bars.size())/2), (height + ybottom)/2);
      }
   
    }

  //Draws the horizontal lines of the grid
  void drawHorizontals(int xleft, int xright, int ybottom, int ytop) {
    for (int j = 0; j <= yticks; j++) {
      float value = j * ytickrange;
      float ypos = (ybottom - ytop) * (value/yupper);

      line(xleft, ybottom - ypos, xright, ybottom - ypos);
      float textw = textWidth(str(value));
      textAlign(CENTER,CENTER);
      text(str(value), xleft - textw/2 - 5, ybottom - ypos);
    }
  }
  
  void drawData(int xleft, int xright, int ybottom, int ytop, float barWidth) {
    for (int i = 0; i < bars.size(); i++) {
      bars.get(i).x = (((xright - xleft)/bars.size()) * (i)) + xleft;
      bars.get(i).y = ybottom - ((ybottom - ytop) * (bars.get(i).value/yupper));
      bars.get(i).barHeight = ybottom - bars.get(i).y;
      bars.get(i).barWidth = barWidth;
    }
    for (int j = bars.size() - 1; j >= 0; j--) {
       bars.get(j).display();
    }
  }
  
  void writeLabels(){
    text(xAxis, width/2, height - 5 - f.getSize());
    textAlign(CENTER);
    text(yAxis, 10, height/2);

  }
  void display(){
        int ybottom = height - offbottom;
        int xleft = offleft;
        int ytop = offtop;
        int xright = width - offright;
        stroke(153);
        strokeWeight(2);
        //X-Axis
        line(xleft, ybottom, xright, ybottom);
        //Y-Axis
        line(xleft, ybottom, xleft, ytop);

        strokeWeight(1);
        drawVerticals(xleft, xright, ybottom, ytop);
        drawHorizontals(xleft, xright, ybottom, ytop);
        writeLabels();
        
        float barWidth = ((xright - xleft)/bars.size()) * 0.5;
        drawData(xleft, xright, ybottom, ytop, barWidth);
    }
};



