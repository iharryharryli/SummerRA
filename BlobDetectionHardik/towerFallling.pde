String towerFallingFinalDecision(String heightResult, String angle1Result){
  
  String finalDecision;
  
  println("\nleft falling height: " + heightResult);
  println("left falling angle: " + angle1Result);

//  heightResult = "Standing";
  
  if (angle1Result.equals("Fallen") || heightResult.equals("Fallen")){
    finalDecision = "Fallen";
  } else {
    finalDecision = "Standing";
  } 
  
  return finalDecision;
  
}

// This function checks whether the tower have fallen or not  

String towerFallingHeight(Detector Blobs, int blobNumber,int blobHeight){
  // blobNum is the array which is return from the function getNum_getIndex
  // Blobs is the BlobObject containing all the blobs and other information
  
  int heightThreshold = 25;
  
  float heightDiff = abs(Blobs.getBlobHeight(blobNumber) - blobHeight);
  
  println("Height Diff: " + heightDiff);
  
//  if ((Blobs.getBlobHeight(blobNumber)) < blobHeight - 8){
  if(heightDiff > heightThreshold){
    return "Fallen";
  } else {
    return "Standing";
  }
}
  
String towerFallingAngle(Detector Blobs, int blobNumber, float blobAngle, float blobDensity){
  
  int angleThreshold = 15;
  float densityThreshold = 25;
  
  float[] eigArray = getBlobEigen(Blobs, blobNumber);
    
  println("Angle1 difference: " + (blobAngle - (eigArray[0])));
  println("Density difference: " + (blobDensity - (eigArray[1]))* 100 / blobDensity);
  
  float angleDiff = abs(blobAngle - eigArray[0]);
  float densityDiff = abs(blobDensity - eigArray[1]) * 100 / blobDensity;
  
  if (angleDiff > angleThreshold ||  densityDiff > densityThreshold){ // change this value to relax it
    return "Fallen"; 
  } else {
    return "Standing"; 
  }
  
}

String towerFallingMoI(Detector blobs, int blobNumber, float xM, float yM){
  
  float xThreshold = 1500;
  float yThreshold = 1500;
  
  
  
  float[] moiArray = calculateMoI(blobs, blobNumber); 
  
//  float xDiff = abs(xM - moiArray[0])/xM * 100;
//  float yDiff = abs(yM - moiArray[1])/yM * 100;
  float xDiff = abs(xM - moiArray[0]);
  float yDiff = abs(yM - moiArray[1]);
  double xyDistDiff = Math.sqrt(xDiff*xDiff + yDiff*yDiff);
  
  println("xMoI_Diff: " + xDiff);
  println("yMoI_Diff: " + yDiff);
  println("xyMoI_Dist: " + xyDistDiff);
  
  
  if (xDiff > xThreshold && yDiff > yThreshold){
    return "Fallen";  
  } else {
    return "Standing";
  }
 
  
    
}
