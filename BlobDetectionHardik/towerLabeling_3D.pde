

////////////////////////////////////////////

// This function is called to identify the Towers 

String[] towerLabeling_3D(float xMoi,float yMoiTop,float yMoiBottom,float towerWidth)
{
  float thresholdMOI = 12;
  String towerName;

//  float[] NtowersX = {2170,2660,2380,2260,1210,1410,860,925,1020,1020,1570,1685,1975,1715,1640,1665,1065,1240,1875,2270};
//  float[] NtowersYBottom = {2810,3050,2075,2175,1845,2020,1880,2000,1460,1570,1450,1645,1610,1745,1625,1835,1120,1220,2630,3000};
//  float[] NtowersYTop = {2300,2400,2760,2910,1180,1225,1120,1285,1635,1795,1870,1975,2390,2550,1625,1800,1060,1205,1760,1925}; 
 
// String[] NtowerNames = {"A1left","A1right","A2left","A2right","B1left","B1right","B2left","B2right","C1left","C1right","C2left","C2right","D1left","D1right","D2left","D2right","D3left","D3right","D4left","D4right"};

 /*
 float[] NtowersX =       {1450,     1480,      1620,     1450,      1320,      1250,      1390,    1950,       1760,     1780,      1580,     1475,      1865,      1790,     860,      925,       1210,     1410,      1915,      1595,     1585,     1790,     1570,      1500,      1100,      1070,     960,      960};
 float[] NtowersYBottom = {1850,     1780,      1415,     1395,      1350,      1325,      1375,    1505,       1480,     2500,      1760,     1740,      1815,      1740,     1880,     2000,      1845,     2020,      1627,      1586,     2390,     2240,     1630,      1586,      1050,      1090,     1140,     1145}; 
 float[] NtowersYTop =    {1465,     1445,      2110,     1990,      1425,      1380,      2600,     2640,      1500,     1505,      1770,     1745,      2180,      2145,     1120,     1285,      1180,     1225,      2490,      2420,     1680,     1625,     1640,      1635,      1125,      1110,     1145,     1165};
 String[] NtowerNames = {"A1left", "A1right",  "A2left", "A2right", "B1left", "B1right", "B2left", "B2right", "E2left", "E2right", "B3left", "B3right", "B4left", "B4right", "C1left", "C1right", "C2left", "C2right", "D1left", "D1right", "E1left", "E1right", "D2left", "D2right", "D3left", "D3right", "D4left", "D4right"};
*/

 float[] NtowersX  =      {  1750,      1700,    1800,    1880,    500 ,    1080,      1000,    1150,    1940,    1620,    1830,    580    ,  550 ,     530 ,      510 ,  1380};
 
 float[] NtowersYTop  =   {  3200,      4300,    2720,    4650,    3530,    4025,      3630,    2080,    1990,    4520,    6510,    5280  ,    5300,      2350,    2320,  2485};
 float[] NtowersYBottom = {  3960,      3000,    4720,    2670,    3600,    3400,      3600,    3210,    3140,    6470,    4300,      5500,    5290,    2450,    2280,    2550}; 
 String[] NtowerNames = {  "A1left","A2right","E2left","B2left","B1right","B4left","B3right","C1left","C2right","E1left","D1left","D2right","D2left","D3right","D3left","D4close"};

  
  lookupXMoment_3D = createLookupMoment(NtowersX);// this is a dynamic array 
  lookupYMomentTop= createLookupMoment(NtowersYTop); // this is a dynamic array
  lookupYMomentBottom = createLookupMoment(NtowersYBottom);
//towerXMoment.append(300);
  float[] diffXMoment_3D = diffMeanMoment(lookupXMoment_3D.array(),xMoi);
  float[] diffYMomentBottom = diffMeanMoment(lookupYMomentBottom.array(),yMoiBottom);
  float[] diffYMomentTop = diffMeanMoment(lookupYMomentTop.array(),yMoiTop);
//println(diffXMoment);
  float[] absolutediff = getDist_3D(diffXMoment_3D,diffYMomentBottom,diffYMomentTop);
//println(absolutediff);
  int minIndex = findLowestValueIndex(absolutediff);
  float distLowestVal = getLowestValueDistance(absolutediff, minIndex);


float referenceAbsoluteValue = sqrt(absolutediff[minIndex]*100*100/(NtowersX[minIndex]*NtowersX[minIndex] + NtowersYBottom[minIndex]*NtowersYBottom[minIndex] +NtowersYTop[minIndex]*NtowersYTop[minIndex]));

//println(referenceAbsoluteValue);
if (referenceAbsoluteValue > thresholdMOI)
{
  towerName = "Unknown";
} else
{
  towerName = NtowerNames[minIndex];
}
  
  String Orientation = towerOrientation(towerWidth,minIndex,towerName, distLowestVal);
  
  String[] rString = {towerName,Orientation};

  return rString;
}
//////////////////////////////////////////////////

// This function is used to get distance from each Tower


float[] getDist_3D(float[] xArray, float[] yArrayBottom,float[] yArrayTop){
  
 FloatList absvalue = new FloatList();
 
  for ( int i =0; i <xArray.length;i++){
  absvalue.append( xArray[i]*xArray[i] + yArrayBottom[i]*yArrayBottom[i]+yArrayTop[i]*yArrayTop[i]);
  
  }
return absvalue.array();
}

////////////////////////////////////
//// these globals will be deleted ////

String distLowestGlobal = "";
float distLowestValGlobal = 0;
// This function is used to get closest Tower
int findLowestValueIndex(float[] distArray){
  
  int minInd = 0;
for (int i= 1;i<distArray.length;i++){
    if (distArray[i]<distArray[minInd]){
        minInd = i;
        }
}

 distLowestGlobal = "" + distArray[minInd];
 distLowestValGlobal = distArray[minInd];

 return minInd;   
}

float getLowestValueDistance(float[] distArray, int minInd){
  return distArray[minInd];
}

float[] diffMeanMoment(float[] meanMoment, float MomentOfInertia){
  
  for(int i =0; i<meanMoment.length;i++){
   meanMoment[i]=meanMoment[i]- MomentOfInertia;
  }
  return meanMoment;
}
//////////////////////////////////////
FloatList createLookupMoment(float[] Ntowers){
 // println("Hello world");
  //int Ntowers =10;
  FloatList towerMoment = new FloatList(Ntowers.length);  
  //int [] towerXMoment = new int[Ntowers];

  for (int i=0; i < Ntowers.length; i++){
  towerMoment.append(Ntowers[i]);
  }
  //int  value = 450;
  //for (int j=0; j<Ntowers;j++){
  //towerXMoment.sub(j,value);


  //int h = towerXMoment.min();
  //println(h);
  //println(towerXMoment);
  return towerMoment;
  //return towerXMoment.array();
}
