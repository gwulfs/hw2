

class RoseChart{
	
	/* Display Dimensions*/
    private int dispWidth;
    private int dispHeight;
    private int offleft, offright, offtop, offbottom;

    /* Display Variables*/
    public int strokeW = 0;

    /* Data */
    private String[] categories;
    private float[][] values;
    private float[] totals;
    private float totalsSum;
    private float[] angs;

    /**/
    // private boolean hasOther = false;
    // private int otherVal = 0;

    private boolean updateNeeded = true;
    private ArrayList <RoseSlice> slices;

    public color [] colarray = null;



    RoseChart(int left, int right, int top, int bottom){
      slices = new ArrayList<RoseSlice>();
      offleft = left;
      offbottom = bottom;
      offright = right;
      offtop = top;
    }

    public void addvals(String[] inputLabels, float[][] inputValues, color [] colors){
      colarray = colors;
      categories = inputLabels;
      values = inputValues;
      println("1");
      totals = getTotals(inputValues);
      println("2");
      totalsSum = getTotal(totals);
      println("3");
      initSlices();
    }

    private float getTotal(float[] nums){
    	float sum = 0;
		for(int j = 0; j < nums.length; j++){
			sum += nums[j];
		}
    	return sum;
    }

    private float[] getTotals(float[][] nums){
    	float [] colSums = new float[nums[0].length];
    	float sum;
    	float [] coli;
    	for(int i = 0; i < nums[0].length; i++){
    		//coli = nums[i];
   		    sum = 0;
    		for(int j = 0; j < nums.length; j++){
    			sum += nums[j][i];
    		}
    		colSums[i] = sum;
    	}
    	return colSums;
    }


    private void initSlices(){
    	float ang = 360/categories.length;
    	float rad = radians(ang);
    	slices.clear();
    	for(int i = 0; i < categories.length; i++){
    		println("Swag");
    		RoseSlice slice = new RoseSlice(rad);
    		slices.add(slice);
    	}
    }


    void updateSlices(int xleft, int xright, int ytop, int ybottom, float diameter){
	    RoseSlice currSlice;
	    int maxtotal = 0;
	    int maxindex = 0;
	    for(int j = 0; j < totals.length; j++){
	    	if(totals[j] > maxtotal){maxindex = j;}
	    }
	    for (int i=0; i< slices.size(); i++){
	        currSlice = slices.get(i);
	        currSlice.x = (xleft+xright)/2;
	        currSlice.y = (ytop+ybottom)/2;
             
	        float totalRatio = totals[i]/maxtotal;
	        currSlice.diameter = diameter * totalRatio;
			//currSlice.rad = radians(angs[i]);
	        currSlice.radOffset = i * currSlice.rad;
	        if(colarray != null){
	          currSlice.setColors(colarray);
	        }
	    }
    }

    void displaySlices(){
    	for(int i = 0; i < slices.size(); i++){
    		println("yoyo");
    		slices.get(i).display();
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
	   // println(dispWidth, dispHeight);
	    float diameter = skinnier;

	    if(updateNeeded){
	      updateSlices(xleft, xright, ytop, ybottom, diameter);
	    }
	    strokeWeight(strokeW);
	    displaySlices();  
  	}




}//




