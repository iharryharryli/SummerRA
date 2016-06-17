

abstract class UIElement{
  int ID;
  int[] screens;
  float xPos;
  float yPos;
  float wwidth;
  float hheight;
  
  public UIElement(int a[], int b, float c, float d, float e, float f){
    screens = a;
    ID = b;
    xPos = c;
    yPos = d;
    wwidth = e;
    hheight = f;
  }
  public UIElement(){
  }
  
  abstract UIDummy register(PApplet D, float W, float H);
}

abstract class UIDummy{
  PApplet delegate;
  
  public UIDummy(PApplet x){
    delegate = x;
  }
  public UIDummy(){
  }
  
  abstract void drawMe();
}

class UIDisplay extends UIElement{
  
  UIElement[] sources;
  
  UIDisplayDummy register(PApplet D, float W, float H){
    UIDummy[] children = new UIDummy[sources.length];
    for(int i=0; i<sources.length; i++){
      children[i] = sources[i].register(D,W,H);
    }
    return (new UIDisplayDummy(children));
  }
}

class UIDisplayDummy extends UIDummy{
  UIDummy[] sources;
  int pointer;
  public UIDisplayDummy(UIDummy[] x){
    sources = x;
    pointer = -1;
  }
  void drawMe(){
    sources[pointer].drawMe();
  }
  
}

  

class UIButton extends UIElement{
  
  PApplet handler;
  String handleFunction;
  String[] filename;
  
  
  public UIButton (int o[], int oo, PApplet a, String[] b, float c, float d, float e, float f, String g){
    
    handler = a;
    filename = b;
    xPos = c;
    yPos = d;
    wwidth = e;
    hheight = f;
    handleFunction = g;
    ID = oo;
    screens = o;
  }
  
  GImageButton drawMe(PApplet D, float W, float H, String dirPrefix){
    String[] x = filename;
    if(filename.length==1){
      x = new String[] {filename[0],filename[0],filename[0]};
    }
    for(int i=0; i<x.length; i++){
      x[i] = dirPrefix + x[i];
    }
    
    GImageButton xx = new GImageButton(D, (int)(W*xPos),(int)(H*yPos),((int)(W*wwidth)),(int)(H*hheight),
        x);    
    xx.addEventHandler(handler,handleFunction);
    xx.setVisible(false);
    return xx;
  }
  
  UIDummy register(PApplet D, float W, float H){
    return null;
  }
}



class UIImage extends UIElement{
  String filename;
  PApplet target;
  public UIImage(int[] f, int g, float b, float c, float d, float e, String file){
    xPos = b;
    yPos = c;
    wwidth = d;
    hheight = e;
    ID = g;
    screens = f;
    filename = file;
  }
  
  UIImageDummy register(PApplet D, float W, float H){
    PImage source = loadImage(filename);
    int ww = Math.round(W * wwidth);
    int hh = Math.round(H * hheight);
    
    source.resize(ww,hh);
    UIImageDummy dummy = new UIImageDummy(source,xPos*W,yPos*H,D);
    g.removeCache(source);
    return dummy;
  }
}

class UIImageDummy extends UIDummy{
  PImage source;
  float xPos;
  float yPos;
  
  public UIImageDummy(PImage a, float b, float c, PApplet d){
    source = a;
    xPos = b;
    yPos = c;
    delegate = d;
  }
  void drawMe(){
    delegate.image(source,xPos,yPos);
  }
  void drawMeAt(float x, float y){
    delegate.image(source,x,y);
  }
}

class UIAnimation extends UIElement{
  String filename;
  String filetype;
  int frameNum;
  int frameSpeed;
  public UIAnimation(int a[], int b, float c, float d, float e, float f,String g,String h,int k,int l){
    super(a,b,c,d,e,f);
    filename = g;
    filetype = h;
    frameNum = k;
    frameSpeed = l;
  }
  
  UIAnimationDummy register(PApplet D, float W, float H){
    PImage[] ss = new PImage[frameNum];
    int interval = (1000 / frameSpeed) + 1;
    int ww = Math.round(W * wwidth);
    int hh = Math.round(H * hheight);
    for(int i=0; i<frameNum; i++){
      ss[i] = loadImage(filename+(i+1)+filetype);
      ss[i].resize(ww,hh);
      g.removeCache(ss[i]);
    }
    
    UIAnimationDummy res = new UIAnimationDummy(D,ss,W*xPos,H*yPos,interval);
    return res;
    
  }
}

class UIAnimationDummy extends UIDummy{
  PImage[] frames;
  int pointer;
  float xPos;
  float yPos;
  int frameInterval;
  long lastChangeTime;
  
  public UIAnimationDummy(PApplet x, PImage[] source, float a, float b, int c){
    super (x);
    frames = source;
    xPos = a;
    yPos = b;
    frameInterval = c;
    lastChangeTime = -1;
    pointer = 0;
  }


  private void detectChange(){
    
    long currentTime = System.currentTimeMillis();
    
    if(lastChangeTime<0){
      lastChangeTime = currentTime;
      return;
    }
    if(currentTime >= lastChangeTime + frameInterval){
      pointer ++;
      pointer = pointer % (frames.length);
      lastChangeTime = currentTime;
    }
  }
  
  void drawMe(){
    detectChange();
    delegate.image(frames[pointer],xPos,yPos); 
  }
  
  
}

class UIScreen{
  PApplet delegate;
  PVector resolution;
  String assetDir;
  
  public UIScreen(PApplet x, PVector y, String z){
    delegate = x;
    resolution = y;
    assetDir = z;
  }
  
}
   
  

class UIEngine{
  
  UIScreen[] screens;
  
  HashMap searchUp;
  
  
  public UIEngine(UIScreen[] x){
    screens = x;
    searchUp = new HashMap();
    
  }
 
  void setupUI(UIElement[] source){
    
    for(int i=0; i<source.length; i++){
      UIElement temp = source[i];
      
      int n = temp.screens.length;
      int name = temp.ID;
      
      Object[] stuff = (Object[])searchUp.get(name);
      if(stuff==null)stuff=new Object[screens.length];
      
      for(int j=0; j<n; j++){
        int screenID = temp.screens[j];
        
        if(temp instanceof UIButton){
          
          UIButton act = (UIButton) temp;
          stuff[screenID] = act.drawMe(screens[screenID].delegate,screens[screenID].resolution.x,screens[screenID].resolution.y,screens[screenID].assetDir);
        }
        else if(temp instanceof UIImage){
          UIImage act = (UIImage) temp;
          stuff[screenID] = act.register(screens[screenID].delegate,screens[screenID].resolution.x,screens[screenID].resolution.y);          
        }
        else if(temp instanceof UIAnimation){
          UIAnimation act = (UIAnimation) temp;
          stuff[screenID] = act.register(screens[screenID].delegate,screens[screenID].resolution.x,screens[screenID].resolution.y);
        }
        else if(temp instanceof UIDisplay){
          
        }
          
        

      }
      
       searchUp.put(name,stuff);

    }
    
  }
  
   void switchOn(int[] ons){
     
    sort(ons);
    Set set = searchUp.entrySet();
    Iterator i = set.iterator();
    while(i.hasNext()){
      Map.Entry me = (Map.Entry)i.next();
      int nam = (Integer)me.getKey();
      boolean isOn = exist(nam,ons);
      
      Object[] stuff = (Object[])me.getValue();
      
      
      for(int j=0; j<stuff.length; j++){
        if(stuff[j] instanceof GImageButton){
          GImageButton temp = (GImageButton) stuff[j];
          temp.setVisible(isOn);
        }
      }
    }
   }
   
   void turnBtn(int[] s,boolean on){
     for(int i=0; i<s.length; i++){
       Object[] stuff = (Object[])(searchUp.get(s[i]));
       for(int j=0; j<stuff.length; j++){
         GImageButton temp = (GImageButton) stuff[j];
         temp.setVisible(on);
       }
     }
   }
  
  private boolean exist(int some, int[] A){
    int lb = 0, rb = A.length;
    while(lb < rb){
      int m = (lb+rb)/2;
      if(some==A[m])return true;
      else if(some<A[m])rb=m;
      else lb=m+1;
    }
    return false;
  }
  
  void drawConstants(int thescreen, int[] IDs){
    
    for(int i=0; i<IDs.length; i++){
      int t = IDs[i];
      Object stuff = ((Object[])searchUp.get(t))[thescreen];
        if(stuff instanceof UIDummy){
          UIDummy temp = (UIDummy) stuff;
          temp.drawMe();
        }
        
    } 
  }
  
  void drawConstantAt(int thescreen, int ID,float x,float y){
      Object stuff = ((Object[])searchUp.get(ID))[thescreen];
      if(stuff == null)return;
      UIImageDummy temp = (UIImageDummy) stuff;
     temp.drawMeAt(x*screens[thescreen].resolution.x,y*screens[thescreen].resolution.y);
  }
  
  void clearStage(int thescreen){
    screens[thescreen].delegate.background(255);
  }
  

  
  
}
  
  
