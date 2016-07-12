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
    
    */
    UIElement[] lib = new UIElement[] {
      
      new UIImage(new int[]{0,1},0,0,0,1,1,"CompeteMode/elements/background.png"),
      new UIImage(new int[]{0,1},1,0.2,0.6,0.6,0.4,"CompeteMode/elements/table_with_circles.png"),
      
    };
    
    engine.setupUI(lib);
    
  }
  public void render(int screenID){
    commonForAll(screenID);
    int curState = stateID;
    switch(curState){
      default:
    }
  }
  private void commonForAll(int screenID){
    engine.drawConstants(screenID,new int[]{0,1});
  }
  
}

public class SideDrawer{
  CompeteUI father;
}
