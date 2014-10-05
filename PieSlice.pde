class PieSlice{
	
	public int x, y;
	public float diameter, rad,radOffset;
	public color col;
	public String label;
    public float value;

	PieSlice(float rad_){
		rad = rad_;
	}

	void display(){
		fill(col);
		arc(x,y, diameter, diameter, radOffset, radOffset+rad);
	}
}