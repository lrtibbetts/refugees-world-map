/* Data Visualization Final Project
   Lucy Tibbetts
   resources utilized: https://forum.processing.org/one/topic/interactive-svg-map-with-processing-js.html
                       http://www.sojamo.de/libraries/controlP5/examples/controllers/ControlP5textfield/ControlP5textfield.pde
*/

import java.util.*;
import controlP5.*; // library for simple gui elements
import org.gicentre.utils.stat.*; // library for creating graphs, etc.

PShape worldMap;
Table refugeesData;
Table countries; // table containing country codes
HashMap totals;
int maxTotal;
ControlP5 cp5; 
PFont calibri;
String text;

void setup() {
  size(1800, 950);
  
  // text box input
  cp5 = new ControlP5(this);
  calibri = loadFont("Calibri-28.vlw");
  
  cp5.addTextfield("Country")
     .setPosition(1475,75)
     .setSize(250,40)
     .setFont(calibri) 
     .setColor(255)
     ;
  
  worldMap = loadShape("worldHigh.svg");
  worldMap.scale(1.4);
  // svg map from: https://www.amcharts.com/svg-maps/?map=world
  refugeesData = loadTable("refugees2016.csv", "header");
  countries = loadTable("countries.csv", "header");
  // data from: http://data.un.org/Data.aspx?d=UNHCR&f=indID%3AType-Ref

  totals = new HashMap<String, Integer>();
  int numRows = refugeesData.getRowCount();
  for(int i = 0; i < numRows; i++) { 
    TableRow row = refugeesData.getRow(i);
    String countryName = row.getString("Country or territory of asylum or residence");

    // get total number of refugees in each country
    if(!totals.containsKey(countryName)) {
      Integer total = 0;
      for (TableRow myRow : refugeesData.findRows(countryName, "Country or territory of asylum or residence")) {
        int count = myRow.getInt("Refugees");
        total += count;
      }
      totals.put(countryName, total);
      
      // replace country names with country codes
      TableRow newRow = countries.findRow(countryName, "name");
      if(newRow != null) {
        String countryCode = newRow.getString("alpha-2");
        int count = (int) totals.get(countryName);
        totals.remove(countryName);
        totals.put(countryCode, count);
      }
    }
  }
  
  background(#A7ABAD);
  noStroke();
  worldMap.disableStyle();
  
  // draw the full map first to account for any countries without data
  fill(#fee0d2);
  shape(worldMap, 20, 20);
  
  // https://stackoverflow.com/questions/1066589/iterate-through-a-hashmap
  Iterator<Map.Entry<String, Integer>> entries = totals.entrySet().iterator();
  while (entries.hasNext()) {
    Map.Entry<String, Integer> entry = entries.next();
    String country = entry.getKey();
    int total = (int) entry.getValue();
    PShape countryShape = worldMap.getChild(country);
    color c;
    if (total <= 1000) {
      c = #fcbba1;
    } else if (total <= 5000) {
      c = #fc9272;
    } else if (total <= 25000) {
      c = #fb6a4a;
    } else if (total <= 125000) {
      c = #ef3b2c;
    } else if (total <= 635000) {
      c = #cb181d;
    } else
      c = #99000d;
    fill(c);
    countryShape.scale(1.4);
    shape(countryShape, 20, 20);
  }
}

void controlEvent(ControlEvent event) {
  if(event.isAssignableFrom(Textfield.class)) {
    String country = event.getStringValue();
    HashMap<String, Integer> originCountries = new HashMap<String, Integer>();
    for (TableRow row : refugeesData.findRows(country, "Country or territory of asylum or residence")) {
      String originCountry = row.getString("Country or territory of origin");
      int numRefugees = row.getInt("Refugees");
      originCountries.put(originCountry, numRefugees);
      System.out.println(originCountry + ": " + numRefugees);
    }
           
  }
}

void draw() {
 
}