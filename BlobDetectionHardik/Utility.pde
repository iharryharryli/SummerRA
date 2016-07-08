public class RelayControl{
  long startTime;
  long timeOut;
  boolean isShaking;
  public RelayControl(int out){
    timeOut = out;
    isShaking = false;
  }
  public void begin(){
    relayOn();
    isShaking = true;
    startTime = System.currentTimeMillis();
    timeOut += startTime;
    
  }
  public int update(){
    long current = System.currentTimeMillis();
    if(current > timeOut){
      relayOff();
      isShaking = false;
    }
    return (int)(current - startTime);
  }
  public void shut(){
    relayOff();
    isShaking = false;
  }
}

public boolean judgeFalling(Detector D,int index,int h,float a,float ad){
  String lleftFallingHeight = towerFallingHeight(D,index,h);
  String lleftFallingAngle = towerFallingAngle(D,index,a,ad);
  
  String lleftFalling = towerFallingFinalDecision(lleftFallingHeight, lleftFallingAngle);
  
  return (lleftFalling == "Fallen");
}
