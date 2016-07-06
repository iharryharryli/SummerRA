/*
 * gui.pde contains everything pertaining to the use of G4P(a 2D gui library) except for some uses of GImageButton.setvisible(boolean)
 * GIMageButton declarations, definitions, and eventhandlers(clicks) are in this file.
 */
 
 

public void playMainGameClick(GImageButton source, GEvent event){
  if(untouchable)return;
      commonDelay();
  uiengine.turnBtn(new int[]{1,2,28},false);
  uiengine.turnBtn(new int[]{6},true);
  
  
 
  
  ShuffleArray(scenarioList);

  
  
  println("startMainGame - GImageButton >> GEvent." + event + " @ " + millis());
  output.println(" ");
  output.println("Play Game Mode selected @ Time: "+  minute() + ":"+ second()); // logging to file

  wrongCounter = 0;
  rCounterFlag = 0;
  lCounterFlag = 0;
  
  handsOffTimeout = System.currentTimeMillis() + 60000;
  
  transitionCounter = 0;
  //gs = GameState.MAIN_GAME;
  // ms = MainGameState.PLACING_TOWERS;
  if(towers.size() == 0)
  {
    gs = GameState.MAIN_GAME;
    ms = MainGameState.PLACING_TOWERS;
    towerengine.on = true;
  }
  else
 {
   
   gs = GameState.MAIN_GAME;
   ms = MainGameState.RESET;
   transitionCounter = -1;
  }

  
  
  logger.logging(3,new String[]{hour()+"",minute()+"",second()+"",
                                  3600*hour()+"",60*minute()+"",second()+"",1+""});
} 

public void testMyTowerClick(GImageButton source, GEvent event) { 
  if(untouchable)return;
      commonDelay();
   uiengine.turnBtn(new int[]{1,2,28},false);
   uiengine.turnBtn(new int[]{6},true);
  if(gs == GameState.CHALLENGE){
    challengelogic.control.keepPlayingClick();
    return;
  }
  
    challengelogic.switchIn();
     
     
} 

public void continueClick(GImageButton source, GEvent event) { 
  if(untouchable)return;
      commonDelay();

  source.setEnabled(false);
  
  if(gs == GameState.CHALLENGE){
    challengelogic.control.continueBtnClick();
    source.setEnabled(true);
    return;
  }
  println("continueButton - GImageButton >> GEvent." + event + " @ " + millis());
  
   if(gs == GameState.MAIN_GAME)
    {
      if(ms == MainGameState.PLACING_TOWERS)
      {
        if(handsOffTimeout < System.currentTimeMillis() && !(leftTowerStatus.equals("correct") && rightTowerStatus.equals("correct")))
        {
          
                uiengine.switchOn(new int[]{4});
                handsOffTimeout = System.currentTimeMillis() + 60000;
          
        }
        else
          {
            ms = MainGameState.FALL_PREDICTION;
            towerengine.on = false;
            logger.logging(4,new String[]{currentScenario.tower1,currentScenario.tower2});
          }
          output.println("The towers in the scenario are: Left:  " + currentScenario.tower1 + " Right:  " + currentScenario.tower2  ); 
          output.println("The tower on the " + currentScenario.expectedResult + " should fall first");
      }
      else if(ms == MainGameState.REASON)
      {
        ms = MainGameState.RESET;
        towerengine.on = false;
      }
      else if(ms == MainGameState.UNEXPECTED_OUTCOME)
      {
        ms = MainGameState.PLACING_TOWERS;
        leftTower.clear();
        leftTower.add("notPlaced");
        leftTower.add("notPlaced");
        leftTower.add("notPlaced");
        rightTower.clear();
        rightTower.add("notPlaced");
        rightTower.add("notPlaced");
        rightTower.add("notPlaced");
      }
    }
   
          uiengine.switchOn(new int[]{6});

  source.setEnabled(true);
  commonDelay();
  
} 

public void shakeClick(GImageButton source, GEvent event) {
  if(untouchable)return;
      commonDelay();
  
  source.setEnabled(false);
  
  if(gs == GameState.CHALLENGE){
    challengelogic.control.shakeBtnClick();
    source.setEnabled(true);
    return;
  }
  
  println("shake - GImageButton >> GEvent." + event + " @ " + millis());
  checkRelayStatus();
  switch(gs)
  {
    case MAIN_GAME:
  
    t[0] = currentScenario.tower1;
    t[1] = currentScenario.tower2;
      if(!(towers.contains(t[0]) && towers.contains(t[1])) || towers.size() != 2 || towerIndex.size() !=2)
      {
        leftTower.clear();
        leftTower.add("wrong");
        leftTower.add("wrong");
        leftTower.add("wrong");
        
        rightTower.clear();
        rightTower.add("wrong");
        rightTower.add("wrong");
        rightTower.add("wrong");
        
        ms = MainGameState.PLACING_TOWERS; 
        
        uiengine.switchOn(new int[]{});
  
        handsOffTimeout = System.currentTimeMillis() + 60000;
        source.setEnabled(true);
        return;
      } 
      shakingTimeout = System.currentTimeMillis() + 5000;
      
              uiengine.switchOn(new int[]{});

      ms = MainGameState.SHAKING;
      output.println("Table selected for Shaking @ Time: "+ minute() + ":"+ second());
      
      float centXL = bd.getBoxCentX(towerIndex.get(0));
      float centXR = bd.getBoxCentX(towerIndex.get(1));
      int leftInd;
      int rightInd;
      if(centXL < centXR)
      {
         leftInd = 0;
         rightInd = 1;
      }
      else
      {
        leftInd = 1;
        rightInd = 0;
      }
      
      leftHeight = bd.getBlobHeight(towerIndex.get(leftInd));
      rightHeight = bd.getBlobHeight(towerIndex.get(rightInd));
      
      
      float[] eigArrayLeft = getBlobEigen(bd, towerIndex.get(leftInd));
      float[] eigArrayRight = getBlobEigen(bd, towerIndex.get(rightInd));
      
      leftAngle = eigArrayLeft[0];
      rightAngle = eigArrayRight[0]; 
 
      leftDensity = eigArrayLeft[1];
      rightDensity = eigArrayRight[1];     
      
      relayOn();
      break;
   
    }
    source.setEnabled(true);
  
}

public void predictTower1Click(GImageButton source, GEvent event) { 
  if(untouchable)return;
  println("predictTower1 - GImageButton >> GEvent." + event + " @ " + millis());
  
  guessed = true; 
  guess = "left"; 
  output.println("Left tower predicted to fall first"); //
  uiengine.switchOn(new int[]{4});
  commonDelay();
} 

public void predictTower2Click(GImageButton source, GEvent event) { 
  if(untouchable)return;
  
  guessed = true; 
  guess = "right";
  output.println("Right tower predicted to fall first");
  uiengine.switchOn(new int[]{4});
  
} //_CODE_:predictTower2:839609:

public void predictSameClick(GImageButton source, GEvent event) { 
  if(untouchable)return;
  println("predictSame - GImageButton >> GEvent." + event + " @ " + millis());
  output.println("Both tower predicted to fall at the same time");
  guessed = true; 
  guess = "same";
  uiengine.switchOn(new int[]{4});
  commonDelay();
}

public void predictionCommon(String reason){
      commonDelay();
  logger.logging(5,new String[]{reason});
   ms = MainGameState.REASON;  
    towerengine.on = true;
}

public void predictionTallerClick(GImageButton source, GEvent event) { 
  if(untouchable)return;
  println("predictionTaller - GImageButton >> GEvent." + event + " @ " + millis());
  //out.println("Correct reason: " + "");
  output.println("Reason predicted: Tower is tall @ Time: " + minute() + ":"+ second());
  guessedReason = "taller";
  predictionCommon(guessedReason);
  
} 

public void predictionThinnerClick(GImageButton source, GEvent event) { 
  if(untouchable)return;
  println("predictionThinner - GImageButton >> GEvent." + event + " @ " + millis());
  output.println("Reason predicted: Tower has a thinner base @ Time: " + minute() + ":"+ second());
  guessedReason = "thinner";
   predictionCommon(guessedReason);
} 

public void predictionWeightClick(GImageButton source, GEvent event) { 
  if(untouchable)return;
  println("predictionWeight - GImageButton >> GEvent." + event + " @ " + millis());
  output.println("Reason predicted: Tower has too much weight at the top @ Time: " + minute() + ":"+ second());
  guessedReason = "weight";
   predictionCommon(guessedReason);
}

public void predictionSymmClick(GImageButton source, GEvent event) { 
  if(untouchable)return;
  println("predictionSymm - GImageButton >> GEvent." + event + " @ " + millis());
  output.println("Reason predicted: Tower is unsymmetric @ Time: " + minute() + ":"+ second());
  guessedReason = "symmetry";
  predictionCommon(guessedReason);
}


public void win_draw1(GWinApplet appc, GWinData data) { 
  
  if(!SetupAlready){
    appc.image(loadingPage,0,0);
    return;
  }
  switch(gs)
  {
    case CHALLENGE:
    challengelogic.UI.drawChallengeProjector();
    break;
    
    case MAIN_MENU:
      drawMainMenuProj(appc);
      break;
    case MAIN_GAME:
      drawMainGameProj(appc);
      break;
   
    case COMPETE:
      break;
  }
} 

public void backButtonClick(GImageButton source, GEvent event) {
  if(untouchable)return;
      commonDelay();
  setupHomeScene();
  
  HarryGlobal.audioEngine.cleanUp();
  
  relayOff();
  towerengine.on = false;
 
  
  aplayer.close();
  currPlaying = "";
 
  gs = GameState.MAIN_MENU;
  HarryGlobal.kinectDrawDelegate = null;
  HarryGlobal.kinectDrawDelegate = new KinectForGames(HarryGlobal.kinectDrawer);
  output.println(" ");
 
} 

public void keepPlayingClick(GImageButton source, GEvent event) { 
  source.setEnabled(false);
  output.println(" ");
  output.println("Game mode continued");
  uiengine.switchOn(new int[]{});
  
  if(towers.size() == 0)
  {
    gs = GameState.MAIN_GAME;
    ms = MainGameState.PLACING_TOWERS;
  }
  else
  {
    gs = GameState.MAIN_GAME;
    ms = MainGameState.RESET;
    transitionCounter = -1;
  }
  source.setEnabled(true);
}


// Create all the GUI controls. 
// autogenerated do not edit
public void createGUI(){
  
  loadingPage = loadImage("loading.png");
  loadingPage.resize(projectorWidth,projectorHeight);
  
  
  G4P.messagesEnabled(false);
  G4P.setGlobalColorScheme(GCScheme.BLUE_SCHEME);
  G4P.setCursor(ARROW);
  if(frame != null)
    frame.setTitle("Tablet Window ");

  if(DISPLAY_ARRANGEMENT == 0)  window1 = new GWindow(this, "EarthShake Projector", 0, 0, projectorWidth, projectorHeight, FULL_SCREEN_MODE, JAVA2D); // The flag is set as true to remove borders and make it fullscreen on the projector
  else window1 = new GWindow(this, "EarthShake Projector", touchscreenWidth, 0, projectorWidth, projectorHeight, FULL_SCREEN_MODE, JAVA2D); // The flag is set as true to remove borders and make it fullscreen on the projector
 
  window1.setActionOnClose(G4P.EXIT_APP);
  window1.addDrawHandler(this, "win_draw1");
  
  UIScreen s1 = new UIScreen(this,new PVector(touchscreenWidth,touchscreenHeight),"AssetsTablet/");
  UIScreen s2 = new UIScreen(window1.papplet,new PVector(projectorWidth,projectorHeight),"AssetsProjector/");

  
  uiengine = new UIEngine(new UIScreen[]{s1,s2});
  
  projectorDrawDelegate = window1.papplet;
  setupRulers();
  
  /*
  IDs:
  
  Buttons:
  1: play game button 
  2: test tower button
  3: continue button
  4: shake button 
  6: home button
  12: predict first tower
  13: predict second tower
  14: predict same
  15: predict first tower -> projector
  16: predict second tower -> projector
  17: predict same -> projector
  18 ~ 21: different reasons buttons
  28: keep playing button
  
  Images:
  0: the gorrila on the main menu page
  5: main menu background
  7: background with table and circles
  8: background with table but no circles
  11: gorilla waiting for shake
  100+: texts
  23: remove-arrows
  24: down-arrow 
  25: too many towers
  26: hourglass
  27: transition text (play game mode)
  29: transition text (test tower mode)
  30: crying gorilla
  31: transparent too many towers
  32: unexpected outcome
  
  Animations:
  9: proud gorilla
  10: sad gorilla
  22: jump gorilla
  */
  
  //Tower Arrow Configuration
  float www = 0.15, hhh = 0.17;
  
  UIElement[] L =new UIElement[] {new UIButton(new int[]{0,1},1,this,new String[]{"ui_elements/play_game_btn.png"},0.45,0.3,0.4,0.192,"playMainGameClick"),
      new UIButton(new int[]{0,1},2,this,new String[]{"ui_elements/test_my_tower_btn.png"},0.45,0.55,0.4,0.192,"testMyTowerClick"),
      new UIButton(new int[]{0},3,this,new String[]{"ui_elements/continue_btn.png"},0.35,0.82,0.3,0.17,"continueClick"),
      new UIButton(new int[]{1},3,this,new String[]{"ui_elements/continue_btn.png"},0.55,0.83,0.26,0.14,"continueClick"),
      new UIButton(new int[]{0},4,this,new String[]{"ui_elements/shake_btn.png"},0.35,0.82,0.3,0.17,"shakeClick"),
      new UIButton(new int[]{1},4,this,new String[]{"ui_elements/shake_btn.png"},0.55,0.83,0.26,0.14,"shakeClick"),
      new UIButton(new int[]{0},6,this,new String[]{"ui_elements/home_button.png"},0.83,0.8,0.13,0.17,"backButtonClick"),
      new UIButton(new int[]{1},6,this,new String[]{"ui_elements/home_button.png"},0.87,0.83,0.13,0.17,"backButtonClick"),
      
      new UIButton(new int[]{0},12,this,new String[]{"ui_elements/tower_first.png"},0.27,0.27,www,hhh,"predictTower1Click"),
      new UIButton(new int[]{0},13,this,new String[]{"ui_elements/tower_second.png"},0.53,0.27,www,hhh,"predictTower2Click"),
      new UIButton(new int[]{0},14,this,new String[]{"ui_elements/tower_same.png"},0.4,0.27,www,hhh,"predictSameClick"),
      
      new UIButton(new int[]{1},15,this,new String[]{"ui_elements/tower_first.png"},0.46,0.25,www,hhh,"predictTower1Click"),
      new UIButton(new int[]{1},16,this,new String[]{"ui_elements/tower_second.png"},0.72,0.25,www,hhh,"predictTower2Click"),
      new UIButton(new int[]{1},17,this,new String[]{"ui_elements/tower_same.png"},0.59,0.25,www,hhh,"predictSameClick"),
      
      new UIButton(new int[]{0,1},18,this,new String[]{"ui_elements/taller_btn.png"},0.03,0.73,0.241,0.273,"predictionTallerClick"),
      new UIButton(new int[]{0,1},19,this,new String[]{"ui_elements/thinner_base_btn.png"},0.27,0.73,0.241,0.273,"predictionThinnerClick"),
      new UIButton(new int[]{0,1},20,this,new String[]{"ui_elements/more_weight_btn.png"},0.51,0.73,0.241,0.273,"predictionWeightClick"),
      new UIButton(new int[]{0,1},21,this,new String[]{"ui_elements/symmetrical_btn.png"},0.75,0.73,0.241,0.273,"predictionSymmClick"),
      new UIButton(new int[]{0,1},28,this,new String[]{"ui_elements/keep_playing.png"},0.45,0.3,0.4,0.192,"keepPlayingClick"),
      
  
      new UIImage(new int[]{0,1},0,0.03,0.25,0,0.7,"Assets/sprites/proud1.png"),
      new UIImage(new int[]{0,1},5,0,0,1,1,"AssetsProjector/ui_elements/main_screen_background_tablet.png"),
      
      new UIImage(new int[]{0},7,0,0,1,1,"AssetsTablet/ui_elements/background_tablet.png"),
      new UIImage(new int[]{1},7,0,0,1,1,"AssetsProjector/ui_elements/background_projector.png"),
      
      new UIImage(new int[]{0},8,0,0,1,1,"AssetsProjector/ui_elements/background_tablet_noCircles.png"),
      new UIImage(new int[]{1},8,0,0,1,1,"AssetsProjector/ui_elements/background_projector_noCircles.png"),
      new UIImage(new int[]{1},11,0.03,0.25,0,0.7,"Assets/sprites/shakingTable.png"),
      new UIImage(new int[]{0},23,0.4,0.45,0,0.2,"Assets/images/arrows.png"), 
      new UIImage(new int[]{1},23,0.55,0.45,0,0.2,"Assets/images/arrows.png"), 
      new UIImage(new int[]{0},24,0.45,0.35,0,0.5,"AssetsProjector/ui_elements/down_arrow_makemytower.png"), 
      new UIImage(new int[]{1},24,0.62,0.32,0,0.5,"AssetsProjector/ui_elements/down_arrow_makemytower.png"), 
      new UIImage(new int[]{0},25,0.32,0.27,0,0.5,"AssetsTablet/ui_elements/too_many_towers.png"), 
      new UIImage(new int[]{1},25,0.5,0.23,0,0.5,"AssetsTablet/ui_elements/too_many_towers.png"), 
//      new UIImage(new int[]{0},26,0.42,0.22,0.4,0,"AssetsTablet/ui_elements/hour_glass.png"), 
//      new UIImage(new int[]{1},26,0.72,0.3,0.3,0,"AssetsTablet/ui_elements/hour_glass.png"),
      new UIImage(new int[]{0},26,0.56,0.22,0.4,0,"hour_glass_flipped.png"),
      new UIImage(new int[]{1},26,0.71,0.3,0.3,0,"hour_glass_flipped.png"),
      new UIImage(new int[]{0},27,-0.1,0,1,0.358,"Assets/text/transition.png"), 
      new UIImage(new int[]{1},27,-0.07,0.02,0.8,0.28,"Assets/text/transition.png"), 
      new UIImage(new int[]{0},29,-0.1,0,1,0.358,"Assets/text/transition_toPlayGame.png"), 
      new UIImage(new int[]{1},29,-0.07,0.02,0.8,0.28,"Assets/text/transition_toPlayGame.png"), 
      new UIImage(new int[]{1},30,0.03,0.25,0,0.7,"Assets/sprites/sad2.png"),
      new UIImage(new int[]{0},31,0.32,0.27,0,0.5,"ChallengeMode/only_one_tower.png"), 
      new UIImage(new int[]{1},31,0.5,0.23,0,0.5,"ChallengeMode/only_one_tower.png"),
      new UIImage(new int[]{0},32,0.32,0.27,0,0.5,"AssetsTablet/ui_elements/place_in_correct_spot.png"), 
      new UIImage(new int[]{1},32,0.5,0.23,0,0.5,"AssetsTablet/ui_elements/place_in_correct_spot.png"), 
      
      
      
      new UIAnimation(new int[]{1},9,0.03,0.25,0,0.7,"Assets/sprites/proud",".png",6,6),
      new UIImage(new int[]{1},10,0.03,0.25,0,0.7,"Assets/sprites/sad1.png"),
      new UIAnimation(new int[]{1},22,0.03,0.25,0,0.7,"Assets/sprites/jump",".png",7,6),
      
      
    };
  
  
   uiengine.setupUI(L);
  
   
   /*
   Text Index: from 100
   */
   processTexts(new String[]{
                   "Assets/text/place_both.png", //0
                   "Assets/text/place_continue.png",//1
                   "Assets/text/place_wrong_right.png",
                   "Assets/text/place_wrong_left.png",
                   "Assets/text/place_left.png",
                   "Assets/text/place_right.png",//5
                   "Assets/text/place_wrong_both.png",
                   "Assets/text/clear_table.png",
                   "Assets/text/place_too_many.png",
                   "Assets/text/hypothesis_correct_left.png",
                   "Assets/text/hypothesis_wrong_left.png",//10
                   "Assets/text/hypothesis_correct_right.png",
                   "Assets/text/hypothesis_wrong_right.png",
                   "Assets/text/expl_correct_symm.png",
                   "Assets/text/expl_wrong_symm.png",
                   "Assets/text/expl_correct_taller.png",//15
                   "Assets/text/expl_wrong_taller.png",
                   "Assets/text/expl_correct_thinner.png",
                   "Assets/text/expl_wrong_thinner.png",
                   "Assets/text/expl_correct_weight.png",
                   "Assets/text/expl_wrong_weight.png",//20
                   "Assets/text/prediction_intro.png",
                   "Assets/text/prediction_left_first.png",
                   "Assets/text/prediction_right_first.png",
                   "Assets/text/prediction_same_first.png",
                   "Assets/text/expl_handsoff.png", //25
                   "Assets/text/testmytower_goodjob.png",
                   "Assets/text/testmytower_notower.png",
                   "Assets/text/testmytower_place1tower.png",
                   "Assets/text/testmytower_towerfell.png",
                   "Assets/text/testTowerPrompt.png", //30
                   "Assets/text/tmtPrompt.png",
                    "Assets/text/testmytower_placeonlyonetower.png",
                     "Assets/text/transition.png",
                   "Assets/text/unexpected.png",
                   "ChallengeMode/text/text_bubble_challenge_not_tall_enough.png",   //35
                   "ChallengeMode/text/text_bubble_challenge_ruler_tall_enough.png", 
                   "ChallengeMode/text/text_bubble_challenge_tower_fell.png", 
                   "ChallengeMode/text/text_bubble_challenge_tower_stayed_up.png", 
                   "ChallengeMode/text/prompt.png", 
                   "ChallengeMode/text/handsoff.png", //40
                   "ChallengeMode/text/goodjob.png", 
                   
                 },0,0,1,0.358,0.2,0.02,0.8,0.28,100);
                 
                 
       /*
       Tower Index: from 500
       */
       prepareTowers(500);
       
       
       
  

}

//helper functions for generating uielements
int processTexts(String[] sources,float xPos,float yPos,float wwidth,float hheight,float xPos1,float yPos1,float wwidth1,float hheight1,int startID ){
  UIImage[] res = new UIImage[(sources.length)*2];
  TextAssociation[] ass = new TextAssociation[sources.length];
  int ID = startID-1;
  
  int count = 0;

  for(int i=0; i<sources.length; i++){
    ID++;
    res[count] = new UIImage(new int[]{0},ID,xPos,yPos,wwidth,hheight,sources[i]);
    count++;
    ID++;
    res[count] = new UIImage(new int[]{1},ID,xPos1,yPos1,wwidth1,hheight1,sources[i]);
    count++;
    ass[i] = new TextAssociation(i,new int[]{ID-1,ID});
  }
  
  uiengine.setupUI(res);
  
  textengine = new TextEngine(ass,uiengine);
  
  return ID;
}

int createTower(String name,String[] content,int ID,float ww1,float hh1,float ww2, float hh2){
  
  int n = (content.length)/2;
  TowerAssociation[] list = new TowerAssociation[n];
  for(int i=0; i<n; i++){
    String filePath = "Assets/towers/" + content[2*i+1];
    UIElement[] L = new UIElement[]{
          new UIImage(new int[]{0},ID,0,0,ww1,hh1,filePath),
          new UIImage(new int[]{1},ID,0,0,ww2,hh2,filePath)
      };
    uiengine.setupUI(L);
    list[i] = new TowerAssociation(content[2*i],ID);
    
    ID++;
  }
  Tower la = new Tower(name,list);
  towerengine.addTower(la);
  return (ID);
}

int prepareTowers(int startID){
  int ID_record = startID;
  float WW1 = 0.35, HH1 = 0, WW2 = 0.35, HH2 = 0;
  
  towerengine = new TowerEngineDouble(uiengine,new PVector[][]{new PVector[]{new PVector(0.19,0.27),new PVector(0.38,0.21)},
                                                               new PVector[]{new PVector(0.44,0.27),new PVector(0.627,0.21)}});
  towerengine.yOffset = - 0.15;
  String[][] L = new String[][]{
              new String[]{"A1","arrow","correct","expl","expl_weight","handsoff","tower","wrong"},
              new String[]{"A2","arrow","correct","expl","expl_weight","handsoff","tower","wrong"}, 
              new String[]{"B1","arrow","correct","expl","expl_thinner","handsoff","tower","wrong"},
              new String[]{"B2","arrow","correct","expl","expl_thinner","handsoff","tower","wrong"},  
              new String[]{"B3","arrow","correct","expl_thinner","handsoff","tower","wrong"},
              new String[]{"B4","arrow","correct","expl_thinner","handsoff","tower","wrong"},
              new String[]{"C1","arrow","correct","expl_symmetry","handsoff","tower","wrong"},
              new String[]{"C2","arrow","correct","expl_symmetry","expl_taller","handsoff","tower","wrong"},
              new String[]{"D1","arrow","correct","expl_thinner","expl_weight","handsoff","tower","wrong"},
              new String[]{"D2","arrow","correct","expl_thinner","expl_symmetry","expl_taller","handsoff","tower","wrong"},
              new String[]{"D3","arrow","correct","expl_symmetry","expl_taller","handsoff","tower","wrong"},
              new String[]{"D4","arrow","correct","expl","expl_symmetry","handsoff","tower","wrong"},
              new String[]{"E1","arrow","correct","expl_taller","handsoff","tower","wrong"},
              new String[]{"E2","arrow","correct","expl_weight","handsoff","tower","wrong"},
              
              
                                                          };
  
  for(int i=0; i<L.length; i++){
    String[] T = L[i];
    String name = T[0];
    String[] R = new String[2*(T.length - 1)];
    for(int j=1; j<T.length; j++){
      R[2*j-2] = T[j];
      R[2*j-1] = name + "_" + T[j] + ".png";
    }
    ID_record = createTower(name,R,ID_record,WW1,HH1,WW2,HH2);
  }
  
  towerengine.content = t;
  
  return ID_record;
}




// Variable declarations 
// autogenerated do not edit

GWindow window1;



GImageButton keepPlaying;
GImageButton keepPlayingProj;

//Harry's helper functions
void drawTextOnTablet(String text){
  fill(51);
  textSize(34*touchscreenWidth/1024);
  text(text, 0.78*touchscreenWidth, 0.4*touchscreenHeight); 
}
void drawTextOnProjector(PApplet appc,String text){
  appc.fill(32);
  appc.textSize(34*projectorWidth/1280);
  appc.text(text, 0.87*projectorWidth, 0.44*projectorHeight); 
}
void commonDelay(){
  int ddelay = 500;
  untouchable = true;
  Timer timer = new Timer();
  timer.schedule(new TimerTask(){
    public void run(){
      untouchable = false;
    }
  },ddelay);  

}
