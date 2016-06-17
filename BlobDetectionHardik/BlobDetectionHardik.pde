

// This is the master code after 16th december merge




String[] getTowerName (Detector Towers,int Blobnumber)
{
  PVector[] V1 = Towers.getBlobPixelsLocation(Blobnumber);
 // float Width = Towers.getBlobWidth(Blobnumber);
  //println("Width is:"+ Width);
  //The bounding box corners are identified as follows:
 
//          A---------B
//          |         |
//          |         |
//          |         |
//          C---------D
//
// The rispective methods to compute them are :
// corners A getA()
// corners B getB()
// corners C getC()
// corners D getD()
  //PVector[] V2 =bd.getBlobPixelsLocation(1);
  
  PVector[] cornerA = Towers.getA();// top left corner of the blob
  PVector[] cornerC = Towers.getC();// bottom let corner of the blob
  PVector[] cornerB = Towers.getB();// top right corner of the Blob
  PVector[] cornerD = Towers.getD(); // bottom right corner of the Blob

  //String[] TowerLabel = calculateMoI_bothAxis(V1, cornerA[Blobnumber] , cornerC[Blobnumber],cornerB[Blobnumber],cornerD[Blobnumber]);
  //return TowerLabel;
  return calculateMoI_bothAxis(V1, cornerA[Blobnumber] , cornerC[Blobnumber],cornerB[Blobnumber],cornerD[Blobnumber]);

}

// Below function returns the towerLabel

String[] calculateMoI_bothAxis(PVector[] pixelArray,PVector topLeftC, PVector bottomLeftC,PVector topRightC, PVector  bottomRightC)
{
  float xMoment = 0;
  float yMoment_lowerAxis = 0;
  float yMoment_topAxis = 0;
  float boxH =  bottomLeftC.y - topLeftC.y ;
  float boxW  = (topRightC.x - topLeftC.x + bottomRightC.x - bottomLeftC.x)/2 ;

  for (int i =0; i < pixelArray.length; i++)
  {
    if(topLeftC == null || bottomLeftC == null)
        return new String[]{"Unkown Err", "wrong3"};
        
      xMoment = xMoment + (pixelArray[i].x-topLeftC.x)*(pixelArray[i].x-topLeftC.x);
      yMoment_lowerAxis = yMoment_lowerAxis + (- pixelArray[i].y + bottomLeftC.y)*(-pixelArray[i].y+bottomLeftC.y);
      yMoment_topAxis = yMoment_topAxis + (-topLeftC.y + pixelArray[i].y)*(-topLeftC.y + pixelArray[i].y);
    }
  xMoment = xMoment/pixelArray.length;
  yMoment_lowerAxis = yMoment_lowerAxis/pixelArray.length;
  yMoment_topAxis = yMoment_topAxis/pixelArray.length;
  
  String textdisplayX =  "x: "+str(xMoment) ;
  String textdisplayYLow = "ylow: "+  str(yMoment_lowerAxis);
  String textdisplayYTop = "yTop: "+ str(yMoment_topAxis);
  String towerHeight = str(boxH);
  String towerWidth = str(boxW);
 
  String[] TowerLabel = towerLabeling_3D(xMoment,yMoment_topAxis,yMoment_lowerAxis,boxW);

  String leftCorneer = "lCornerX: " +str(topLeftC.x);
  
  float arrayList1 = getRotatedAngle(pixelArray, topLeftC, boxH, boxW);
  float arrayList2 = getRotatedAngle(pixelArray, bottomLeftC, boxH, boxW);  
  float eigenValue1 = getEigenValue(pixelArray, topLeftC, boxH, boxW);
  
  float[] arrayList = {arrayList1, arrayList2};
  
  String angleText1 = "1st angle: " + arrayList[0];
  String angleText2 = "2nd angle: " + arrayList[1];
  String eigenValueText = "Distribution Density: " + eigenValue1;
  
  // below commands are used to draw text on the debug Screen in the game
  debugScreen.addText(leftCorneer,topLeftC.x-50,60);
  debugScreen.addText(textdisplayX,topLeftC.x-50,100);
  debugScreen.addText(textdisplayYLow,topLeftC.x-50,120);
  debugScreen.addText(textdisplayYTop,topLeftC.x-50,140);
  debugScreen.addText(towerWidth,topLeftC.x-50,80);
  debugScreen.addText( TowerLabel[0],topLeftC.x-50,160);
  debugScreen.addText(TowerLabel[1],topLeftC.x-50,180);
  debugScreen.addText(angleText1,topLeftC.x-50,200);
  debugScreen.addText(angleText2,topLeftC.x-50,220);
  debugScreen.addText(eigenValueText, topLeftC.x-50,240);
  debugScreen.addText("Distance with the ref: " + distLowestGlobal,topLeftC.x-50,260);
   
  
  return TowerLabel;

}

float[] getBlobAngle(Detector Towers, int Blobnumber){
  PVector[] V1 = Towers.getBlobPixelsLocation(Blobnumber);
  
  PVector[] cornerA = Towers.getA();// top left corner of the blob
  PVector[] cornerC = Towers.getC();// bottom let corner of the blob
  PVector[] cornerB = Towers.getB();// top right corner of the Blob
  PVector[] cornerD = Towers.getD(); // bottom right corner of the Blob
  
  PVector topLeftC = cornerA[Blobnumber];
  PVector bottomLeftC = cornerC[Blobnumber];
  PVector topRightC = cornerB[Blobnumber];
  PVector bottomRightC = cornerD[Blobnumber];
  
  float boxH =  bottomLeftC.y - topLeftC.y ;
  float boxW  = (topRightC.x - topLeftC.x + bottomRightC.x - bottomLeftC.x)/2 ;  
  
  float angleArray1  = getRotatedAngle(V1, topLeftC, boxH, boxW);
  float angleArray2 = getRotatedAngle(V1, topRightC, boxH, boxW);
  float angleDensity = getEigenValue(V1, topLeftC, boxH, boxW);
  
  float[] angleArray = {angleArray1, angleArray2, angleDensity};
  
  return angleArray;
  
}

float getRotatedAngle(PVector[] pixelArray, PVector topLeftC, float boxH, float boxW){
  
  int rows = round(boxH);
  int cols = round(boxW);
  
  int x = round(topLeftC.x);
  int y = round(topLeftC.y);
  
  int allPixels = rows*cols;
  
  double [][] points = new double[pixelArray.length][2];
  int count = 0;
  
  
  for ( int i = 0 ; i < pixelArray.length ; i++){
      points[i][0] = (double) (pixelArray[i].x - topLeftC.x);
      points[i][1] = (double) (rows - (pixelArray[i].y - topLeftC.y));
  }
  
  Matrix pointMat = new Matrix(points);
  pointMat = pointMat.transpose();
  
  Matrix cov = pointMat.times(pointMat.transpose());
  Matrix eig = cov.eig().getV();
  
  double angle = Math.toDegrees(Math.atan(eig.get(1, 1) / eig.get(0, 1)));
  
  return (float) angle;
  
}

float getEigenValue(PVector[] pixelArray, PVector topLeftC, float boxH, float boxW){
  
  int rows = round(boxH);
  int cols = round(boxW);
  
  int x = round(topLeftC.x);
  int y = round(topLeftC.y);
  
  int allPixels = rows*cols;
  
  double [][] points = new double[pixelArray.length][2];
  int count = 0;
  
  float xRef = 0;
  
  for ( int i = 0 ; i < pixelArray.length ; i++){
      if ((pixelArray[i].x - topLeftC.x) >= xRef){
        points[i][0] = (double) (pixelArray[i].x - topLeftC.x) - xRef;
        points[i][1] = (double) (rows - (pixelArray[i].y - topLeftC.y));
      }
  }
  
  Matrix pointMat = new Matrix(points);
  pointMat = pointMat.transpose();
  
  Matrix cov = pointMat.times(pointMat.transpose());
  Matrix eig = cov.eig().getD();
  
  double eigValue = (eig.get(1,1) + eig.get(1,0)) / pixelArray.length;
  
  return (float) eigValue;
  
}
