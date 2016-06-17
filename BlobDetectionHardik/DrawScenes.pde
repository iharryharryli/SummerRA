
//long mainMenuAnimationTimer = 0;

int numDances = 0;

public void drawMainMenuCore(int screenID){
   uiengine.clearStage(screenID);
   uiengine.switchOn(new int[]{1,2});
   uiengine.drawConstants(screenID,new int[]{5,0});
   
}



 public void drawMainGameCore(int screenID){
  uiengine.clearStage(screenID);
  
  //draw backgrounds
  if(ms == MainGameState.TRANSITION){
    uiengine.drawConstants(screenID,new int[]{5,0});
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

public void drawTestMyTowerSpecial(int screenID, int stage){
  if(stage == 1){
    uiengine.drawConstants(screenID,new int[]{24});
  }
  else if(stage == 2){
    uiengine.drawConstants(screenID,new int[]{25});
  }
  else if(stage == 3){
    uiengine.drawConstants(screenID,new int[]{26});
  }
  else if(stage == 4){
    uiengine.drawConstants(screenID,new int[]{23});
  }
}

public void setTestMyTowerStages(int[] x){
  TestMyTowerStages = null;
  TestMyTowerStages = x;
}
  

public void drawTestMyTowerCore(int screenID){
  uiengine.clearStage(screenID);
  
  if(ts == TestMyTowerState.TRANSITION)
  {
    uiengine.drawConstants(screenID,new int[]{5});
  }
  else{
    uiengine.drawConstants(screenID,new int[]{8});
  }
  
  textengine.drawText(screenID);
  
  if(TestMyTowerStages != null){
    for(int i=0; i<TestMyTowerStages.length; i++){
      drawTestMyTowerSpecial(screenID,TestMyTowerStages[i]);
    }
  }
  
  //things only appear on the TV
  if(screenID == 1){
   if(ts == TestMyTowerState.RESULT && fallen.equals(""))
    {
      uiengine.drawConstants(screenID,new int[]{22});
    }
    else if(ts == TestMyTowerState.RESULT){
      uiengine.drawConstants(screenID,new int[]{10});
    }
    else if(ts == TestMyTowerState.SHAKING)
    {
      uiengine.drawConstants(screenID,new int[]{11});
    }
    else{
      uiengine.drawConstants(screenID,new int[]{0});
    }
  }
  
}



public void drawTestMyTower()
{
  int screenID = 0;
  drawTestMyTowerCore(screenID);
}


public void drawTestMyTower(GWinApplet appc)
{
  
    int screenID = 1;
    drawTestMyTowerCore(screenID);
    
   
    
    if(ts != TestMyTowerState.RESET && TestMyTowerIsDrawingKinect)
    {
      projectorDrawTowers(appc);
    }
      
    if((ts == TestMyTowerState.SHAKING) || (ts == TestMyTowerState.RESULT && elapsedTime != 5000))
    {
      
      /*appc.fill(32);
      appc.textSize(30);
     // appc.text(shakeTime, projHourglass.x + projectorWidth*.06,  projHourglass.y + hg.height*.3);
     appc.text(shakeTime, projHourglass.x + projectorWidth*.06,  projHourglass.y + hgDummy.height*.3);*/
      drawTextOnProjector(appc,shakeTime);
    }
  
}


public void projectorDrawTowers(PApplet appc)
{
    
  appc.image(pgKinectProjector,0,0);
  
}

  
public PGraphics createKinectGraphProjector(){
  PGraphics res = createGraphics(projectorWidth,projectorHeight);
  res.beginDraw();
  ArrayList<Contour> projContours = getContours();
  res.pushMatrix();
    res.fill(140, 255, 140);   
    res.stroke(0, 200, 0);
    res.strokeWeight(3);
    res.translate(projectorWidth*0.29,-projectorHeight*0.03);
    res.scale(0.85*((float)projectorWidth/640.0),((float)projectorHeight/480.0));
      for (int i=0; i<projContours.size(); i++)
    {
       if(!fallen.equals(""))
       {
          Rectangle r = projContours.get(i).getBoundingBox();
          if(fallen.equals("left") && ((r.x + r.width/2) < kinectCenter))
          {
            res.fill(255, 140, 140);
            res.stroke(255, 0, 0);
          }
          else if(fallen.equals("left") && ((r.x + r.width/2) > kinectCenter))
          {
            res.fill(140, 255, 140);
            res.stroke(0, 200, 0);
          }
          else if(fallen.equals("right") && ((r.x + r.width/2) < kinectCenter))
          {
            res.fill(140, 255, 140);
            res.stroke(0, 200, 0);
          }
          else if(fallen.equals("right") && ((r.x + r.width/2) > kinectCenter))
          {
            res.fill(255, 140, 140);
            res.stroke(255, 0, 0);
          }
          else if(fallen.equals("tmtFell"))
          {
            res.fill(255, 140, 140);
            res.stroke(255, 0, 0);
          }
       }
        
        res.beginShape();
          for (PVector point : projContours.get(i).getPoints())
          {
            res.vertex(point.x, point.y);
         
          }
          res.endShape();
  
    }
    res.popMatrix();
   
  res.endDraw();
 
  return res;
}

