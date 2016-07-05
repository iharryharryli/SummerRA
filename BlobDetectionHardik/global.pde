public class HarryGlobalClass{
  
  public float towerHeightInPixel = -1;
  
  public boolean canRegisterHeight = false;
  
  public float standardRulerHeight = -1;
  
  public int groundThreshold = 350;
  
  public int minimumBlobSize = 1000;
  
  public DrawKinect kinectDrawer;
  
  public KinectDrawDelegate kinectDrawDelegate;
  
  public KinectDisplaySetting KinectForProjector, KinectForTablet;
  
  public HarryGlobalClass(){
    KinectForTablet = new KinectDisplaySetting(touchscreenWidth, touchscreenHeight, 0.85, 1.0,0.07,-0.06);
    KinectForProjector = new KinectDisplaySetting(projectorWidth, projectorHeight, 0.85, 1.0,0.29,-0.07);
    kinectDrawer = new DrawKinect();
    kinectDrawDelegate = new KinectForGames(kinectDrawer);
  }
  
}

