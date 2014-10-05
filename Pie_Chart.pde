class PieChart{

    /* Display Dimensions*/
    private int dispWidth;
    private int dispHeight;
    private int offleft, offright, offtop, offbottom;

    /* Display Variables*/
    public int strokeW = 0;

    /* Data */
    private String[] categories;
    private int[] values;
    private int total;
    private float[] angs;

    /**/
    private boolean hasOther = false;
    private int otherVal = 0;

    private boolean updateNeeded = true;
    private ArrayList <PieSlice> slices;

    public color [] colarray = null;
    public boolean inTransition = false;

    PieChart(int left, int bottom){
      offleft = left;
      offbottom = bottom;
      slices = new ArrayList<PieSlice>();
    }

    PieChart(int left, int right, int top, int bottom){
      slices = new ArrayList<PieSlice>();
      offleft = left;
      offbottom = bottom;
      offright = right;
      offtop = top;
    }
    

    // Sets pie chart values without a specified total 
    void addvals(String[] inputLabels, int[] inputValues){
      categories = inputLabels;
      values = inputValues;
      total = 0;
      for(int element: values){
          total += element;
      }
      setAngs();
    }

    // Sets pie chart values without a specified total.
    // Color array is used to set PieSlice colors
    void addvals(String[] inputLabels, int[] inputValues, color [] colors){
      colarray = colors;
      categories = inputLabels;
      values = inputValues;
      total = 0;
      for(int element: values){
          total += element;
      }
      setAngs();
    }

    // Sets pie chart values with a specified total.
    void addvals(String[] inputLabels, int[] inputValues, int inputtotal){
      if(!checkSum(inputValues, inputtotal)){
        hasOther = true;
      }
      else{
        categories = inputLabels;
        values = inputValues;
      } 
      total = inputtotal;
      setAngs();
    }

    // Sets pie chart values with a specified total.
    // Color array is used to set PieSlice colors
    void addvals(String[] inputLabels, int[] inputValues, int inputtotal, color [] colors){
      colarray = colors;
      if(!checkSum(inputValues, inputtotal)){
        hasOther = true;
      }
      else{
        categories = inputLabels;
        values = inputValues;
      } 
      total = inputtotal;
      setAngs();
    }



    //Returns true if the sum of nums is equal to total
    boolean checkSum(int[] nums, int total){
      int sum = 0;
      for(int elem : nums){
        sum += elem;
      }
      if(sum < total){
        otherVal = total - sum;
        return true;
      }
      return false;
    }


    void setAngs(){
        angs = new float[values.length];
        for(int i = 0; i < values.length; i++){
          angs[i] = float(values[i])/total;
          angs[i] *= 360;
          slices.add(new PieSlice(angs[i]));
        //  println("Value: ",values[i],"Total: ", total,"Angle: ",angs[i]);
        }
        float sum = 0;
        for(float element: angs){
          sum += element;
        }
        if(hasOther){
         // otherAng = 360 - sum;
        }
      
    }

  void updateSlices(int xleft, int xright, int ytop, int ybottom, float diameter){
    float lastAng = 0;
    PieSlice currSlice;
    for (int i=0; i< slices.size(); i++){
        currSlice = slices.get(i);
        currSlice.x = (xleft+xright)/2;
        currSlice.y = (ytop+ybottom)/2;
        currSlice.diameter = diameter;
        currSlice.rad = radians(angs[i]);
        currSlice.radOffset = lastAng;
        if(colarray != null){
          currSlice.col = colarray[i];
        }
        else{currSlice.col = color(0);}
        lastAng += radians(angs[i]);
    }
  }

  void displaySlices(){
     PieSlice currSlice;
     if(angs != null){
      for (int i=0; i< slices.size(); i++){
        currSlice = slices.get(i);
        currSlice.display();  
      }
    }  
  }


  void display(){
    int ybottom = height - offbottom;
    int xleft = offleft;
    int ytop = offtop;
    int xright = width - offright;
    dispWidth = xright - xleft;
    dispHeight = ybottom - ytop;

    int skinnier = (dispWidth < dispHeight) ? dispWidth : dispHeight;
    println(dispWidth, dispHeight);
    float diameter = skinnier;

    if(updateNeeded){
      updateSlices(xleft, xright, ytop, ybottom, diameter);
    }
    strokeWeight(strokeW);
    displaySlices();  
  }

}//



