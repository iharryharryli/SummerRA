public class CompeteConfig{
  int boundary;
  int refreshRate;
  KinectDisplaySetting TabletSetting,ProjectorSetting;
  public CompeteConfig(){
    boundary = 320;
    refreshRate = 20;
    TabletSetting = new KinectDisplaySetting(touchscreenWidth, touchscreenHeight, 0.8, 1.0, 0.11,-0.07);
    ProjectorSetting = new KinectDisplaySetting(projectorWidth, projectorHeight, 0.74, 1.0, 0.12,-0.08);
  }
}


public class SideController{
  SideCondition[] sides;
  int boundary;
  Detector detector;
  int loser = -1;
  
  public SideController(int b, Detector D){
    boundary = b;
    sides = new SideCondition[]{new SideCondition(leftTowerLeft,leftTowerRight),new SideCondition(rightTowerLeft,rightTowerRight)};
    detector = D;
  }
  
  public void update(Detector D, ArrayList<Integer> F){
    
    sides[0].clean(); sides[1].clean();
    for(int i=0; i<F.size(); i++){
      int index = F.get(i);
      int ti = 0;
      float posX = D.getCentroidX(index);
      float posY = D.getA()[index].y;
      if(posX < boundary) ti = 0;
      else ti = 1;
      sides[ti].updateOnce(index,posX,posY);
      
    }
    
  }
  
  public int totalTowerNum(){
    return (sides[0].tower_num + sides[1].tower_num);
  }
  
  public void checkFalling(){
    
    for(int i=0; i<sides.length; i++){
      if(sides[i].tower_num < 1){
        loser = i;
        return;
      }
    }
    for(int i=0; i<sides.length; i++){
      if(sides[i].isFallen(detector)){
        loser = i;
        return;
      }
    }
  }
  
  public void prepareData(){
    for(int i=0; i<sides.length; i++){
      sides[i].registerData(detector);
    }
  }
  
  public boolean assureForShaking(){
    return (sides[0].tower_num ==1 && sides[1].tower_num ==1 && sides[1].correctPos && sides[0].correctPos);
  }
  
}

public class SideCondition{
  int tower_num = 0;
  int targetTower = -1;
  float centerX = 0;
  float upperY = 0;
  int fHeight;
  float fAngle;
  float fAngleDensity;
  boolean fallen = false;
  float leftBound,rightBound;
  boolean correctPos = false;
  
  public SideCondition(float lb, float rb){
    leftBound = lb;
    rightBound = rb;
  }
  
  public void clean(){
    tower_num = 0;
  }
  
  public void updateOnce(int i,float c,float u){
    tower_num ++;
    targetTower = i;
    centerX = c;
    upperY = u;
    if(leftBound <= centerX && centerX <= rightBound) correctPos = true;
    else correctPos = false;
  }
  
  public void registerData(Detector detector){
    if(tower_num != 1)return;
    fHeight = detector.getBlobHeight(targetTower);
    float[] eigArray = getBlobEigen(detector, targetTower);  
    fAngle = eigArray[0];
    fAngleDensity = eigArray[1]; 
  }
  
  public boolean isFallen(Detector detector){
    if(tower_num != 1)return true;
    fallen = judgeFalling(detector,targetTower,fHeight,fAngle,fAngleDensity);
    return fallen;
  }
  

}

public class CompeteLogic{
  int stateID;
  /*
  definition for different states
  -1: else
  5: placing
  20: shaking
  21: result
  */
  SideController controller;
  CompeteConfig config;
  int updateInterval;
  boolean isPlaying;
  Detector detector;
  CompeteAction nextAction;
  RelayControl myRelay;
  CompeteInput userInput;
  CompeteUI UI;
 
  public CompeteLogic(){
    detector = bd;
    config = new CompeteConfig();
    controller = new SideController(config.boundary,detector);
    updateInterval = 1000 / config.refreshRate;
    isPlaying = false;
    
    stateID = 5;
    
    //keep this order of initialization!!
    userInput = new CompeteInput(this);
    UI = new CompeteUI(this);
    userInput.ui = UI.engine;
  }
  
  public void main(){
    switch(stateID){
      case -1:
      break; 
    
      
      case 5:
      
      if(controller.assureForShaking()){
        UI.engine.turnBtn(new int[]{5},true);
      }
      else{
        UI.engine.turnBtn(new int[]{5},false);
      }
      
      
      
      break;
      
      
      case 20:
      myRelay.update();
      controller.checkFalling();
      if(controller.loser >= 0){
        println("loser : " + controller.loser);
        myRelay.shut();
        stateID = 21;
      }
      else if(!myRelay.isShaking){
        println("loser : nil");
        stateID = 21;
      }
      
      break;
    }
  }
  
  public void play(){
    if(!isPlaying)return;
    
    detection();
    if(nextAction!=null){
      nextAction.run();
      nextAction = null;
    }
    main();
    
    Timer timer = new Timer();
    timer.schedule(new TimerTask(){
      public void run(){
        play();
      }
    },updateInterval);
  }
  public void startPlaying(){
    HarryGlobal.kinectDrawDelegate = null;
    HarryGlobal.kinectDrawDelegate = new KinectDrawingForCompete(this);
    gs = GameState.COMPETE;
    isPlaying = true;
    play();
  }
  public void detection(){
    
    detector = getBlobScannerObject(detector,srcImage);
    detector.findCentroids();
    
    int[] raw = (getNum_getIndex (detector)).array();
    ArrayList<Integer> filtered = new ArrayList<Integer>();
    for(int i = 0; i < raw.length; i++) 
      {
        if(detector.getD()[raw[i]].y > HarryGlobal.groundThreshold)
        {
          filtered.add(raw[i]);
        }
      }
     controller.update(detector,filtered);
  }
  public void render(int screenID){
    UI.render(screenID);
  }
}

public class CompeteInput extends PApplet{
  
  CompeteLogic logic;
  UIEngine ui;
  
  public CompeteInput(CompeteLogic l){
    logic = l;
  }
  
  public void shake(){
    logic.nextAction = new CompeteAction(){
      public void run(){
        if(!logic.controller.assureForShaking())return;
        logic.controller.prepareData();
        logic.stateID = 20;
        logic.myRelay = new RelayControl(5000);
        logic.myRelay.begin();
      }
    };
  }
  
  public void shakeBtnClicked(GImageButton source, GEvent event){
    if(ui!=null)ui.turnBtn(new int[]{5},false);
    shake();
  }
}

interface CompeteAction{
  void run();
}



