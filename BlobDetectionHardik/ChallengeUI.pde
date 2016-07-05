//Global Variable

//setup - part of the creatGUI()
public RulerEngine setupRulers(){
  
  int tw = touchscreenWidth, th = touchscreenHeight, pw = projectorWidth, ph = projectorHeight;
  
  Ruler tabletRuler = new Ruler(this,Math.round(0.1*touchscreenWidth),Math.round(0.7*touchscreenHeight),"ChallengeMode/ruler.png",
                                          0.57*touchscreenWidth, 0.7*touchscreenHeight,0.45);
  Ruler projectorRuler = new Ruler(projectorDrawDelegate,Math.round(0.1*projectorWidth),Math.round(0.7*projectorHeight),"ChallengeMode/ruler.png",
                                          0.72*projectorWidth, 0.68*projectorHeight,0.45);                                        
  tabletRuler.components = new RulerAppend[]{new RulerAppend(tw*0.1,0,"ChallengeMode/HandsOff.png",-0.05*tw,-0.2*th),
                                              new RulerAppend(tw*0.1,0,"ChallengeMode/check.png",-0.05*tw,-0.2*th),
                                             new RulerAppend(tw*0.1,0,"ChallengeMode/cross.png",-0.05*tw,-0.2*th),
                                              };
  projectorRuler.components = new RulerAppend[]{new RulerAppend(pw*0.1,0,"ChallengeMode/HandsOff.png",-0.05*pw,-0.2*ph),
                                                  new RulerAppend(pw*0.1,0,"ChallengeMode/check.png",-0.05*pw,-0.2*ph),
                                                new RulerAppend(pw*0.1,0,"ChallengeMode/cross.png",-0.05*pw,-0.2*ph)
                                                };
  
  HarryGlobal.standardRulerHeight = 0.7 * 480;
 
  RulerEngine rulerEngine = new RulerEngine(new Ruler[]{tabletRuler,projectorRuler},0);
  return rulerEngine;
}

public void indicateTowerState(RulerEngine engine,int x){
  for(int i=0;i<2;i++){
    for(int j=0; j<engine.rulers[i].components.length; j++)
        engine.rulers[i].components[j].on = false;
  }
   if(x<0)return;
    for(int i=0;i<2;i++){
      engine.rulers[i].components[x].on = true;
    }
 
}



//Cores

class ChallengeUI{
  
  RulerEngine rulerEngine;
  
  ChallengeLogic logic;
  
  public ChallengeUI(RulerEngine r,ChallengeLogic l){
    rulerEngine = r;
    logic = l;
    uiengine.switchOn(new int[]{});
    uiengine.turnBtn(new int[]{6},true);
  }

  void drawTransition(int screenID){
    uiengine.drawConstants(screenID,new int[]{5,0,29});
  }

  public void drawChallengeCore(int screenID){
    uiengine.clearStage(screenID);
    
    if(logic.cs == ChallengeMyTowerState.TRANSITION){
      drawTransition(screenID);
      return;
    }
    
    uiengine.drawConstants(screenID,new int[]{8});
    //Things should happen now
    
    
      
    
    
    if(logic.cs == ChallengeMyTowerState.RESET){
      if(screenID==1)uiengine.drawConstants(screenID,new int[]{0});
      uiengine.drawConstants(screenID,new int[]{23});
    }
    else if(logic.cs == ChallengeMyTowerState.PLACING_TOWER || logic.cs == ChallengeMyTowerState.ENOUGH || logic.cs == ChallengeMyTowerState.ENOUGH_DELAY){
      if(screenID==1)uiengine.drawConstants(screenID,new int[]{0});
    }
    else if(logic.cs == ChallengeMyTowerState.TOO_SHORT || logic.cs == ChallengeMyTowerState.TOO_MANY_FIRST){
      if(screenID==1)uiengine.drawConstants(screenID,new int[]{10});
      
    }
    else if(logic.cs == ChallengeMyTowerState.SUCCESS){
      if(screenID==1)uiengine.drawConstants(screenID,new int[]{22});
    }
    else if(logic.cs == ChallengeMyTowerState.SHAKING){
      if(screenID==1)uiengine.drawConstants(screenID,new int[]{11});
      uiengine.drawConstants(screenID,new int[]{26});
      drawTimeText(logic.shakedTimeText,screenID);
      
    }
    else if(logic.cs == ChallengeMyTowerState.FAIL){
      if(screenID==1)uiengine.drawConstants(screenID,new int[]{30});
      uiengine.drawConstants(screenID,new int[]{26});
      drawTimeText(logic.shakedTimeText,screenID);
    }
    
    
    
    
    textengine.drawText(screenID);
    if(logic.cs == ChallengeMyTowerState.PLACING_TOWER && logic.realTowerNum == 0)uiengine.drawConstants(screenID,new int[]{24});
    
    if(logic.cs != ChallengeMyTowerState.RESET){
        drawKinectTowers(screenID);
        if(logic.cs != ChallengeMyTowerState.SHAKING && logic.cs != ChallengeMyTowerState.SUCCESS && logic.cs != ChallengeMyTowerState.FAIL)rulerEngine.drawOn(screenID);
    }
    
    if(logic.cs == ChallengeMyTowerState.TOO_MANY_FIRST){
        uiengine.drawConstants(screenID,new int[]{31});
      }
    
   
  }
  
  public void drawKinectTowers(int screenID){
    if(screenID == 0)drawCon();
    else if(screenID == 1)projectorDrawTowers(projectorDrawDelegate);
  }
  
  //Tablet Stuff
  public void drawChallengeTablet(){
    int screenID = 0;
    drawChallengeCore(screenID);
  }
  
  //Projector Stuff
  public void drawChallengeProjector(){
    int screenID = 1;
    drawChallengeCore(screenID);
  }
  
  private void drawTimeText(String t, int screenID){
    if(screenID == 0){
      drawTextOnTablet(t);
    }
    else if(screenID == 1){
      drawTextOnProjector(projectorDrawDelegate,t);
    }
  }

}

//Library

class RulerAppend{
  
  PImage img;
  float posX,posY;
  boolean on;
  
  public RulerAppend(float ww, float hh, String file, float offsetX, float offsetY){
    int www = Math.round(ww);
    int hhh = Math.round(hh);
    img = loadImage(file);
    img.resize(www,hhh);
    posX = offsetX;
    posY = offsetY;
    on = false;
  }
  
  public void drawMe(PApplet delegate, PVector pos){
    if(on){

      delegate.image(img,pos.x+posX,pos.y+posY);
      
    }
  }
}


class Ruler{
  PApplet delegate;
  PImage rulerImg;
  PImage drawImg;
  PVector curPos;
  PVector defaultPos;
  PVector appendPos;
  
  boolean rulerOn;
  
  RulerAppend[] components;
  
  
  private PImage getDrawImg(float len){
    int x = Math.round(rulerImg.height*(1-len));
    int y = Math.round(rulerImg.height*len);
    return rulerImg.get(0,x,rulerImg.width,y);
  }
  
  public Ruler(PApplet a,int w,int h,String add,float x,float y,float len){
    rulerOn = false;
    delegate = a;
    rulerImg = loadImage(add);
    rulerImg.resize(w,h);
    curPos = new PVector(x,y);
    defaultPos = new PVector(x,y);
    drawImg = getDrawImg(len);
    appendPos = new PVector(0,0);
  }
  
  public void drawMe(){
    if(rulerOn)delegate.image(drawImg,curPos.x,curPos.y);
    if(components != null){
      for(int i=0; i<components.length; i++){
        components[i].drawMe(delegate,appendPos);
      }
    }
  }
  
  public void reSize(float len){
    drawImg = null;
    drawImg = getDrawImg(len);
    updatePos(-1,-1,-1,-1);
  }
  
  public void updatePos(float leftmost, float rightmost, float top, float bottom){
    
    curPos.x = rightmost ;
    curPos.y = bottom - drawImg.height;
    appendPos.x = (leftmost+rightmost)/2;
    appendPos.y = top;
    
    if(curPos.y < 30){
      curPos.x = defaultPos.x;
      curPos.y = defaultPos.y - drawImg.height;
    }
    
    
  }
  
  public boolean measure(float someY){
    if(someY<=curPos.y)return true;
    return false;
  }
}
class RulerEngine{
  
  Ruler[] rulers;
  int target;
  boolean tallEnough;
  
  
  
  public RulerEngine(Ruler[] x,int t){
    rulers = x;
    target = t;
    tallEnough = false;
  }
   
  public void drawOn(int i){
    rulers[i].drawMe();
  }
  
  public void turnOnRulers(){
    for(int i=0; i<rulers.length; i++)rulers[i].rulerOn = true;
  }
  
  public void updateRuler(int i, float a, float b, float c, float d){
    rulers[i].updatePos(a,b,c,d);
  }
  
  public void measureTower(float someY){
     tallEnough = rulers[target].measure(someY);
     
     //println(tallEnough);
  }
  
  public void resizeByHeight(float h){
    
    float ratio = h/HarryGlobal.standardRulerHeight;
    
      for(int i=0; i<rulers.length; i++){
        rulers[i].reSize(ratio);
      }
  }
  
}

