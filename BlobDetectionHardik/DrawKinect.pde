public class DrawKinect{
  public ArrayList<Contour> kinectContours;
  
  
  public void updateCountours(){
    kinectContours =  getContours();
  }
  public PGraphics createGraph(KinectDisplaySetting setting, ColorBlob colorMachine){
    PGraphics res = createGraphics((int)setting.wwidth,(int)setting.hheight);
    res.beginDraw();
    res.pushMatrix();
    res.strokeWeight(3);
    res.translate(setting.offsetX,setting.offsetY);
    res.scale(setting.scaleX,setting.scaleY);
    
    
    for (int i=0; i<kinectContours.size(); i++){
       colorMachine.coloring(res,kinectContours.get(i));
       res.beginShape();
       for (PVector point : kinectContours.get(i).getPoints())
                  {
                    res.vertex(point.x, point.y);
                  }
       res.endShape();
    }
    res.popMatrix();
    res.endDraw();
    return res;
  }
}

public interface ColorBlob{
  void coloring(PGraphics res, Contour info);
}

public interface KinectDrawDelegate{
  
  void tablet();
  void projector();
}

public class ordinaryColor implements ColorBlob{
  void coloring(PGraphics res, Contour info){
    float locallowY = 0;
    float localhigh = 999999; 
    int altitudeThreshold = HarryGlobal.groundThreshold;
    for (PVector point : info.getPoints()){
      if(point.y>locallowY)locallowY=point.y;
      if(point.y<localhigh)localhigh=point.y;  
    }
    if(locallowY<altitudeThreshold){
         res.fill(100);
         res.stroke(100);
      }
      else{
        
        if(HarryGlobal.canRegisterHeight)HarryGlobal.towerHeightInPixel = locallowY - localhigh;      
        
        res.fill(140, 255, 140);   
        res.stroke(0, 200, 0);
        
        if(!fallen.equals(""))
         {
            Rectangle r = info.getBoundingBox();
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
      }
  }
}

public class challengeColor implements ColorBlob{
  
  ChallengeLogic logic;
  
  ChallengeAnalyze stats;
  
  public challengeColor(ChallengeLogic s,ChallengeAnalyze ss){
    logic = s;
    stats = ss;
  }
  
  void coloring(PGraphics res, Contour info){
    float locallowY = 0,localhighY = 999999,localleft=999999,localright=0;
    int altitudeThreshold = HarryGlobal.groundThreshold;
    for (PVector point : info.getPoints()){
      if(point.y>locallowY)locallowY=point.y;
      if(point.y<localhighY)localhighY=point.y;
      if(point.x>localright)localright=point.x;
      if(point.x<localleft)localleft=point.x;
    }
   
      if(locallowY>=altitudeThreshold){
        if(stats!=null){
           stats.realTCount ++;
           stats.update(localleft,localright,localhighY,locallowY);
        }
                  if(logic.towerOK || logic.realTowerNum == 0){
                      res.fill(140, 255, 140);   
                      res.stroke(0, 200, 0);
                  }
                  else{
                      res.fill(255, 140, 140);
                     res.stroke(255, 0, 0);
                  }
      }
      else{
         res.fill(100);
         res.stroke(100);
      }
    
  }
}

public class KinectForGames implements KinectDrawDelegate{
  
  DrawKinect kinectDrawer;
  
  public KinectForGames(DrawKinect some){
    kinectDrawer = some;
  }
  
  void tablet(){
    pgKinectTablet = kinectDrawer.createGraph(HarryGlobal.KinectForTablet, new ordinaryColor());
    
  }

  void projector(){
    pgKinectProjector = kinectDrawer.createGraph(HarryGlobal.KinectForProjector, new ordinaryColor());
  }
  
 
}

public class KinectForChallenge implements KinectDrawDelegate{
  
  DrawKinect kinectDrawer;
  
  ChallengeLogic logic;
  
  ChallengeAnalyze stats;
  
  public KinectForChallenge(DrawKinect some, ChallengeLogic someLogic){
    kinectDrawer = some;
    logic = someLogic;
  }
  
  void initStats(){
    stats = null;
    stats = new ChallengeAnalyze();
  }
  
  void analyze(){
    if(HarryGlobal.canRegisterHeight)HarryGlobal.towerHeightInPixel = stats.bottom - stats.top;
    logic.realTowerNum = stats.realTCount;
    KinectDisplaySetting setting = HarryGlobal.KinectForTablet;
    logic.rulerEngine.measureTower(setting.scaleY*stats.top+setting.offsetY);
    if(logic.cs != ChallengeMyTowerState.SHAKING && logic.cs != ChallengeMyTowerState.FAIL && logic.cs != ChallengeMyTowerState.SUCCESS)
     logic.towerOK = logic.rulerEngine.tallEnough;
    if(logic.cs == ChallengeMyTowerState.TOO_MANY_FIRST) logic.towerOK = false;
  }
  
  void tablet(){
    initStats();
    pgKinectTablet = kinectDrawer.createGraph(HarryGlobal.KinectForTablet, new challengeColor(logic,stats));
    analyze();
    updateRuler();
  }
  void projector(){
    pgKinectProjector = kinectDrawer.createGraph(HarryGlobal.KinectForProjector, new challengeColor(logic,null));
  }
  void updateRuler(){    
    updateRulerIn(stats.leftmost,stats.rightmost,stats.top,stats.bottom,HarryGlobal.KinectForTablet,0);
    updateRulerIn(stats.leftmost,stats.rightmost,stats.top,stats.bottom,HarryGlobal.KinectForProjector,1);
  }
  void updateRulerIn(float leftmost, float rightmost,float top, float bottom, KinectDisplaySetting setting, int rulerIndex){
    leftmost = leftmost*setting.scaleX + setting.offsetX;
    rightmost = rightmost*setting.scaleX + setting.offsetX;
    top = top*setting.scaleY + setting.offsetY;
    bottom = bottom*setting.scaleY + setting.offsetY;
    logic.rulerEngine.updateRuler(rulerIndex,leftmost,rightmost,top,bottom);
  } 
}

public class KinectDisplaySetting{
  float wwidth, hheight, scaleX, scaleY, offsetX, offsetY;
  public KinectDisplaySetting(float a, float b, float c, float d, float e, float f){
    wwidth = a;
    hheight = b;
    scaleX = c*((float)wwidth/640.0);
    scaleY = d*((float)hheight/480.0);
    offsetX = e*a;
    offsetY = f*b;
  }
}

public class ChallengeAnalyze{
  float leftmost,rightmost,top,bottom;
  int realTCount;
  public ChallengeAnalyze(){
    leftmost = 999999;
    rightmost = 0;
    top = 999999;
    bottom = 0;
    realTCount = 0;
  }
  public void update(float a,float b,float c,float d){
    if(a<leftmost)leftmost = a;
    if(b>rightmost)rightmost = b;
    if(c<top)top = c;
    if(d>bottom)bottom = d;
  }
}


