String towerOrientation( float towerWidth, int towerIndex,String towername, float distLowestVal)

{

float[] NtowerWid  =  {  81     ,  85     ,  83    ,  85    ,   42    ,  68    ,    63   ,  85    ,  81     ,  80    ,   84   ,    45   ,   46   ,  45     , 44     ,  61     };

String[] NtowerNames = {"A1left","A2right","E2left","B2left","B1right","B4left","B3right","C1left","C2right","E1left","D1left","D2right","D2left","D3right","D3left","D4close"} ;

  
//StringList NList = createLookUpList(NtowerNames);
// The array NtowerWid needs to be in the same order as the towerNames i.e first tower should have the width as the first enter here 

// For eg  String NtowerNames = {"A1", "A2", "A3"};
//         float  NtowerWid = {80,90,120};
//         Width of A2 = 90;
//           
  
  float distanceThreshold;
  
  if (t == null){
    distanceThreshold = 0;
  }
  if ((t[0].equals("A1") && t[1].equals("A2")) || (t[0].equals("A2") && t[1].equals("A1"))){
    distanceThreshold = 49000;
  } else {
    distanceThreshold = 90000; 
  }
  
  
      
 
  if (towername == "Unknown")
  {
    return "wrong2";
  } else 
  {
    //int indexTower = NList.indexOf("towername");

    //int indexTower = NtowerNames.indexOf("towername");
    float matingWidth = NtowerWid[towerIndex];
    float percentageChange = (abs( matingWidth - towerWidth))*100/matingWidth;
    if (percentageChange < 15 && (distLowestVal < distanceThreshold))
    {
      return "right";
    }
    else
    {
      return "wrong";
    }
  }

}
