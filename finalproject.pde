PShape worldMap;
Table refugeesData;
Table countries; // table containing country codes

void setup() {
  size(1500, 750);
  worldMap = loadShape("worldHigh.svg");
  // svg map from: https://www.amcharts.com/svg-maps/?map=world
  refugeesData = loadTable("refugees.csv", "header");
  countries = loadTable("countries.csv", "header");
  // data from: http://data.un.org/Data.aspx?d=UNHCR&f=indID%3AType-Ref
  
  background(255);
  noStroke();
  worldMap.disableStyle();
  
  // int numRows = refugeesData.getRowCount();
  for(int i = 0; i < 5399; i++) { // start with only the year 2016
    TableRow row = refugeesData.getRow(i);
    String countryName = row.getString("Country or territory of asylum or residence");
    // System.out.println(countryName);
    TableRow newRow = countries.findRow(countryName, "name");
    if(newRow != null) {
      String countryCode = newRow.getString("alpha-2");
      // System.out.println(countryCode);
    }
  }
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