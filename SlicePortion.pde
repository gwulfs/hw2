
import java.util.Comparator;

class SlicePortion implements Comparable{
    
    color col;
    float val;
    int rad;
    
    SlicePortion(){
    }
    public int compareTo(Object obj){
    	float val2 = ((SlicePortion)obj).val;
    	int cmp = val > val2 ? +1 : val < val2 ? -1 : 0;
    	return cmp;
	}
}