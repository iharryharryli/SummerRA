
//long mainMenuAnimationTimer = 0;

int numDances = 0;

public void drawMainMenuCore(int screenID){
   uiengine.clearStage(screenID);
  
   uiengine.drawConstants(screenID,new int[]{5,0});
   
}



 public void drawMainGameCore(int screenID){
  uiengine.clearStage(screenID);
  
  //draw backgrounds
  if(ms == MainGameState.TRANSITION){
    
    uiengine.drawConstants(screenID,new int[]{5,0,27});
  }
  else{
    if(ms == MainGameState.PLACING_TOWERS || ms == MainGameState.REASON){
      uiengine.drawConstants(screenID,new int[]{7});
    }
    else{
      uiengine.drawConstants(screenID,new int[]{8});
    }
  }
  
  //Most things should happen now!
  textengine.drawText(screenID);
   towerengine.drawTower(screenID);
  
  if(ms == MainGameState.RESET){
    uiengine.drawConstants(screenID,new int[]{23});
  }
  else if(ms == MainGameState.UNEXPECTED_OUTCOME){
    uiengine.drawConstants(screenID,new int[]{32});
  }
  
  if(screenID == 1){
    
    if(ms == MainGameState.REASON_PREDICTION && guess.equals(fallen)){
      uiengine.drawConstants(screenID,new int[]{9});
    }
    else if(ms == MainGameState.REASON_PREDICTION){
      uiengine.drawConstants(screenID,new int[]{10});
    }
    else if(ms == MainGameState.SHAKING)
    {
      uiengine.drawConstants(screenID,new int[]{11});
    }
    else
    {
      uiengine.drawConstants(screenID,new int[]{0});
    }
    
  }
    
    
}
  

public void drawMainMenu()
{
  int screenID = 0;
  drawMainMenuCore(screenID);
}

public void drawMainMenuProj(GWinApplet appc)
{
  int screenID = 1;
  drawMainMenuCore(screenID);
}

public void drawMainGame()
{
  int screenID = 0;
  drawMainGameCore(screenID);
}

int currSprite = 0;
long lastFrame = System.currentTimeMillis();

public void drawMainGameProj(GWinApplet appc)
{
  
  int screenID = 1;
  drawMainGameCore(screenID);
 
  
  if((gs == GameState.MAIN_GAME && (ms == MainGameState.FALL_PREDICTION || ms == MainGameState.SHAKING || ms == MainGameState.REASON_PREDICTION)) || gs == GameState.TEST_MY_TOWER)
  {
    
    projectorDrawTowers(appc);
  }
  
  if(ms == MainGameState.UNEXPECTED_OUTCOME)
  {
   
    
   // appc.image(howToPlaceResizedDummy, unexpectedImgProj.x, unexpectedImgProj.y - howToPlaceResizedDummy.height);
  }


}


  



public void projectorDrawTowers(PApplet appc)
{
    
  appc.image(pgKinectProjector,0,0);
  
}


public void setupHomeScene(){
  uiengine.switchOn(new int[]{1,2});
}
  


