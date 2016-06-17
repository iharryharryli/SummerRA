/*
 * Simple class to use as a debugging window the the kinect image data and any relevant text. Currently we don't
 * do anyting in draw since we sync drawing to thie frame with the main sketch window. It should be possible to use
 * all normal processing functions with this. Either inside of the DebugWindow class or by calling debugScreen.function().
 * For example debugScreen.image(img, 0, 0); 
 */

DebugWindow debugScreen;

public class PFrame extends JFrame {
   
  public PFrame() {
      //  setBounds(0,0, 640, 480);
        setBounds(touchscreenWidth,0,640,480);
        debugScreen = new DebugWindow();
        add(debugScreen);
        debugScreen.init();
        show();
    }
}

public class DebugWindow extends PApplet {

  PImage buffImg;
  public void setup() {
    size(640,480);
  }
  
  public void draw() { 
  }
  public void setImg(PImage p)
  {
    //buffImg = p.get();
    image(p,0,0);
    
  }
  
  public void addText(String s, float x, int y)
  {
    text(s, x, y);
  }
}
