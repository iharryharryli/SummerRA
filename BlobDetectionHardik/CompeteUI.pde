public class CompeteUI{
  UIEngine engine;
  public int stateID = -1;
  public CompeteUI(){
    UIScreen s1 = new UIScreen(tabletDrawDelegate,new PVector(touchscreenWidth,touchscreenHeight),"AssetsTablet/");
    UIScreen s2 = new UIScreen(projectorDrawDelegate,new PVector(projectorWidth,projectorHeight),"AssetsProjector/");
    engine = new UIEngine(new UIScreen[]{s1,s2});
  }
  
}
