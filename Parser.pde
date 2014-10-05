
class Parser {
  private String[] xs;
  private int[] ys;
  private String ylabel;
  private String xlabel;
  private String [] lines;

  Parser(String filename) {
    lines = loadStrings(filename);
    String[] row = split(lines[0], ",");
    xs = new String[lines.length - 1];
    ys = new int[lines.length - 1];
    xlabel = trim(row[0]);
    ylabel = trim(row[1]);
    for (int i = 1; i < lines.length; i++) {
      row = split(lines[i], ",");
      xs[i - 1] = trim(row[0]);
      ys[i - 1] = int(row[1]);
    }
  }

  String[] getxs() { 
    return xs;
  }

  int[] getys() { 
    return ys;
  }

  float[][] getRemainder(){
    String[] row = split(lines[0], ",");
    println(lines.length);
    float[][] values = new float[row.length][lines.length];
    for(int i = 1; i < lines.length; i++){  
      row = split(lines[i], ",");
      for(int j = 0; j < row.length; j++){
        values[j][i] = float(row[j]);
      }
    }
    return values;
  }

  String getxlabel() {
    return xlabel;
  }
  String getylabel() {
    return ylabel;
  }
}//

