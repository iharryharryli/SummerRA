//Global Variable

//setup - part of the creatGUI()
public RulerEngine setupRulers(){
  
  int tw = touchscreenWidth, th = touchscreenHeight, pw = projectorWidth, ph = projectorHeight;
  
  Ruler tabletRuler = new Ruler(this,0,Math.round(0.7*touchscreenHeight),"ChallengeMode/ruler.png",
                                          0.5*touchscreenWidth, 0.42*touchscreenHeight,0.4);
  Ruler projectorRuler = new Ruler(projectorDrawDelegate,0,Math.round(0.7*projectorHeight),"ChallengeMode/ruler.png",
                                          0.75*projectorWidth, 0.4*projectorHeight,0.4);                                        
  tabletRuler.components = new RulerAppend[]{new RulerAppend(tw*0.2,th*0.2,"ChallengeMode/HandsOff.png",-0.15*tw,-0.2*th)};
  projectorRuler.components = new RulerAppend[]{new RulerAppend(pw*0.2,ph*0.2,"ChallengeMode/HandsOff.png",-0.15*pw,-0.2*ph)};
  
 
  RulerEngine rulerEngine = new RulerEngine(new Ruler[]{tabletRuler,projectorRuler},0);
  return rulerEngine;
}

public void openHandsOff(RulerEngine engine){
   engine.rulers[0].components[0].on = true;
   engine.rulers[1].components[0].on = true;
}

public void closeHandsOff(RulerEngine engine){
   engine.rulers[0].components[0].on = false;
   engine.rulers[1].components[0].on = false;
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

  public void drawChallengeCore(int screenID){
    uiengine.clearStage(screenID);
    uiengine.drawConstants(screenID,new int[]{8});
    //Things should happen now
    
    drawKinectTowers(screenID);
    rulerEngine.drawOn(screenID);
    
    if(logic.cs == ChallengeMyTowerState.PLACING_TOWER || logic.cs == ChallengeMyTowerState.ENOUGH || logic.cs == ChallengeMyTowerState.ENOUGH_DELAY){
      textengine.changeText(0);
      if(screenID==1)uiengine.drawConstants(screenID,new int[]{0});
    }
    else if(logic.cs == ChallengeMyTowerState.TOO_SHORT || logic.cs == ChallengeMyTowerState.TOO_MANY_FIRST){
      if(screenID==1)uiengine.drawConstants(screenID,new int[]{10});
      if(logic.cs == ChallengeMyTowerState.TOO_MANY_FIRST){
        uiengine.drawConstants(screenID,new int[]{31});
      }
    }
    else if(logic.cs == ChallengeMyTowerState.SUCCESS){
      if(screenID==1)uiengine.drawConstants(screenID,new int[]{22});
    }
    else if(logic.cs == ChallengeMyTowerState.SHAKING){
      if(screenID==1)uiengine.drawConstants(screenID,new int[]{11});
    }
    else if(logic.cs == ChallengeMyTowerState.FAIL){
      if(screenID==1)uiengine.drawConstants(screenID,new int[]{30});
    }
    
    
    textengine.drawText(screenID);
    
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
  
  public void drawMe(PApplet delegate, float x, float y){
    if(on){
      
      
      delegate.image(img,x+posX,y+posY);
      
    }
  }
}


class Ruler{
  PApplet delegate;
  PImage rulerImg;
  PImage drawImg;
  PVector curPos;
  PVector defaultPos;
  
  RulerAppend[] components;
  
  
  private PImage getDrawImg(float len){
    int x = Math.round(rulerImg.height*(1-len));
    int y = Math.round(rulerImg.height*len);
    return rulerImg.get(0,x,rulerImg.width,y);
  }
  
  public Ruler(PApplet a,int w,int h,String add,float x,float y,float len){
    delegate = a;
    rulerImg = loadImage(add);
    rulerImg.resize(w,h);
    curPos = new PVector(x,y);
    defaultPos = new PVector(x,y);
    drawImg = getDrawImg(len);
  }
  
  public void drawMe(){
    delegate.image(drawImg,curPos.x,curPos.y);
    if(components != null){
      for(int i=0; i<components.length; i++){
        components[i].drawMe(delegate,curPos.x,curPos.y);
      }
    }
  }
  
  public void reSize(float len){
    drawImg = null;
    drawImg = getDrawImg(len);
  }
  
  public void updatePos(PVector some){
    
    curPos.x = some.x ;
    curPos.y = some.y - drawImg.height;
    
    if(curPos.y < 30){
      curPos.x = defaultPos.x;
      curPos.y = defaultPos.y;
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
  
  public void updateRuler(int i, PVector n){
    rulers[i].updatePos(n);
  }
  
  public void measureTower(float someY){
     tallEnough = rulers[target].measure(someY);
     
     //println(tallEnough);
  }
  
}
class KinectArtistForChallenge{
  
   ChallengeLogic logic;
  
   public KinectArtistForChallenge(ChallengeLogic x){
     logic = x;
   }
  
   void updateProjectorRuler(float x, float y){
            
            float offsetX = 0, offsetY = 0.08;
            
            x *= 0.85*((float)projectorWidth/640.0);
            y *= ((float)projectorHeight/480.0);
            x += projectorWidth*0.2;
            y += -projectorHeight*0.03;
            x += projectorWidth*offsetX;
            y += projectorHeight*offsetY;
            
            logic.rulerEngine.updateRuler(1,new PVector(x,y));
            
     }

  
  
  public PGraphics drawProjector(){
          PGraphics res = createGraphics(projectorWidth,projectorHeight);
          res.beginDraw();
          res.pushMatrix();
          res.strokeWeight(3);
          res.translate(projectorWidth*0.2,-projectorHeight*0.03);
          res.scale(0.85*((float)projectorWidth/640.0),((float)projectorHeight/480.0));
          ArrayList<Contour> projContours = getContours();
          
          float lowestX = 0, lowestY = 0;
         
   
          if(logic.towerOK){
              res.fill(140, 255, 140);   
              res.stroke(0, 200, 0);
          }
          else{
              res.fill(255, 140, 140);
             res.stroke(255, 0, 0);
          }
      
            
            
             for (int i=0; i<projContours.size(); i++)
             {  
                res.beginShape();
                  for (PVector point : projContours.get(i).getPoints())
                  {
                    res.vertex(point.x, point.y);
                    if(point.y>lowestY)lowestY=point.y;
                         if(point.x>lowestX)lowestX=point.x;
                  }
                  res.endShape();
          
            }
            res.popMatrix();
           
          res.endDraw();
          updateProjectorRuler(lowestX,lowestY);   


          return res;
      }
  
   void updateTabletRuler(float x, float y){
          
          float offsetX = 0, offsetY = 0.07;
          
          x *= .85*((float)width/640.0);
          y *= ((float)height/480.0);
          x += touchscreenWidth*.07;
         // y += -touchscreenHeight*0.05;
          x += touchscreenWidth*offsetX;
          y += touchscreenHeight*offsetY;
  
          logic.rulerEngine.updateRuler(0,new PVector(x,y));
   }
  
  public PGraphics drawTablet(){
    PGraphics res = createGraphics(touchscreenWidth,touchscreenHeight);
          res.beginDraw();
          res.pushMatrix();
            res.strokeWeight(3);
            res.translate(touchscreenWidth*.07,0);
            res.scale(0.85*((float)touchscreenWidth/640.0),((float)touchscreenHeight/480.0));
          ArrayList<Contour> projContours = getContours();
          
          float lowestY = 0, lowestX = 0, highest = 999999;
          
          
          
   
          if(logic.towerOK){
              res.fill(140, 255, 140);   
              res.stroke(0, 200, 0);
          }
          else{
              res.fill(255, 140, 140);
             res.stroke(255, 0, 0);
          }
          
         for (int i=0; i<projContours.size(); i++)
             {  
                res.beginShape();
                  for (PVector point : projContours.get(i).getPoints())
                  {
                    res.vertex(point.x, point.y);
                         if(point.y>lowestY)lowestY=point.y;
                         if(point.x>lowestX)lowestX=point.x;
                         if(point.y<highest)highest=point.y;
                   
                  }
                  res.endShape();
          
            }
            res.popMatrix();
           
          res.endDraw();
          
          updateTabletRuler(lowestX,lowestY);
          logic.rulerEngine.measureTower((tabletCoordinateMassage(0,highest)).y);
          if(logic.cs != ChallengeMyTowerState.SHAKING && logic.cs != ChallengeMyTowerState.FAIL && logic.cs != ChallengeMyTowerState.SUCCESS)
                  logic.towerOK = logic.rulerEngine.tallEnough;
          if(logic.cs == ChallengeMyTowerState.TOO_MANY_FIRST) logic.towerOK = false;

          return res;
  }
  
  PVector tabletCoordinateMassage(float x, float y){
        x *= .85*((float)width/640.0);
        y *= ((float)height/480.0);
        x += touchscreenWidth*.07;
       // y += -touchscreenHeight*0.05;
        return new PVector(x,y);
    }
 
}
