import processing.pdf.*;

Table table;
String planetNames[] = {"mercury","venus","mars","jupiter","saturn","uranus","neptune","pluto"};
static int colors[] = {
  129,127,130,  // mercury
  239,194,107, // venus
  172,81,40, // mars
  187, 150, 110, // jupiter
  234, 208, 153,  // saturn
  149,188,198,  // uranus
  98,119,226,  // neptune
  169,149,146};  // pluto
float moonEventAngles[] = {0.0, 1.570796326794897, 3.141592653589793, 4.71238898038469};
String moonEventDescriptions[] = {"New", "First Quarter", "Full", "Third Quarter" };

int year[];
int month[];
int day[];
int hour[];
float sunAngle[];
float moonAngle[];
float planetAngle[][];
//String zodiacs[];
float moonPhase[];
float daylightHours[];

void setup(){
  size(130, 700, P3D);
  noLoop();
  importCSV();
  beginRaw(PDF, "output.pdf");
  drawCalendar();
  endRaw();
}

void importCSV(){
  table = loadTable("../../2019.csv", "header");
  
  year = new int[table.getRowCount()];
  month = new int[table.getRowCount()];
  day = new int[table.getRowCount()];
  hour = new int[table.getRowCount()];
  sunAngle = new float[table.getRowCount()];
  moonAngle = new float[table.getRowCount()];
  planetAngle = new float[table.getRowCount()][planetNames.length];
  //zodiacs = new String[table.getRowCount()];
  moonPhase = new float[table.getRowCount()];
  daylightHours = new float[table.getRowCount()];

  int i = 0;
  for (TableRow row : table.rows()) {
    //String zodiac = row.getString("zodiac");
    year[i] = row.getInt("year");
    month[i] = row.getInt("month");
    day[i] = row.getInt("day");
    hour[i] = row.getInt("hour");
    moonAngle[i] = row.getFloat("moonLongitude") * PI/180;
    sunAngle[i] = row.getFloat("sunLongitude") * PI/180;
    daylightHours[i] = row.getFloat("daylight");
    moonPhase[i] = row.getFloat("moonPhase") * PI/180;
    for(int p = 0; p < planetNames.length; p++){
      planetAngle[i][p] = row.getFloat(planetNames[p]+"Longitude") * PI / 180;
    }
    i++;
  }
}

void moon(float x, float y, float r, float phase){
  float ph1 = 1;
  float ph2 = -1;
  if(phase < PI){ ph2 = cos(phase); }
  if(phase > PI){ ph1 = -cos(phase); }
  //fill(200);
  //noStroke();
  stroke(200);
  noFill();
  pushMatrix();
  translate(x,y);
  rotate(PI*0.2);
  beginShape();
  for(float a = 0; a < PI; a+=PI/24.0){  vertex(r*sin(a)*ph1, r*cos(a));  }
  for(float a = PI; a > 0; a-=PI/24.0){  vertex(r*sin(a)*ph2, r*cos(a));  }
  endShape();
  popMatrix();
}

void drawCalendar(){
  fill(40);
  noStroke();
  rect(0, 0, width, height);
  
  int pad = 20;

  // moon
  int dayCount = 2;
  for(int i = 0; i < table.getRowCount(); i++){
    if(hour[i] == 0){
      int week = int(float(dayCount)/7.0);
      float x = (dayCount%7) / 7.0 * (width-pad*2) + pad;
      float y = week / 52.0 * (height-pad*2) + pad;
      moon(x, y, 4, moonPhase[i]);
      
      //if(day[i] == 1){
      //  stroke(200);
      //  strokeWeight(0.33);
      //  float lineH = 1.0 / 52.0 * (height-pad*2);
      //  float lineX = ((dayCount-1)%7 + dayCount%7)*0.5 / 7.0 * (width-pad*2) + pad;
      //  line(lineX, y - lineH*.5, lineX, y + lineH*0.5);
      //  line(pad*0.5, y + lineH*.5, lineX, y + lineH*0.5);
      //  line(lineX, y - lineH*.5, width - (1/7.0 * (width-pad*2)) - pad*0.5, y - lineH*0.5);
      //}
      
      dayCount+=1;
    }
  }
  

}
