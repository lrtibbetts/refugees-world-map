import java.util.Map;

PShape worldMap;
Table refugeesData;
Table countries; // table containing country codes
HashMap totals;

void setup() {
  size(1500, 750);
  worldMap = loadShape("worldHigh.svg");
  // svg map from: https://www.amcharts.com/svg-maps/?map=world
  refugeesData = loadTable("refugees2016.csv", "header");
  countries = loadTable("countries.csv", "header");
  // data from: http://data.un.org/Data.aspx?d=UNHCR&f=indID%3AType-Ref
  
  background(255);
  noStroke();
  worldMap.disableStyle();
  
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
  System.out.println(totals);
}

void draw() {
  background(255);
  noStroke();
  worldMap.disableStyle();
  //fill(0);
  //shape(worldMap);
  //PShape Australia = worldMap.getChild("AU");
  //fill(#0ED5ED);
  //shape(Australia);
}