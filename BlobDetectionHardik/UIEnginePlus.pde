class TextAssociation{
  int name;
  int[] content;
  public TextAssociation(int a,int[] b){
    name = a;
    content = b;
  }
}

class TextEngine{
  HashMap search;
  UIEngine delegate;
  int index; // -1 means turned off
  
  public TextEngine(TextAssociation[] a, UIEngine D){
    search = new HashMap();
    for(int i=0; i<a.length; i++){
      search.put(a[i].name,a[i].content);
    }
    delegate = D;
    index = -1;
  }
  
  void changeText(int i){
    index = i;
  }
  
  void drawText(int screenID){
    if(index == -1) return;
    int[] t = (int[])search.get(index);
    if(t[screenID]==-1)return ;
    delegate.drawConstants(screenID, new int[]{t[screenID]});
  }
}

class TowerAssociation{
   String phase;
   int  renderID;
   public TowerAssociation(String a, int b){
     phase = a;
     renderID = b;
   }
}

class Tower{
  String name;
  HashMap content;
  
  public Tower(String a, TowerAssociation[] b){
    name = a;
    content = new HashMap();
    for(int i=0; i<b.length; i++){
      content.put(b[i].phase,b[i].renderID);
    }
  }
  
  void drawOnScreen(UIEngine engine, int theScreen, String phase, float xPos, float yPos){
    Object px = content.get(phase);
    if(px==null)return;
    int x = (Integer)px;
    engine.drawConstantAt(theScreen, x, xPos, yPos);
  }
}
  

class TowerEngine{
  HashMap search;
  UIEngine delegate;
  public TowerEngine(UIEngine x){
    search = new HashMap();
    delegate = x;
  }
  void addTower(Tower x){
    search.put(x.name,x);
  }
  void drawOnScreen(int theScreen, String tower, String phase, float xPos, float yPos, float yOffset){
    Object t = search.get(tower);
    if(t == null)return;
    Tower temp = (Tower)t;
    
    //offset
    if(phase == "arrow") yPos += yOffset;
    
    temp.drawOnScreen(delegate,theScreen,phase,xPos,yPos);
  }
}

class TowerEngineDouble extends TowerEngine{
  PVector[][] positionSet;
  boolean on;
  String[] content;
  String[] phase;
  float yOffset;
  public TowerEngineDouble(UIEngine x, PVector[][] p){
    super(x);
    positionSet = p;
    on = false;
    phase = new String[]{null,null};
    yOffset = 0;
  }
  void drawTower(int thescreen){
    if(!on)return;
    if(phase[0]==null)return;
    for(int i=0; i<content.length; i++){
      drawOnScreen(thescreen,content[i],phase[i],positionSet[i][thescreen].x,positionSet[i][thescreen].y,yOffset);
    }
  }
}
