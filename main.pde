import java.util.Arrays; 

Parser parse;
LineGraph lgraph; 
BarChart bchart; 
PieChart pchart;
RoseChart rchart;
int modeChoice = 0; // 0 - Bar Chart, 1 - Line Graph, 3 - PieChart

RectButton toPie;
RectButton toBar;
RectButton toLine;

/*color [] colors = { #9e0142,
                    #d53e4f,
                    #f46d43,
                    #fdae61,
                    #fee08b,
                    #ffffbf,
                    #e6f598,
                    #abdda4,
                    #66c2a5,
                    #3288bd,
                    #5e4fa2
                  };*/

color [] colors = { 
                    #9D9D9D,
                    #BE2633,
                    #E06F8B,
                    #493C2B,
                    #A46422,
                    #EB8931,
                    #F7E26B,
                    #2F484E,
                    #44891A,
                    #A3CE27,
                    #1B2632,
                    #005784,
                    #31A2F2,
                    #B2DCEF
                  };



int headerHeight = 50;

String buttText = "Toggle Mode";
PFont f;   

void setup() {
  size(640, 480);
  background(255);
  f = createFont("Arial", 14, true);
  if (frame != null) {
    frame.setResizable(true);
  }
  initButtons();
  parse = new Parser("Dataset1.csv");
  bchart = new BarChart(50,50,headerHeight + 10,50);
  lgraph = new LineGraph(50,50,headerHeight + 10,50);
  pchart = new PieChart(50,50,headerHeight + 10,50);
  rchart = new RoseChart(50,50,headerHeight + 10,50);
  bchart.addvals(parse.getxs(), parse.getys(), colors);
  lgraph.addvals(parse.getxs(), parse.getys());
  pchart.addvals(parse.getxs(), parse.getys(), colors);
  rchart.addvals(parse.getxs(), parse.getRemainder(), colors);
}

void draw() {
  background(255);
  textAlign(LEFT);
  drawHeader();
  fill(0);
  if(modeChoice == 0){bchart.display();}
  else if(modeChoice == 1){lgraph.display();}
  else{pchart.display();}
}


//Renders area for legend and buttons
void drawHeader(){
  strokeWeight(0);
  fill(#d3d3d3);
  rect(0, 0, width, 50);
  line(0, 50, width, 50);
  drawButtons();
  if(modeChoice == 2){
    drawLegend();
  }
}

void drawLegend(){
  String [] categories = pchart.categories;
  color [] colarray = pchart.colarray;
  int boxsize = int((headerHeight - 10)/3);
  int rowNum;
  int colNum;
  for(int i = 0; i < categories.length; i++){
    rowNum = i % 3;
    colNum = floor(i/3);
    fill(colarray[i]);
    int xval = toPie.x + toPie.bwidth + 10 + colNum *80;
    int yval = boxsize*rowNum + 5;
    rect(xval, yval, boxsize, boxsize);
    fill(0);
    textAlign(LEFT, TOP);
    text(categories[i], xval + boxsize + 5, yval); 
  }
}

void initButtons(){
  int buttWidth = 80;
  toBar = new RectButton(10, 5, buttWidth, headerHeight - 10, #0078E7, #0C52CE);
  toBar.buttText = "Bar Graph";
  toLine = new RectButton(buttWidth + 20, 5, buttWidth, headerHeight - 10, #0078E7, #0C52CE);
  toLine.buttText = "Line Graph";
  toPie = new RectButton(2*buttWidth + 30, 5, buttWidth, headerHeight - 10, #0078E7, #0C52CE);
  toPie.buttText = "Pie Chart";

}

void drawButtons(){
  toPie.display();
  toBar.display();
  toLine.display();
}

void mousePressed() {
  if(toBar.over()){modeChoice = 0;}
  else if(toLine.over()){modeChoice = 1;}
  else if(toPie.over()){modeChoice = 2;}
}






