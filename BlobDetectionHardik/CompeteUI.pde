public class CompeteUI{
  UIEngine engine;
  CompeteLogic logic;
  SideManager[] sides;
  public CompeteUI(CompeteLogic some){
    logic = some;
    UIScreen s1 = new UIScreen(tabletDrawDelegate,new PVector(touchscreenWidth,touchscreenHeight),"AssetsTablet/");
    UIScreen s2 = new UIScreen(projectorDrawDelegate,new PVector(projectorWidth,projectorHeight),"AssetsProjector/");
    engine = new UIEngine(new UIScreen[]{s1,s2});
    /*
    UIElement IDs:
    0: background
    1: table
    */
    UIElement[] lib = new UIElement[] {
      
      new UIImage(new int[]{0,1},0,0,0,1,1,"CompeteMode/elements/background.png"),
      new UIImage(new int[]{0},1,0.2,0.52,0.64,0.6,"CompeteMode/elements/table_with_circles.png"),
      new UIImage(new int[]{1},1,0.2,0.55,0.6,0.5,"CompeteMode/elements/table_with_circles.png"),
      
    };
    
    engine.setupUI(lib);
    
    sides = new SideManager[]{new SideManager(logic.controller.sides[0],true),new SideManager(logic.controller.sides[1],false)};
    
    
  }
  public void render(int screenID){
    commonForAll(screenID);
    int curState = logic.stateID;
    switch(curState){
      default:
      drawSides(screenID);
    }
    drawKinectImage(screenID);
  }
  private void commonForAll(int screenID){
    engine.drawConstants(screenID,new int[]{0,1});
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
  SideCondition logic;
  SideDrawer[] sides;
  
  
  public SideManager(SideCondition l, boolean isLeft){
    logic = l;
    
    SideDrawElement[] lib0 = new SideDrawElement[]{
      new SideDrawElement("CompeteMode/elements/arrowDown.png",-0.03,-0.1,0.06,0.2),
      new SideDrawElement("CompeteMode/elements/check.png",-0.05,-0.05,0.1,0.1),
    };
    
    SideDrawElement[] lib1 = new SideDrawElement[]{
      new SideDrawElement("CompeteMode/elements/arrowDown.png",-0.03,-0.1,0.06,0.2),
      new SideDrawElement("CompeteMode/elements/check.png",-0.05,-0.05,0.1,0.1),
    };
    
    sides = new SideDrawer[]{
         new SideDrawer(tabletDrawDelegate,new PVector(touchscreenWidth,touchscreenHeight),lib0),
         new SideDrawer(projectorDrawDelegate,new PVector(projectorWidth,projectorHeight),lib1),
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
    if(logic.tower_num == 0){
      sides[screenID].drawSome(0,null);
    }
    else if(logic.tower_num == 1){
      sides[screenID].drawSome(1,new PVector(logic.centerX,logic.upperY));
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
  public KinectDrawingForCompete(CompeteLogic some){
    kinectDrawer = HarryGlobal.kinectDrawer;
    logic = some;
    TabletSetting = new KinectDisplaySetting(touchscreenWidth, touchscreenHeight, 0.8, 1.0, 0.11,-0.07);
    ProjectorSetting = new KinectDisplaySetting(projectorWidth, projectorHeight, 0.74, 1.0, 0.12,-0.08);
  }
  void tablet(){
    pgKinectTablet = kinectDrawer.createGraph(TabletSetting, new CompeteColor(logic));
  }
  void projector(){
    pgKinectProjector = kinectDrawer.createGraph(ProjectorSetting, new CompeteColor(logic));
  }
}

public class CompeteColor implements ColorBlob{
  CompeteLogic logic;
  public CompeteColor(CompeteLogic some){
    logic = some;
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
  }
}
