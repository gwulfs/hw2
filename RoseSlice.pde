
class RoseSlice{
	
	public int x, y;
	public float total;
	public float diameter, rad,radOffset;
	public color [] col;
	public String label;
    public float [] values;
    private boolean isSorted = false;
    private SlicePortion [] portions = null;

	RoseSlice(float rad_){
		rad = rad_;
	}

	public void setValues(float[] ivalues){
		values = ivalues;
		total = 0;
		portions = new SlicePortion[values.length];
		for(int i = 0; i < portions.length; i++){
			portions[i] = new SlicePortion();
			portions[i].val= values[i];
			portions[i].col= col[i];
			total += values[i];
		}
	}	

	public void setColors(color [] icolors){
		colors = icolors;
	}

	void display(){
		if(portions!= null){
		for(int i = 0; i < portions.length; i++){
			println(portions[i].col);
			fill(portions[i].col);
			float radius = diameter * (portions[i].val/total);
			arc(x,y, diameter, diameter, radOffset, radOffset+rad);
		}
		}
		//fill(col);
		//arc(x,y, diameter, diameter, radOffset, radOffset+rad);
	}
}