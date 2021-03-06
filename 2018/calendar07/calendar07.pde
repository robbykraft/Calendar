import processing.pdf.*;

Table table;
String planetNames[] = {"Mercury","Venus","Mars","Jupiter","Saturn","Uranus","Neptune","Pluto"};
String monthNames[] = { "JANUARY", "FEBRUARY", "MARCH", "APRIL", "MAY", "JUNE", "JULY", "AUGUST", "SEPTEMBER", "OCTOBER", "NOVEMBER", "DECEMBER" };
static int planetColors[] = {192,192,192,206,172,113,172,81,40,186,130,83,253,196,126,149,188,198,98,119,226,169,149,146};
float moonEventAngles[] = {0.0, 1.570796326794897, 3.141592653589793, 4.71238898038469};
String moonEventDescriptions[] = {"New", "First Quarter", "Full", "Third Quarter" };

int year[];
int month[];
int day[];
//int hour[];
float sunLongitude[];
float sunDistance[];
float moonLatitude[];
float moonLongitude[];
float moonDistance[];
float moonPhase[];
float planetLatitude[][];
float planetLongitude[][];
float planetDistance[][];
//String zodiacs[];
float daylightHoursNYC[];
String zodiac[];

// select day here
  int daySelect = 5;
  int monthSelect = 3;

int dayindex = 0;

int pRadius = 10;
int moonRadius = 30;

void setup(){
  size(700, 700, P3D);
  //noLoop();
  
  importCSV();
    
  for(int i = 0; i < table.getRowCount(); i++){
    if(day[i] == daySelect && month[i] == monthSelect){
      dayindex = i;
      break;
    }
  }
  println(monthSelect + " " + daySelect + " = " + dayindex);
  
  //beginRaw(PDF, "output.pdf");
  //drawCalendar();
  //endRaw();
}

void draw(){
  //logfactor = mouseX * 0.1;
  //auscale = mouseY;
  //println(logfactor + "  " + auscale);
  dayindex = int(float(mouseX) * table.getRowCount() / width);
  //println(dayindex);
  drawCalendar();
}

void importCSV(){
  table = loadTable("../2019.csv", "header");

  year = new int[table.getRowCount()];
  month = new int[table.getRowCount()];
  day = new int[table.getRowCount()];
  //hour = new int[table.getRowCount()];
  sunLongitude = new float[table.getRowCount()];
  sunDistance = new float[table.getRowCount()];
  moonLatitude = new float[table.getRowCount()];
  moonLongitude = new float[table.getRowCount()];
  moonDistance = new float[table.getRowCount()];
  moonPhase = new float[table.getRowCount()];
  planetLatitude = new float[table.getRowCount()][planetNames.length];
  planetLongitude = new float[table.getRowCount()][planetNames.length];
  planetDistance = new float[table.getRowCount()][planetNames.length];
  zodiac = new String[table.getRowCount()];
  daylightHoursNYC = new float[table.getRowCount()];

  int i = 0;
  for (TableRow row : table.rows()) {
    //String zodiac = row.getString("zodiac");
    year[i] = row.getInt("Year");
    month[i] = row.getInt("Month");
    day[i] = row.getInt("Day");
    moonLongitude[i] = row.getFloat("MoonLongitude") * PI/180;
    moonLatitude[i] = row.getFloat("MoonLatitude") * PI/180;
    moonDistance[i] = row.getFloat("MoonDistance");
    moonPhase[i] = row.getFloat("MoonPhase") * PI/180;
    sunLongitude[i] = row.getFloat("SunLongitude") * PI/180;
    sunDistance[i] = row.getFloat("SunDistance");
    daylightHoursNYC[i] = row.getFloat("Daylight");
    zodiac[i] = row.getString("Zodiac");
    for(int p = 0; p < planetNames.length; p++){
      planetLongitude[i][p] = row.getFloat(planetNames[p] + "Longitude") * PI / 180;
      planetLatitude[i][p] = row.getFloat(planetNames[p] + "Latitude") * PI / 180;
      planetDistance[i][p] = row.getFloat(planetNames[p] + "Distance");
    }
    i++;
  }    
}

float logfactor = 10.0;//6.3;
float auscale = 135;

float au(float input){
  return auscale * pow(input, 1./logfactor);
  //return 150 * pow(input,.2);
}

void drawCalendar(){
  fill(40);
  strokeWeight(1);
  noStroke();
  rect(0, 0, width, height);

  translate(width*0.5, height*0.5);
  
  float oneAU = au(sunDistance[dayindex])*2;

  // 1 AU circle
  noStroke();
  fill(45);
  ellipse(0, 0, oneAU, oneAU);

  noFill();
  stroke(244);
  

  for(int i = 0; i < 20; i++){
    int round = int(i/10.0);
    int imod = i%10;
    float r = pow(imod/10.0, 1./logfactor);
    r = r * oneAU + oneAU * round;
    arc(0, 0, r, r, HALF_PI-.05, HALF_PI+.05);
  }
  float hundredAU = pow(1, 1./logfactor) * oneAU * 2;
  float outerRadius = hundredAU * 0.5;

  ellipse(0, 0, outerRadius*2, outerRadius*2);


  fill(255);
  text(year[dayindex] + " "  + monthNames[month[dayindex]-1] + " " + day[dayindex], -width*0.5+8, -height*0.5+20);
  
  // rotate everything
    rotate(9.0/365.0*PI*2);
  
  // zodiac lines
  for(int i = 0; i < 12; i++){
    line(outerRadius*cos(i/12.0*PI*2), outerRadius*sin(i/12.0*PI*2), (outerRadius-10)*cos(i/12.0*PI*2), (outerRadius-10)*sin(i/12.0*PI*2)); 
  }
  
  // earth
  noStroke();
  fill(60, 110, 230);
  ellipse(0, 0, pRadius*4, pRadius*4);

  // sun
  fill(210, 200, 0);
  ellipse(au(sunDistance[dayindex]) * -cos(sunLongitude[dayindex]), 
          au(sunDistance[dayindex]) * sin(sunLongitude[dayindex]), pRadius*2, pRadius*2);
  
  //fill(210, 200, 0);
  stroke(210, 200, 0);
  noFill();
  float sunL = sunLongitude[dayindex] - sunLongitude[0];
  while(sunL < 0){ sunL += PI*2; }
  pushMatrix();
  scale(-1,1);
  arc(0, 0, oneAU, oneAU, sunLongitude[0], sunLongitude[0] + sunL, PIE);
  popMatrix();
  
  fill(40);
  noStroke();
  // moon
  ellipse(au(moonDistance[dayindex]) * -cos(moonLongitude[dayindex]), 
          au(moonDistance[dayindex]) * sin(moonLongitude[dayindex]), moonRadius, moonRadius);
  fill(200);
  pushMatrix();
  translate(au(moonDistance[dayindex]) * -cos(moonLongitude[dayindex]), au(moonDistance[dayindex]) * sin(moonLongitude[dayindex]));
  rotate(-sunLongitude[dayindex]+PI*0.5);
  arc(0, 0, moonRadius, moonRadius, 0, PI, CHORD);
  popMatrix();
          
  noFill();
  stroke(255);
  // lines to bodies
  // sun
  stroke(100);
  line(au(sunDistance[dayindex]) * -cos(sunLongitude[dayindex]),  
       au(sunDistance[dayindex]) * sin(sunLongitude[dayindex]),
       outerRadius * -cos(sunLongitude[dayindex]), 
       outerRadius * sin(sunLongitude[dayindex]) );
  line(au(moonDistance[dayindex]) * -cos(moonLongitude[dayindex]),
       au(moonDistance[dayindex]) * sin(moonLongitude[dayindex]),
       outerRadius * -cos(moonLongitude[dayindex]), 
       outerRadius * sin(moonLongitude[dayindex]) );
  for(int i = 0; i < planetNames.length; i++){
    line(au(planetDistance[dayindex][i]) * -cos(planetLongitude[dayindex][i]), 
         au(planetDistance[dayindex][i]) * sin(planetLongitude[dayindex][i]),
         outerRadius * -cos(planetLongitude[dayindex][i]), 
         outerRadius * sin(planetLongitude[dayindex][i]) );
  }
  
  noStroke();
  for(int i = 0; i < planetNames.length; i++){
    fill(planetColors[i*3+0], planetColors[i*3+1], planetColors[i*3+2]);
    ellipse(au(planetDistance[dayindex][i]) * -cos(planetLongitude[dayindex][i]), 
            au(planetDistance[dayindex][i]) * sin(planetLongitude[dayindex][i]), pRadius, pRadius);
  }
  
  int ONIONDAYS = 200;
  for(int i = -ONIONDAYS; i < ONIONDAYS; i++){
    float alpha = 255*cos(float(i)/ONIONDAYS*PI);
    stroke(255, 255, 255, alpha);
    int i0 = dayindex + i;
    int i1 = dayindex + i + 1;
    if(i0 < 0) i0 = 0;
    if(i1 < 0) i1 = 0;
    if(i0 >= table.getRowCount()) i0 = table.getRowCount()-1;
    if(i1 >= table.getRowCount()) i1 = table.getRowCount()-1;
    for(int p = 0; p < planetNames.length; p++){
      //stroke(planetColors[p*3+0], planetColors[p*3+1], planetColors[p*3+2]);
      line(au(planetDistance[i0][p]) * -cos(planetLongitude[i0][p]), 
           au(planetDistance[i0][p]) * sin(planetLongitude[i0][p]), 
           au(planetDistance[i1][p]) * -cos(planetLongitude[i1][p]), 
           au(planetDistance[i1][p]) * sin(planetLongitude[i1][p]) );
    }
  }
 
}
