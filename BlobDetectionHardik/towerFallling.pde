String towerFallingFinalDecision(String heightResult, String angle1Result, String angle2Result, String densityResult){
  
  String finalDecision;
  
  println("\nleft falling height: " + heightResult);
  println("left falling angle: " + angle1Result);
  println("left falling angle: " + angle2Result);
  println("density result: " + densityResult);
  
  heightResult = "Standing";
  
  if (angle1Result.equals("Fallen") || heightResult.equals("Fallen")  || densityResult.equals("Fallen")){
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
  
  if ((Blobs.getBlobHeight(blobNumber)) < blobHeight - 8){
    return "Fallen";
  } else {
    return "Standing";
  }
}
  
String towerFallingAngle(Detector Blobs, int blobNumber, float blobAngle, int componentInd){

  if (componentInd == 2){
    return  towerFallingDensity(Blobs, blobNumber, blobAngle);
  }
  
  println("Angle difference: " + (blobAngle - (getBlobAngle(Blobs, blobNumber)[componentInd])));
  
 if (abs(blobAngle - getBlobAngle(Blobs, blobNumber)[componentInd]) > 10){
  return "Fallen"; 
 } else {
  return "Standing"; 
 }
  
}  
  

String towerFallingDensity(Detector Blobs, int blobNumber, float blobDensity){
  
  println("Density difference: " + (blobDensity - getBlobAngle(Blobs, blobNumber)[2]) * 100 / blobDensity);
  
  float densityThreshold = 15;
  
  if (abs(blobDensity - getBlobAngle(Blobs, blobNumber)[2]) * 100 / blobDensity > densityThreshold){
    return "Fallen"; 
  } else{
    return "Standing"; 
  }
  
}






  
String towerFalling2(Detector Blobs, int blobNumber, int blobHeight, int blobWidth)
{
  if (blobHeight <=100)
  {
  //if(gs == GameState.MAIN_GAME) {
    if ((Blobs.getBlobHeight(blobNumber) <  (blobHeight - 8))){
     // println(" The height of the standing tower is :" + blobHeight);
     println("height lowered");
     return("Fallen");
    }else if (Blobs.getBlobWidth(blobNumber) > (blobWidth + 20)){
      println("width increased");
      return "Fallen";
    } else{
      return "Standing";
    }
  }
  else 
  {
    if ((Blobs.getBlobHeight(blobNumber) <  (blobHeight - 40))){
   //   println(" The height of the standing tower is :" + blobHeight);
     println("height lowered");
     return("Fallen");
    }else if (Blobs.getBlobWidth(blobNumber) > (blobWidth + 20)){
      println("width increased");
      return "Fallen";
    } else{
      return "Standing";
    }
  }
/*  }
  else
  {
    if ((Blobs.getBlobHeight(blobNumber) <  (blobHeight - 10))){
     println("height lowered");
     return("Fallen");
    }else if (Blobs.getBlobWidth(blobNumber) > (blobWidth + 20)){
      println("width increased");
      return "Fallen";
    } else{
      return "Standing";
    }
  }*/
}

    
