class ChallengeControl{
  ChallengeLogic father;
  public ChallengeControl(ChallengeLogic f){
    father = f;
  }
  
  public void shakeBtnClick(){  
    if(towers.size() != 1 || towerIndex.size() != 1)return;
       
        leftHeight = bd.getBlobHeight(towerIndex.get(0));
        
        float[] eigArray = getBlobEigen(bd, towerIndex.get(0));  
        float[] moiArray = calculateMoI(bd, towerIndex.get(0));
        
        leftAngle = eigArray[0];
        leftDensity = eigArray[1]; 
        
        leftMoIx = moiArray[0];
        leftMoIy = moiArray[1];
        
        shakingTimeout = System.currentTimeMillis() + 5000;
        startTime = System.currentTimeMillis();
        father.cs = ChallengeMyTowerState.SHAKING;
        uiengine.turnBtn(new int[]{4},false);
        father.audio.shutUp();
        relayOn();
        tableHoldTimeout = System.currentTimeMillis();
        centroidTower.clear(); 
  }
  
  public void handOver(){
          
          father.destroy();
          father = null;
  }
  
  public void transition(){
    father.cs = ChallengeMyTowerState.TRANSITION;
    father.audio.play(5);
    uiengine.turnBtn(new int[]{1,2},true);
    uiengine.turnBtn(new int[]{6},false);
  }
  
  private void upgrade(){
    father.cs = ChallengeMyTowerState.INITIAL;
    
        if(father.noRuler && CHALLENGE_MODE_ON){
          father.noRuler=false;
          father.rulerEngine.turnRulers(true);
        }
    
  }
  
  public void continueBtnClick(){
      uiengine.turnBtn(new int[]{3},false);
      father.trials ++;
      father.audio.shutUp();
      if(father.cs == ChallengeMyTowerState.SUCCESS && father.challengeReceived % 6 != 0){
        upgrade();
      }
      else if(father.trials > 2 || father.cs == ChallengeMyTowerState.SUCCESS){
          transition();
      }
      else{
        father.gotoMain();
      }
      
  }
  
  public void keepPlayingClick(){
    
    uiengine.switchOn(new int[]{6});
    
    if(father.success){
      //father.challengeReceived = 0;
      father.cs = ChallengeMyTowerState.INITIAL;
    }
    else{
      father.trials = 0;
      father.gotoMain();
    }
  }
       
  
}

class ChallengeLogic{
  
  ChallengeMyTowerState cs;
    
  RulerEngine rulerEngine;
  
  ChallengeUI UI;
  
  ChallengeControl control;
  
  AudioEngine audio;
  
  boolean towerOK;
  
  int fallenCount;
  
  private long startCheckingTimeout;
 
  
  
  int trials;
  
  int challengeReceived;
  
  String shakedTimeText;
  
  boolean success;
  
  boolean noRuler;
  
  ChallengeLogic(){
   
   cs = ChallengeMyTowerState.INITIAL;
   rulerEngine = setupRulers();
   UI = new ChallengeUI(rulerEngine,this);
   
   control = new ChallengeControl(this);
   
   towerOK = false;
   shakedTimeText = "";
   trials = 0;
   challengeReceived = 0;
   success = false;
   noRuler = true;
   
   audio = HarryGlobal.audioEngine;
  }
  
  void switchIn(){
    cs = ChallengeMyTowerState.INITIAL;
    rulerEngine.turnRulers(false);
    rulerEngine.changeRulerShape(-1);
    towerOK = false;
     shakedTimeText = "";
     trials = 0;
     challengeReceived = 0;
     success = false;
     noRuler = true;
     HarryGlobal.kinectDrawDelegate = null;
     HarryGlobal.kinectDrawDelegate = new KinectForChallenge(HarryGlobal.kinectDrawer,this);
     gs = GameState.CHALLENGE; 
     
  }
  
 
  
  
 private boolean assureValid(){
   if(towers.size() == 1 && rulerEngine.tallEnough)return true;
   else return false;
 }
 
 private void towerChecking(){
   if(System.currentTimeMillis() < startCheckingTimeout)return;
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
 
 private void resultCommon(){
   if(towers.size() == 0)control.continueBtnClick();
 }
   
 void play(){
   
   
   switch(cs){
     case PLACING_TOWER:
      
      if(noRuler)textengine.changeText(31);
      else textengine.changeText(39);
      towerChecking();
      indicateTowerState(rulerEngine,-1);
      break;
      
      case TOO_MANY_FIRST:
      //textengine.changeText(28);
      if(!audio.isPlaying())audio.playOnce(2);
      towerChecking();
      indicateTowerState(rulerEngine,-1);
      if(cs != ChallengeMyTowerState.TOO_MANY_FIRST && audio.lastPlayed == 2)audio.shutUp();
      
      break;
      
      
      
     
      
      case ENOUGH:
      fallenCount = 0;
      HarryGlobal.canRegisterHeight = true;
      
      
      long currentT = System.currentTimeMillis();
      
      if(assureValid()){
        
          indicateTowerState(rulerEngine,1);
          uiengine.turnBtn(new int[]{4},true);
//          if(noRuler) textengine.changeText(31);
//          else textengine.changeText(36);
        
      }
      else{
        
        uiengine.turnBtn(new int[]{4},false);
          cs = ChallengeMyTowerState.PLACING_TOWER;
      }
      

      
      break;
      
      case TOO_SHORT:
      //if(!noRuler)textengine.changeText(35);
      indicateTowerState(rulerEngine,2);
      towerChecking();
      
      break;
      
      case SHAKING:
      
      HarryGlobal.canRegisterHeight = false;
      
      indicateTowerState(rulerEngine,-1);
      //need timer
      long currTime = System.currentTimeMillis();
      elapsedTime = Math.min(5000,currTime - startTime);
        shakedTimeText = String.format("%.2f", (elapsedTime/1000)) + " sec";
        
      if(shakingTimeout < currTime)
      {
        fallTime = 5000;
        cs = ChallengeMyTowerState.SUCCESS;  
        relayOff();
        println("SHAKING -> SUCCESS");
        shakingTimeout = System.currentTimeMillis() + 5000;
      }
      
      if(towerIndex.size() < 1)
      {
        fallTime = currTime - startTime;
        relayOff();
        fallen = "challengeMyTowerFell";
        cs = ChallengeMyTowerState.FAIL;
        
        println("SHAKING -> FAIL");
        
        

        shakingTimeout = System.currentTimeMillis() + 5000;
        return;   
      }
     
      
      leftFallingHeight = towerFallingHeight(bd,towerIndex.get(0),leftHeight);
      leftFallingAngle = towerFallingAngle(bd,towerIndex.get(0),leftAngle,leftDensity);
      //leftFallingMoI = towerFallingMoI(bd,towerIndex.get(0),leftMoIx,leftMoIy); // for later use
      //println(leftFallingMoI);

      
      leftFalling = towerFallingFinalDecision(leftFallingHeight, leftFallingAngle);
      if (leftFalling == "Fallen")fallenCount++;
      else fallenCount = 0;
      if (fallenCount > HarryGlobal.fallenCountThreshold)
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
      audio.playOnce(4);
      textengine.changeText(37);
      towerOK = false;
      uiengine.turnBtn(new int[]{3},true);
      resultCommon();
      success = false;
      break;
      
      case SUCCESS:
      audio.playOnce(3);
      textengine.changeText(41);
      towerOK = true;
      uiengine.turnBtn(new int[]{3},true);
      resultCommon();
      success = true;
      break;
      
      case RESET:
      textengine.changeText(7);
      if(towers.size()==0){
        audio.shutUp();
        cs = ChallengeMyTowerState.SETUP; 
      } 
     
    
      break;
      
      case SETUP:
      
      float newChallengeDelta = 15;
      trials = 0;   
      if(noRuler)rulerEngine.resizeByHeight(0.01);
      else {
        float temp = HarryGlobal.towerHeightInPixel + newChallengeDelta;
        if(temp < 80)temp = 80;
        rulerEngine.resizeByHeight(temp);
      }
      challengeReceived ++;   
      rulerEngine.changeRulerShape(challengeReceived-2);
      gotoMain();
      
      break;
      
      case TRANSITION:
      break;
      
      case INITIAL:
      audio.cleanUp();
      if(towers.size()!=0)audio.play(0);
      cs = ChallengeMyTowerState.RESET;
      break;
      }
   }
   
   public void gotoMain(){
     cs = ChallengeMyTowerState.PLACING_TOWER;
     startCheckingTimeout = System.currentTimeMillis() + 1000;
     audio.cleanUp();
     if(trials==0){
       if(noRuler)audio.play(1);
     }
   }
   
   public void destroy(){
     HarryGlobal.kinectDrawDelegate = null;
     HarryGlobal.kinectDrawDelegate = new KinectForGames(HarryGlobal.kinectDrawer);
     rulerEngine = null;
     UI = null;
     control = null;
     System.gc();
   }
        
}
