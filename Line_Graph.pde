
class LineGraph {
  boolean isCatData = false; 
  String[] categories;
  int offleft, offright, offtop, offbottom;
  Data_Point[] points;
  float xlower, xupper, ylower, yupper;
  float xtickrange, ytickrange;
  int xticks = 10;
  int yticks = 10;
  String xAxis = "L1";
  String yAxis = "L2";
  

  LineGraph(int left, int bottom) {
    offleft = left;
    offbottom = bottom;
  }

  LineGraph(int left, int right, int top, int bottom){
      offleft = left;
      offbottom = bottom;
      offright = right;
      offtop = top;
  }

  //Used for data where both x and y values are integers (Non-Categorical Data)
  void addvals(int[] xs, int[] ys) {
    isCatData = false;
    points = new Data_Point[xs.length];
    for(int i = 0; i < points.length; i++){
      points[i] = new Data_Point(xs[i], ys[i]);
    }
    Arrays.sort(points, new PointComparator());
    setXaxisbounds(xs);
    setYaxisbounds(ys);
  }

  
  //Used for data where x values are strings and y values are integers (Categorical Data)
  void addvals(String[] xs, int[] ys){
    isCatData = true;
    categories = xs;
    points = new Data_Point[ys.length];
    for(int i = 0; i < points.length; i++){
      points[i] = new Data_Point(xs[i], ys[i]);
    }
    int[] yssorted = sort(ys);
    setYaxisbounds(ys);
    setXaxisbounds(xs);
  }
 
 
  void setYaxisbounds(int[] ys){
    int[] yssorted = sort(ys);
    int maxy = yssorted[yssorted.length - 1];
  
    int miny = 0;
    ylower = 0;
    int yrange = maxy - miny;
    ytickrange = getTickRange(yrange, yticks);
    
    yupper = ytickrange * yticks;
  }
 
  void setXaxisbounds(int[] xs){
    int[] xssorted = sort(xs);
    int maxx = xssorted[xssorted.length -1];
    int minx = 0;
    xlower = 0;
    int xrange = maxx - minx;
    xtickrange = getTickRange(xrange, xticks);
    xupper = xtickrange * xticks;
  }
  
  void setXaxisbounds(String[] xs){
    xticks = xs.length;
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


  //Draws the vertical lines of the grid
  void drawVerticals(int xleft, int xright, int ybottom, int ytop) {
    if(!isCatData){
      for (int i = 0; i <= xticks; i++) {
        float value = i * xtickrange;
        float xpos = (xright - xleft) * (value/xupper);
        line(xleft + xpos, ybottom, xleft + xpos, ytop);
        text(str(value), xleft + xpos, (height + ybottom)/2);
      }
    }
    else{
      for (int j = 0; j < categories.length; j++) {
        float xpos = ((xright - xleft)/categories.length) * (j);
        line(xleft + xpos, ybottom, xleft + xpos, ytop);
        text(categories[j], xleft + xpos, (height + ybottom)/2);
      }
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
      text(str(value), xleft - textw - 5, ybottom - ypos);
    }
  }

  void drawData(int xleft, int xright, int ybottom, int ytop, float pointWeight, float lineWeight) {
    float xpos_last = -1;
    float ypos_last = -1;
    for (int i = 0; i < points.length; i++) {
      if(!isCatData){
        points[i].xpos = ((xright - xleft) * (points[i].x/xupper)) + xleft;
      }
      else{
        points[i].xpos = (((xright - xleft)/categories.length) * (i)) + xleft;
      }
      points[i].ypos = ybottom - ((ybottom - ytop) * (points[i].y/yupper));
      if ( xpos_last != -1 && ypos_last != -1) {
        strokeWeight(lineWeight);
        line( points[i].xpos, points[i].ypos, xpos_last, ypos_last);
      }
      xpos_last = points[i].xpos;
      ypos_last = points[i].ypos;
    }
    for(Data_Point i: points){
      i.diam = pointWeight;
      i.display();
    }
    
  }
  
  void drawHoverData(float xloc, float yloc){
      for (int i = 0; i < points.length; i++) {
         if(false){//points[i].contains(xloc,yloc)){
          fill(255);
          String coords = "(" + points[i].x + "," + points[i].y+")";
          float strw = textWidth(coords);
          rect(points[i].xpos + points[i].diam, points[i].ypos - points[i].diam - 10, strw, f.getSize());
          fill(0);
          textAlign(LEFT, TOP);
          text(coords, points[i].xpos + points[i].diam, points[i].ypos - points[i].diam - 10);
          fill(255, 204, 0);
         } 
      }
  }

  void writeLabels(){
    text(xAxis, width/2, height - 5 - f.getSize());
    textAlign(CENTER);
    text(yAxis, 10, height/2);
  }
  
  void display() {
    //int ybottom = height - offbottom;
    //int ytop = offbottom/2;
    //int xleft = offleft;
    //int xright = int(width - (offleft/1.5));
    int ybottom = height - offbottom;
    int xleft = offleft;

    //int ytop = offbottom/2;
    int ytop = offtop;

    //int xright = int(width - (offleft/1.5));
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
    
    drawData(xleft, xright, ybottom, ytop, 4, 1);
    
    drawHoverData(mouseX, mouseY);
  }
  
}//

