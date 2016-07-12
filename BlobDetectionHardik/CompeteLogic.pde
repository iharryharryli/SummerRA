public class CompeteConfig{
  int boundary;
  int refreshRate;
  public CompeteConfig(){
    boundary = 320;
    refreshRate = 20;
  }
}


public class SideController{
  SideCondition[] sides;
  int boundary;
  int tower_num = -1;
  Detector detector;
  
  public SideController(int b, Detector D){
    boundary = b;
    sides = new SideCondition[]{new SideCondition(),new SideCondition()};
    detector = D;
  }
  
  public void update(Detector D, ArrayList<Integer> F){
    
    sides[0].clean(); sides[1].clean();
    for(int i=0; i<F.size(); i++){
      int index = F.get(i);
      int ti = 0;
      if(D.getCentroidX(index) < boundary) ti = 0;
      else ti = 1;
      sides[ti].tower_num ++;
      sides[ti].targetTower = index;
    }
    
  }
  
  public int checkFalling(){
    for(int i=0; i<sides.length; i++){
      if(sides[i].tower_num < 1)return i;
    }
    for(int i=0; i<sides.length; i++){
      if(sides[i].isFallen(detector)){
        return i;
      }
    }
    return -1;
  }
  
  public void prepareData(){
    for(int i=0; i<sides.length; i++){
      sides[i].registerData(detector);
    }
  }
  
  public boolean assureForShaking(){
    return (sides[0].tower_num ==1 && sides[1].tower_num ==1);
  }
  
}

public class SideCondition{
  int tower_num = 0;
  int targetTower = -1;
  int fHeight;
  float fAngle;
  float fAngleDensity;
  boolean fallen = false;
  
  
  public void clean(){
    tower_num = 0;
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
    
    stateID = -1;
    userInput = new CompeteInput(this);
    UI = new CompeteUI();
  }
  
  public void main(){
    switch(stateID){
      case -1:
      println("playing");
      break;
      case 20:
      myRelay.update();
      int result = controller.checkFalling();
      if(result >= 0){
        println("loser : " + result);
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
    UI.stateID = stateID;
    Timer timer = new Timer();
    timer.schedule(new TimerTask(){
      public void run(){
        play();
      }
    },updateInterval);
  }
  public void startPlaying(){
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

public class CompeteInput{
  
  CompeteLogic logic;
  
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
}

interface CompeteAction{
  void run();
}



