String towerOrientation( float towerWidth, int towerIndex,String towername)

{

//float[] NtowerWid  =  {  81     ,  85     ,  83    ,  85    ,   42    ,  68    ,    63   ,  85    ,  81     ,  80    ,   84   ,    45   ,   42   ,  45     , 44     ,  61     };
float[] NtowerWid  =  {  77     ,  77     ,  80    ,  81    ,   40    ,  62    ,    60   ,  82    ,  78     ,  77    ,   79   ,    40   ,   41   ,  40     , 39     ,  64     };
String[] NtowerNames = {"A1left","A2right","E2left","B2left","B1right","B4left","B3right","C1left","C2right","E1left","D1left","D2right","D2left","D3right","D3left","D4close"} ;

  
//StringList NList = createLookUpList(NtowerNames);
// The array NtowerWid needs to be in the same order as the towerNames i.e first tower should have the width as the first enter here 

// For eg  String NtowerNames = {"A1", "A2", "A3"};
//         float  NtowerWid = {80,90,120};
//         Width of A2 = 90;
//           
    
  if (towername == "Unknown")
  {
    return "wrong2";
  } else 
  {
    //int indexTower = NList.indexOf("towername");

    //int indexTower = NtowerNames.indexOf("towername");
    float matingWidth = NtowerWid[towerIndex];
    float percentageChange = (abs( matingWidth - towerWidth))*100/matingWidth;
    if (percentageChange < 15 )
    {
      return "right";
    }
    else
    {
      return "wrong";
    }
  }

}
