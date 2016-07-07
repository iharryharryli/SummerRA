public class CompeteConfig{
  int boundary;
  int refreshRate;
  public CompeteConfig(){
    boundary = 100;
    refreshRate = 20;
  }
}


public class SideController{
  SideCondition[] sides;
  int boundary;
  int tower_num = -1;
  
  public SideController(int b){
    boundary = b;
    sides = new SideCondition[]{new SideCondition(),new SideCondition()};
  }
  
  public void update(Detector D, ArrayList<Integer> F){
    sides[0].clean(); sides[0].clean();
    for(int i=0; i<F.size(); i++){
      int index = F.get(i);
      int ti = 0;
      if(bd.getCentroidX(index) < boundary) ti = 0;
      else ti = 1;
      sides[ti].tower_num ++;
      sides[ti].targetTower = index;
    }
  }
  
}

public class SideCondition{
  int tower_num = 0;
  int targetTower = -1;
  
  public void clean(){
    tower_num = 0;
  }
}

public class CompeteLogic{
  int stateID;
  SideController controller;
  CompeteConfig config;
  int updateInterval;
  boolean isPlaying;
  Detector detector;
  public CompeteLogic(){
    config = new CompeteConfig();
    controller = new SideController(config.boundary);
    updateInterval = 1000 / config.refreshRate;
    isPlaying = false;
    detector = bd;
  }
  public void play(){
    if(!isPlaying)return;
    detection();
    println("playing");
    
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
  }
}


