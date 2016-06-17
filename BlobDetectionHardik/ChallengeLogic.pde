class ChallengeControl{
  ChallengeLogic father;
  public ChallengeControl(ChallengeLogic f){
    father = f;
  }
  
  public void shakeBtnClick(){  
    if(towers.size() != 1 || towerIndex.size() != 1)return;
       
        leftHeight = bd.getBlobHeight(towerIndex.get(0));
        
        float[] angleArray = getBlobAngle(bd, towerIndex.get(0));     
        leftAngle1 = angleArray[0];
        leftAngle2 = angleArray[1];
        leftDensity = angleArray[2]; 
       
        ArrayList<Contour> areas = getContours();
        
        blobArea = areas.get(0).area();
        
        shakingTimeout = System.currentTimeMillis() + 5000;
        startTime = System.currentTimeMillis();
        father.cs = ChallengeMyTowerState.SHAKING;
        uiengine.turnBtn(new int[]{4},false);
        aplayer.close();
        relayOn();
        tableHoldTimeout = System.currentTimeMillis();
        centroidTower.clear(); 
  }
  
  public void continueBtnClick(){
    father.cs = ChallengeMyTowerState.PLACING_TOWER;
      uiengine.turnBtn(new int[]{3},false);
  }
  
}

class ChallengeLogic{
  
  ChallengeMyTowerState cs;
  
  private int relayFlag = 0;
  
  RulerEngine rulerEngine;
  
  ChallengeUI UI;
  
  ChallengeControl control;
  
  boolean towerOK;
  
  private long handsOffTime;
 
  
  ChallengeLogic(){
   
   cs = ChallengeMyTowerState.PLACING_TOWER;
   rulerEngine = setupRulers();
   UI = new ChallengeUI(rulerEngine,this);
   gs = GameState.CHALLENGE; 
   control = new ChallengeControl(this);
   kinectDrawDelegate = new KinectArtistForChallenge(this);
   towerOK = false;
  }
  
  
 private boolean assureValid(){
   if(towers.size() == 1 && rulerEngine.tallEnough)return true;
   else return false;
 }
 
 private void towerChecking(){
   if(towers.size() <= 1)
      {
        if(towers.size() == 0)
        {
          // This is for the case where no block is placed on table
          
          cs = ChallengeMyTowerState.PLACING_TOWER;
        }
        else 
        { // This is for the case where only one block is located, which we desire to have
          
          if(rulerEngine.tallEnough){
            // if a block is higher than the ruler
            cs = ChallengeMyTowerState.ENOUGH;
          } else {
            // what if not...
            
            cs = ChallengeMyTowerState.TOO_SHORT;            
          }

        }
      } // end of if (tower <= 1)
      else{
        cs = ChallengeMyTowerState.TOO_MANY_FIRST; 
      }    
 }
   
 void play(){
   switch(cs){
     case PLACING_TOWER:
      towerChecking();
      break;
      
      case TOO_MANY_FIRST:
      
      towerChecking();
      break;
      
      
      
      case ENOUGH:
      
      
      
      handsOffTime = System.currentTimeMillis();
      cs = ChallengeMyTowerState.ENOUGH_DELAY;
      openHandsOff(rulerEngine);
      
      
      break;
      
      case ENOUGH_DELAY:
      long currentT = System.currentTimeMillis();
      if(currentT - handsOffTime > 2000){
        closeHandsOff(rulerEngine);
        if(assureValid())uiengine.turnBtn(new int[]{4},true);
        else{
          uiengine.turnBtn(new int[]{4},false);
          cs = ChallengeMyTowerState.PLACING_TOWER;
        }
      }
      
      break;
      
      case TOO_SHORT:
      
      towerChecking();
      
      break;
      
      case SHAKING:

      //need timer
      long currTime = System.currentTimeMillis();
      if(shakingTimeout < currTime)
      {
        fallTime = 5000;
        cs = ChallengeMyTowerState.SUCCESS;  
        relayOff();
        println("SHAKING -> FAIL");
        shakingTimeout = System.currentTimeMillis() + 5000;
      }
      
      if(towerIndex.size() < 1)
      {
        fallTime = currTime - startTime;
        relayOff();
        fallen = "challengeMyTowerFell";
        cs = ChallengeMyTowerState.FAIL;
        
        println("SHAKING -> FAIL");
        
        elapsedTime = Math.min(5000,currTime - startTime);
        shakeTime = String.format("%.2f", (elapsedTime/1000)) + " sec";

        shakingTimeout = System.currentTimeMillis() + 5000;
        return;   
      }
     
      
      leftFallingHeight = towerFallingHeight(bd,towerIndex.get(0),leftHeight);
      leftFallingAngle1 = towerFallingAngle(bd,towerIndex.get(0),leftAngle1,0);
      leftFallingAngle2 = towerFallingAngle(bd,towerIndex.get(0),leftAngle1,1);
      leftFallingDensity = towerFallingAngle(bd,towerIndex.get(0),leftDensity,2);
      

      leftFalling = towerFallingFinalDecision(leftFallingHeight, leftFallingAngle1, leftFallingAngle2, leftFallingDensity);
      
      if (leftFalling == "Fallen")
      {
        fallen = "tmtFell";
        fallTime = currTime - startTime;
        relayOff();
        cs = ChallengeMyTowerState.FAIL;
        println("SHAKING -> FAIL (Fallen)");
        shakingTimeout = System.currentTimeMillis() + 5000;   //drawTextOnTablet(shakeTime);
      }
     
      break;
      
      case FAIL:
      
      towerOK = false;
      //cs = ChallengeMyTowerState.RESET;
      //println("FAIL -> RESET");
      uiengine.turnBtn(new int[]{3},true);
      break;
      
      case SUCCESS:
      towerOK = true;
      //cs = ChallengeMyTowerState.RESET;
      
     // println("FAIL -> RESET");
     
      uiengine.turnBtn(new int[]{3},true);
     
      break;
      
      case RESET:
      
     // cs = ChallengeMyTowerState.PLACING_TOWER;
      
      relayFlag = 0;
      
      break;
      }
     // println(cs);
   }
   
   
//    ChallengeMyTowerState getChallengeMyTowerState(){return cs;}
     
}
