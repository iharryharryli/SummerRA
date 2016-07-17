public class CompeteUI {
  UIEngine engine;
  CompeteLogic logic;
  TextEngine engineText;
  
  SideManager[] sides;
  public CompeteUI(CompeteLogic some){
    logic = some; 
    UIScreen s1 = new UIScreen(tabletDrawDelegate,new PVector(touchscreenWidth,touchscreenHeight),"AssetsTablet/");
    UIScreen s2 = new UIScreen(projectorDrawDelegate,new PVector(projectorWidth,projectorHeight),"AssetsProjector/");
    engine = new UIEngine(new UIScreen[]{s1,s2});
    /*
    UIElement IDs:
    
    Images:
    0: background
    1: table
    2: blue pig
    3: red pig
    4: gorilla
    9: remove arrows
   
    
    Buttons:
    5: shake
    8: continue
    
    Animations:
    6: blue pig
    7: pink pig
    
    */
    UIElement[] lib = new UIElement[] {
      
      new UIImage(new int[]{0,1},0,0,0,1,1,"CompeteMode/elements/background.png"),
      new UIImage(new int[]{0},1,0.2,0.52,0.64,0.6,"CompeteMode/elements/table_with_circles.png"),
      new UIImage(new int[]{1},1,0.2,0.55,0.6,0.5,"CompeteMode/elements/table_with_circles.png"),
      new UIImage(new int[]{0,1},2,0.05,0.5,0.16,0.4,"CompeteMode/elements/pigblue.png"),
      new UIImage(new int[]{0,1},3,0.79,0.5,0.16,0.4,"CompeteMode/elements/pigred.png"),
      new UIImage(new int[]{1},4,0.37,0.24,0.26,0.6,"CompeteMode/elements/gorilla.png"),
      new UIImage(new int[]{0},9,0.38,0.45,0,0.2,"Assets/images/arrows.png"), 
      new UIImage(new int[]{1},9,0.38,0.45,0,0.2,"Assets/images/arrows.png"), 
      
      new UIButton(new int[]{0},5,logic.userInput,new String[]{"ui_elements/shake_btn.png"},0.35,0.82,0.3,0.17,"shakeBtnClicked"),
      new UIButton(new int[]{1},5,logic.userInput,new String[]{"ui_elements/shake_btn.png"},0.37,0.83,0.26,0.14,"shakeBtnClicked"),
      new UIButton(new int[]{0},8,logic.userInput,new String[]{"ui_elements/continue_btn.png"},0.35,0.82,0.3,0.17,"continueBtnClicked"),
      new UIButton(new int[]{1},8,logic.userInput,new String[]{"ui_elements/continue_btn.png"},0.37,0.83,0.26,0.14,"continueBtnClicked"),
      
//      new UIAnimation(new int[]{0,1},6,0.05,0.4,0.24,0.54,"CompeteMode/animation/bluepiganimation_",".png",2,4),
//      new UIAnimation(new int[]{0,1},7,0.71,0.4,0.24,0.54,"CompeteMode/animation/pinkpiganimation_",".png",2,4),
      
      new UIAnimation(new int[]{0,1},6,0.05,0.5,0.16,0.4,"CompeteMode/animation/bluepiganimation_",".png",2,4),
      new UIAnimation(new int[]{0,1},7,0.79,0.5,0.16,0.4,"CompeteMode/animation/pinkpiganimation_",".png",2,4),
      
      new UIImage(new int[]{0},31,0.32,0.27,0,0.5,"CompeteMode/elements/only_two_towers.png"), 
      new UIImage(new int[]{1},31,0.32,0.23,0,0.5,"CompeteMode/elements/only_two_towers.png"),
    };
    engine.setupUI(lib);
    
    
    
    
    sides = new SideManager[]{new SideManager(logic.controller.sides[0],logic,true,logic.config),new SideManager(logic.controller.sides[1],logic,false,logic.config)};
    
    
    engineText = processTexts(engine,new String[]{
                   
                   "CompeteMode/text/blue_stayed_up.png", //0
                   "CompeteMode/text/pink_stayed_up.png",
                   "CompeteMode/text/both_stayed_up.png",
                   "CompeteMode/text/pink_stayed_up.png",
                   "CompeteMode/text/place_2_towers.png",
                   "CompeteMode/text/placed_correct_both.png", //5
                   "CompeteMode/text/placed_left.png",
                   "CompeteMode/text/placed_right.png",
                   "CompeteMode/text/wrong_spot.png",
                   "Assets/text/clear_table.png",
                   
                   
                   
                 },0,0,1,0.358,0.1,0.02,0.8,0.28,100);
    engineText.changeText(0);            
    
  }
  public void render(int screenID){
    
    commonForAll(screenID);
    int curState = logic.stateID;
    switch(curState){
      case 0:
      engine.drawConstants(screenID,new int[]{9});
      break;
      
      case 5:
      drawSides(screenID);
      engine.drawConstants(screenID,new int[]{2,3});
      if(logic.controller.totalTowerNum() > 2)engine.drawConstants(screenID,new int[]{31});
      break;
      case 20:
      engine.drawConstants(screenID,new int[]{2,3});
      break;
      case 21:
      jumpingPigs(screenID);
      break;
      default:
      
      engine.drawConstants(screenID,new int[]{2,3});
    }
    if(curState>1)drawKinectImage(screenID);
    if(curState == 5 && logic.controller.totalTowerNum() > 2)engine.drawConstants(screenID,new int[]{31});
  }
  
  private void jumpingPigs(int screenID){
    if(logic.controller.loser == 0)engine.drawConstants(screenID,new int[]{2});
    else engine.drawConstants(screenID,new int[]{6});
    if(logic.controller.loser == 1)engine.drawConstants(screenID,new int[]{3});
    else engine.drawConstants(screenID,new int[]{7});
  }
  
  private void commonForAll(int screenID){
    if(logic.stateID>1)engine.drawConstants(screenID,new int[]{0,4,1});
    else engine.drawConstants(screenID,new int[]{0,1});
    engineText.drawText(screenID);
  }
  private void drawKinectImage(int screenID){
    if(screenID == 0)drawCon();
    else if(screenID == 1)projectorDrawTowers(projectorDrawDelegate);
  }
  private void drawSides(int screenID){
    for(int i=0; i<sides.length; i++){
      sides[i].drawSideOn(screenID);
    }
  }
  
}

public class SideManager{
  CompeteConfig config;
  SideCondition logic;
  CompeteLogic higherLogic;
  SideDrawer[] sides;
  
  
  public SideManager(SideCondition l, CompeteLogic hl, boolean isLeft, CompeteConfig c){
    logic = l;
    config = c;
    higherLogic = hl;
    SideDrawElement[] lib0 = new SideDrawElement[]{
      new SideDrawElement("CompeteMode/elements/arrowDown.png",-0.03,-0.1,0.06,0.2),
      new SideDrawElement("CompeteMode/elements/check.png",-0.05,-0.2,0.1,0),
      new SideDrawElement("CompeteMode/elements/cross.png",-0.05,-0.2,0.1,0),
    };
    
   
    
    sides = new SideDrawer[]{
         new SideDrawer(tabletDrawDelegate,new PVector(touchscreenWidth,touchscreenHeight),lib0),
         new SideDrawer(projectorDrawDelegate,new PVector(projectorWidth,projectorHeight),lib0),
    };
   
    if(isLeft){
      sides[0].scaleOrigin(0.39,0.558);
      sides[1].scaleOrigin(0.38,0.558);
    }
    else{
      sides[0].scaleOrigin(0.6,0.558);
      sides[1].scaleOrigin(0.58,0.558);
    }
  }
  public void drawSideOn(int screenID){
    if(logic.tower_num == 0 || !logic.correctPos){
      sides[screenID].drawSome(0,null);
    }
    if(higherLogic.controller.totalTowerNum()<3){
      if(logic.tower_num == 1){
        KinectDisplaySetting setting;
        int imgIndex;
        if(screenID == 0) setting = config.TabletSetting;
        else setting = config.ProjectorSetting;
        if(logic.correctPos) imgIndex = 1;
        else imgIndex = 2;
        sides[screenID].drawSome(imgIndex,new PVector(logic.centerX*setting.scaleX+setting.offsetX,logic.upperY*setting.scaleY+setting.offsetY));
      }
      else if(logic.tower_num == 2){
        KinectDisplaySetting setting;
        if(screenID == 0) setting = config.TabletSetting;
        else setting = config.ProjectorSetting;
        sides[screenID].drawSome(2,new PVector(logic.centerX*setting.scaleX+setting.offsetX,logic.upperY*setting.scaleY+setting.offsetY));
      }
    }
  }
}

public class SideDrawer{
  
  PImage[] elements; 
  PVector[] offsets;
  PVector origin;
  PApplet delegate;
  PVector resolution;
  
  public SideDrawer(PApplet a, PVector b, SideDrawElement[] c){
    delegate = a;
    resolution = b;
    elements = new PImage[c.length];
    offsets = new PVector[c.length];
    origin = new PVector(0,0);
    for(int i=0; i<c.length; i++){
      elements[i] = loadImage(c[i].filename);
      int www = Math.round(c[i].wide * resolution.x);
      int hhh = Math.round(c[i].high * resolution.y);
      elements[i].resize(www,hhh);
      offsets[i] = new PVector(c[i].offsetX * resolution.x, c[i].offsetY * resolution.y);
    }
  }
  
  void drawSome(int i,PVector pos){
    if(pos == null)delegate.image(elements[i],origin.x+offsets[i].x,origin.y+offsets[i].y);
    else delegate.image(elements[i],pos.x+offsets[i].x,pos.y+offsets[i].y);
  }
  
  void scaleOrigin(float a, float b){
    origin.x = a * resolution.x;
    origin.y = b * resolution.y;
  }

}

class SideDrawElement{
    String filename;
    float offsetX,offsetY,wide,high;
    public SideDrawElement(String a,float b,float c,float d,float e){
      filename = a;
      offsetX = b;
      offsetY = c;
      wide = d;
      high = e;
    }
}
  
class SideScreen{
    PApplet delegate;
    PVector resolution;
    public SideScreen(PApplet a, PVector b){
      delegate = a;
      resolution = b;
    }
}



public class KinectDrawingForCompete implements KinectDrawDelegate{
  DrawKinect kinectDrawer;
  CompeteLogic logic;
  KinectDisplaySetting TabletSetting,ProjectorSetting;
  ArrayList<Float> buffer;
  int onlyGreen = 999;
  public KinectDrawingForCompete(CompeteLogic some){
    kinectDrawer = HarryGlobal.kinectDrawer;
    logic = some;
    TabletSetting = logic.config.TabletSetting;
    ProjectorSetting = logic.config.ProjectorSetting;
    buffer = new ArrayList<Float>();
  }
  void tablet(){
    
    if(logic.controller.loser >= 0) onlyGreen = analyzeForResult();
    pgKinectTablet = kinectDrawer.createGraph(TabletSetting, new CompeteColor(logic,onlyGreen));
  }
  void projector(){
    pgKinectProjector = kinectDrawer.createGraph(ProjectorSetting, new CompeteColor(logic,onlyGreen));
  }
  
  private int analyzeForResult(){
    buffer.clear();
    for (int i=0; i<kinectDrawer.kinectContours.size(); i++){
      int altitudeThreshold = HarryGlobal.groundThreshold;
      float locallowY = 0;
      float sumX = 0;
      int count = 0;
      for (PVector point : kinectDrawer.kinectContours.get(i).getPoints()){
        if(point.y>locallowY)locallowY=point.y;
        sumX += point.x;
        count++;
      }
      if(locallowY>altitudeThreshold){
        float center = sumX / count;
        buffer.add(center);
      }
    }
    int leftmost = 0, rightmost = 0;
    for(int i=1; i<buffer.size(); i++){
      if(buffer.get(i)<buffer.get(leftmost))leftmost = i;
      if(buffer.get(i)>buffer.get(rightmost))rightmost = i;
    }
    if(logic.controller.loser == 0)return rightmost;
    return leftmost;
  }
}

public class CompeteColor implements ColorBlob{
  int towerDrawn = -1;
  CompeteLogic logic;
  int onlygreen;
  public CompeteColor(CompeteLogic some, int green){
    logic = some;
    onlygreen = green;
  }
  void coloring(PGraphics res, Contour info){
    int altitudeThreshold = HarryGlobal.groundThreshold;
    float locallowY = 0;
    float sumX = 0;
    int count = 0;
    for (PVector point : info.getPoints()){
      if(point.y>locallowY)locallowY=point.y;
      sumX += point.x;
      count++;
    }
    if(locallowY<altitudeThreshold){
         res.fill(100);
         res.stroke(100);
    }
    else{
      towerDrawn ++;
      if(logic.stateID < 20){
        float center = sumX / count;
        if(center < logic.config.boundary){
          res.fill(51, 102, 255);
          res.stroke(0,0,255);
        }
        else{
          res.fill(252, 24, 221);
          res.stroke(255,0,171);
        }
      }
      else{

          if(logic.controller.loser < 0){
            res.fill(140, 255, 140);   
            res.stroke(0, 200, 0);
          }
          else {
            if(towerDrawn == onlygreen){
              res.fill(140, 255, 140);   
              res.stroke(0, 200, 0);
            }
            else{
              res.fill(255, 140, 140);
              res.stroke(255, 0, 0);
            }
          }

      }
    
    }
  }
}
