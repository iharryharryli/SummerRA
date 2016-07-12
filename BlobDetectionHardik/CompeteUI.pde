public class CompeteUI{
  UIEngine engine;
  public int stateID = -1;
  public CompeteUI(){
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
    
    
    
  }
  public void render(int screenID){
    commonForAll(screenID);
    int curState = stateID;
    switch(curState){
      default:
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
  
}

public class SideDrawer{
  CompeteUI father;
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
