

// This is the master code after 16th december merge

String[] getTowerName (Detector blobs,int blobNumber)
{
  if(gs != GameState.MAIN_GAME) return new String[]{"Unkown Err", "wrong3"};
  
  try{
    blobs.getBlobsNumber();
  } catch(NullPointerException e){
    String[] nullErrorResult = {"Unknown", "wrong"} ;
    return nullErrorResult; 
  }
  
  PVector[] pixelArray = blobs.getBlobPixelsLocation(blobNumber);
  
  PVector topLeftC = blobs.getA()[blobNumber];// top left corner of the blob
  PVector bottomLeftC = blobs.getC()[blobNumber];// bottom let corner of the blob
  PVector topRightC = blobs.getB()[blobNumber];// top right corner of the Blob
  PVector bottomRightC = blobs.getD()[blobNumber]; // bottom right corner of the Blob
  
  float boxH =  bottomLeftC.y - topLeftC.y ;
  float boxW  = (topRightC.x - topLeftC.x + bottomRightC.x - bottomLeftC.x)/2 ;

  if(topLeftC == null || bottomLeftC == null)
        return new String[]{"Unkown Err", "wrong3"};

//  float[] moiArray = calculateMoI(pixelArray, topLeftC, bottomLeftC);
  float[] moiArray = calculateMoI(blobs, blobNumber);
  
  float xMoment = moiArray[0];
  float yMoment_lowerAxis = moiArray[1];
  float yMoment_topAxis = moiArray[2];
  
  String textdisplayX =  "x: "+str(xMoment) ;
  String textdisplayYLow = "ylow: "+  str(yMoment_lowerAxis);
  String textdisplayYTop = "yTop: "+ str(yMoment_topAxis);
  String towerHeight = str(boxH);
  String towerWidth = str(boxW);
 
  String[] TowerLabel = towerLabeling_3D(xMoment,yMoment_topAxis,yMoment_lowerAxis,boxW);

  String leftCorneer = "lCornerX: " +str(topLeftC.x);
  
  float[] eigArray = getRotatedAngle(pixelArray, topLeftC, boxH, boxW);
  
  float angle = eigArray[0];
  float eigenValue = eigArray[1];
  
  String angleText = "Angle: " + angle;
  String eigenValueText = "Density: " + eigenValue;
  
  // below commands are used to draw text on the debug Screen in the game
  debugScreen.addText(leftCorneer,topLeftC.x-50,60);
  debugScreen.addText(textdisplayX,topLeftC.x-50,100);
  debugScreen.addText(textdisplayYLow,topLeftC.x-50,120);
  debugScreen.addText(textdisplayYTop,topLeftC.x-50,140);
  debugScreen.addText(towerWidth,topLeftC.x-50,80);
  debugScreen.addText( TowerLabel[0],topLeftC.x-50,160);
  debugScreen.addText(TowerLabel[1],topLeftC.x-50,180);
  debugScreen.addText(angleText,topLeftC.x-50,200);
  debugScreen.addText(eigenValueText, topLeftC.x-50,220);
  
  return TowerLabel;

}

//float[] calculateMoI(PVector[] pixelArray, PVector topLeftC, PVector bottomLeftC){
float[] calculateMoI(Detector blobs, int blobNumber){  
  PVector[] pixelArray = blobs.getBlobPixelsLocation(blobNumber);
  
  PVector topLeftC = blobs.getA()[blobNumber];// top left corner of the blob
  PVector bottomLeftC = blobs.getC()[blobNumber];// bottom let corner of the blob
  
  float xMoment = 0;
  float yMoment_lowerAxis = 0;
  float yMoment_topAxis = 0;
  
  for (int i =0; i < pixelArray.length; i++)
  {
      xMoment = xMoment + (pixelArray[i].x-topLeftC.x)*(pixelArray[i].x-topLeftC.x);
      yMoment_lowerAxis = yMoment_lowerAxis + (- pixelArray[i].y + bottomLeftC.y)*(-pixelArray[i].y+bottomLeftC.y);
      yMoment_topAxis = yMoment_topAxis + (-topLeftC.y + pixelArray[i].y)*(-topLeftC.y + pixelArray[i].y);
  }
  
  xMoment = xMoment/pixelArray.length;
  yMoment_lowerAxis = yMoment_lowerAxis/pixelArray.length;
  yMoment_topAxis = yMoment_topAxis/pixelArray.length;
  
  
  float[] moiArray = {xMoment, yMoment_lowerAxis, yMoment_topAxis};
  
  return moiArray;
}

float[] getBlobEigen(Detector Towers, int Blobnumber){
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
  
  float[] eigArray = getRotatedAngle(V1, topLeftC, boxH, boxW);

  return eigArray;
  
}

float[] getRotatedAngle(PVector[] pixelArray, PVector topLeftC, float boxH, float boxW){
  
  int rows = round(boxH);
  int cols = round(boxW);
  
  int x = round(topLeftC.x);
  int y = round(topLeftC.y);
  
  int allPixels = rows*cols;
  
  int pointNum = pixelArray.length;
  
  double [][] points = new double[pointNum][2];
  int count = 0;
  
  
  for(int i = 0 ; i < pointNum ; i++){
      points[i][0] = (double) (pixelArray[i].x - topLeftC.x);
      points[i][1] = (double) (rows - (pixelArray[i].y - topLeftC.y));
  }
  
  Matrix pointMat = new Matrix(points);
  pointMat = pointMat.transpose();
  
  Matrix cov = pointMat.times(pointMat.transpose());
  Matrix eigVec = cov.eig().getV();
  Matrix eigVal = cov.eig().getD();
  
  double angle = Math.toDegrees(Math.atan(eigVec.get(1, 1) / eigVec.get(0, 1)));
  double eigValue = (eigVal.get(1,1) + eigVal.get(0,1)) / pointNum;
  
  float[] eigArray = {(float) angle, (float) eigValue};
  
  return eigArray;
  
}

