// resource utilized: https://forum.processing.org/one/topic/interactive-svg-map-with-processing-js.html

import java.util.*;

PShape worldMap;
Table refugeesData;
Table countries; // table containing country codes
HashMap totals;
int maxTotal;

void setup() {
  size(1800, 950);
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
  
  // draw the full map first to account for any countries without refugee data
  fill(#fee0d2);
  shape(worldMap, 20, 20);
  
  // https://stackoverflow.com/questions/1066589/iterate-through-a-hashmap
  Iterator<Map.Entry<String, Integer>> entries = totals.entrySet().iterator();
  while (entries.hasNext()) {
    Map.Entry<String, Integer> entry = entries.next();
    String country = entry.getKey();
    int total = (int) entry.getValue();
    PShape countryShape = worldMap.getChild(country);
    //float amt = norm(total, 0, maxTotal); // get normalized calue for number of refugees
    //color c = lerpColor(#9ecae1, #08306b, amt); // used color brewer
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

void draw() {
 
}

void mouseMoved() {
  System.out.println(mouseX);
  
}