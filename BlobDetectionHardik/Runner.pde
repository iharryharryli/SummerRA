//Debug Purpose
boolean CHALLENGE_MODE_ON = false;
boolean COMPETE_MODE_ON = false;
int DISPLAY_ARRANGEMENT = 1;  // 0 for debug, 1 for projector 
public int projectorWidth = 1920;
public int projectorHeight = 1080; 
public boolean FULL_SCREEN_MODE = true;
public boolean PLAY_INSTRUCTION_EVERY_TRIAL = false;


// Need G4P library
import g4p_controls.*;
import javax.swing.JFrame;
import java.awt.Rectangle;
import java.util.*;


String currPlaying = "";



import processing.serial.*;
import blobscanner.*;
import blobDetection.*;
import SimpleOpenNI.*;
import gab.opencv.*;
import org.opencv.core.Core;
import org.opencv.core.Mat;
import org.opencv.core.Size;
import org.opencv.core.Point;
import org.opencv.core.Scalar;
import org.opencv.core.CvType;
import org.opencv.core.MatOfPoint;
import org.opencv.imgproc.Imgproc;
OpenCV opencv;


String guess;
boolean guessed;
String fallen;
String reason, guessedReason;
Scenario[] scenarioList;
Scenario currentScenario;
int currentScenarioIndex;


// Make the Screen/projector/computer resolution equal

public int touchscreenWidth = 1024;
public int touchscreenHeight = 600;


// These Values need to be calibrated by Young Wook for making sure that the towers are placed at the patch of the Blocks
int kinectCenter = 301; 
int leftTowerLeft = 191;
int leftTowerRight = 271;
int rightTowerLeft = 340;
int rightTowerRight = 415;

//Look at the frame count to decide 
long shakingTimeout = 0;
long startTime;
long fallTime;
long gameTimeout;
long handsOffTimeout;
int oldNumBlobs = -1;
String shakeTime = "";
float elapsedTime = 0.0;
boolean tmtStood = false;
boolean placed1 = false;
boolean placed2 = false;
int transitionCounter = 0;

public GameState gs;
public MainGameState ms;

ArrayList<Integer> towerIndex;
ArrayList<String> towers;

String[] t;

List<String> leftTower;
List<String> rightTower;



String leftTowerStatus;
String rightTowerStatus;

PImage testTowerBG;

int[] towerIndices;

long leftWrongTimeout  = System.currentTimeMillis();
long rightWrongTimeout = System.currentTimeMillis(); 
long wrongTimeout = 3500;
int wrongCounter = 0;
int wrongAttempts = 10;
int lCounterFlag = 0;
int rCounterFlag = 0;
long handTimeout = 1000;
long tableHoldTimeout = 0;
float shakingRange = 20;

FloatList centroidTower;

// variables for logging 
PrintWriter output;
File filename;

//DEBUGGING
PFrame debugFrame;

//Harry UI
boolean SetupAlready = false;
UIEngine uiengine;
TextEngine textengine;
TowerEngineDouble towerengine;
int[] TestMyTowerStages = null;
boolean TestMyTowerIsDrawingKinect = false;
PImage loadingPage;
PGraphics pgKinectTablet,pgKinectProjector;
PApplet tabletDrawDelegate;
PApplet projectorDrawDelegate;
boolean untouchable = false;

//Harry Logging
Logger logger;

//Challenge Mode
ChallengeLogic challengelogic;

//Global Variable
HarryGlobalClass HarryGlobal;

//Compete Mode
CompeteLogic competelogic;



public void setup(){
  
  HarryGlobal = new HarryGlobalClass();
  
  createGUI();
  
  size(touchscreenWidth,touchscreenHeight, JAVA2D);
  
  AudioSetup();
  
  //challengelogic = new ChallengeLogic(); //gameTimeout = System.currentTimeMillis() + 120000;
  gs = GameState.MAIN_MENU;
  
  
  guessed = false;
  guess = "";
  fallen = "";
  reason = "";
  guessedReason = "";
  
  scenarioList = listOfScenarios(); 
  
  setupHardik();
   //  relayOff();
  //BEGIN DEBUGING
  debugFrame = new PFrame();
  //leftTower.clear();
  leftTower = new ArrayList<String>();
  leftTower.add("notPlaced");
  leftTower.add("notPlaced");
  leftTower.add("notPlaced");
  
 
  rightTower = new ArrayList<String>();
  rightTower.add("notPlaced");
  rightTower.add("notPlaced");
  rightTower.add("notPlaced");
  
 
  towers     = new ArrayList();
  towerIndex = new ArrayList();
  centroidTower = new FloatList();
  
  // setup for file logging 
  String logfilename = "C:/Users/Norilla/Desktop/NorillaLog/Norilla" + month() + day() + year() + "-" + hour()+ "_" + minute() + ".txt";
  filename = new File(logfilename);
  output = createWriter(filename);
  


  t = new String[2];
  //
  
   
   //logging
   String filename1 = "C:/Users/Norilla/Desktop/NorillaLog/HarryLog" + month() + day() + year() + "-" + hour()+ "_" + minute() + ".txt";
   String filename2 = "C:/Users/Norilla/Desktop/NorillaLog/HarryFormatted" + month() + day() + year() + "-" + hour()+ "_" + minute() + ".txt";
   PrintWriter file1 = createWriter(new File(filename1));
   PrintWriter file2 = createWriter(new File(filename2));
   
   
   logger = new Logger(new LogItem[]{
               new LogItem(file1, new Object[]{new Integer(0),"\r\n"}),
               new LogItem(file2, new Object[]{new Integer(0),"\r\n"}),
               new LogItem(file2, new Object[]{"ButtonPressed\t",new Integer(0),"\t"}),
               new LogItem(file2, createEntry()),
               new LogItem(file2,createSituationLog()),
               new LogItem(file2,createPredictionLog()),
           });
   
   //setup detection 
   detection();
  
  
  logger.logging(0,new String[]{"Setup Successful"});
  logger.logging(1,new String[]{"Anon Student Id\t Session Id\t Time\t Time Zone\t Student Response Type\t  Tutor Response Type\t  Selection\t  Level(Unit)\t  Level(Section)\t Attempt At Step\t Problem Name\t  Step Name\t  Action\t Input\t   Outcome\t    Feedback Text\t Feedback Classification\t  Condition Name\t  Condition Type\t  KC(Default)\t  KC Category(Default)\t  School\t Class"});
  
  
  challengelogic = new ChallengeLogic();
  if(COMPETE_MODE_ON)competelogic = new CompeteLogic();
  
  
  frameRate(25);
  
  
  Timer timer = new Timer();
  timer.schedule(new TimerTask(){
    public void run(){
      println("done with setup");
      setupHomeScene();
      SetupAlready = true;
      
    }
  },2000);  
  
  
  
  
}

public long lastF = 0;



public void detection(){
  
  Image_filtering();
  Timer timer = new Timer();
  timer.schedule(new TimerTask(){
    public void run(){
      detection();
    }
  },1);  
  
}

public void draw()
{
  
  
  if(gs == GameState.MAIN_MENU || gs == GameState.CHALLENGE || gs == GameState.MAIN_GAME){
      currentScenario = scenarioList[currentScenarioIndex];  
     
      t[0] = currentScenario.tower1;
      t[1] = currentScenario.tower2;
      towerengine.content = t;
     
      
      
      
      bd = getBlobScannerObject(bd,srcImage);
      GameUnAttended();
      IndexArray = getNum_getIndex (bd);
      
       //getNum_getIndex does not currently return the num.
      towerIndices = IndexArray.array();
      
      if( towers != null)
        towers.clear();
      
      if(towerIndex != null)
        towerIndex.clear();
      
      
      for(int i = 0; i < towerIndices.length; i++) 
      {
        
        String[] towerInfo = getTowerName(bd,towerIndices[i]);
        String  FTowerLabel;
        if(towerInfo[1].equals("right"))
          FTowerLabel= getTowerName(bd,towerIndices[i])[0];
        else
          FTowerLabel = "WrongOrientation";
        if(bd.getD()[towerIndices[i]].y > HarryGlobal.groundThreshold)
        {
          towers.add(FTowerLabel.substring(0,2));
          towerIndex.add(towerIndices[i]);
        }
        
      }
  }
  
  
  
  
  
  
  //checkRelayStatus();
  switch(gs)
  {
    
   
    case CHALLENGE:
    challengelogic.play();
    challengelogic.UI.drawChallengeTablet();
    break;
    
    case COMPETE:
    competelogic.render(0);
    break;
    
    
    case MAIN_MENU:
    
    gameTimeout = System.currentTimeMillis() + 120000;
    
    drawMainMenu();
    //delay(100);
    break;
    
    
    case MAIN_GAME:
    
    if(ms != MainGameState.REASON_PREDICTION)
    {
      
    }
    drawMainGame(); 
    
    switch(ms)
    {
      case PLACING_TOWERS:
      towerengine.on = true;
      currSprite = 0;
      guessed = false;
      guess = "";
      fallen = "";
      reason = currentScenario.reason;
      guessedReason = "";
      towerManager();
      //left tower is correct
      int freqValue = 3; //can be 1 or 2 or 3
      if(Collections.frequency(leftTower, "correct") >= freqValue)
         leftTowerStatus = "correct";
       
      //left tower is not placed
      else if(Collections.frequency(leftTower, "notPlaced") >= freqValue)
              leftTowerStatus = "notPlaced";
      // left tower is tooMany
      else if(Collections.frequency(leftTower, "tooMany") >= freqValue)
              leftTowerStatus = "tooMany";
      
      //left tower is incorrect
      else
          leftTowerStatus = "wrong";
      
      //left tower is correct
      if(Collections.frequency(rightTower, "correct") >= freqValue)
         rightTowerStatus = "correct";
      
      //left tower is not placed
      else if(Collections.frequency(rightTower, "notPlaced") >= freqValue)
        rightTowerStatus = "notPlaced";
      
      //too many towers placed
      else if(Collections.frequency(rightTower, "tooMany") >= freqValue)
        rightTowerStatus = "tooMany";
      
      //left tower is incorrect
      else
        rightTowerStatus = "wrong";
           
      if (wrongCounter>wrongAttempts)
      {
        // Add a audio to mention the fact that you took too many attempts lets start with a new scenario
        ms = MainGameState.RESET;
        wrongCounter = 0;
        rCounterFlag = 0;
        lCounterFlag = 0;
      }
          
      if(leftTowerStatus.equals("notPlaced") && rightTowerStatus.equals("notPlaced"))
      {
        rCounterFlag =0;
        lCounterFlag = 0;
        leftWrongTimeout = System.currentTimeMillis() + wrongTimeout;
        rightWrongTimeout = System.currentTimeMillis() + wrongTimeout;
        placed1 = false;
        placed2 = false;
        if(!currPlaying.equals("placeBoth"))
        {  
          aplayer.close();
          aplayer = minim.loadFile("Assets/audio/place_both.wav", 2048);
          aplayer.play();
          currPlaying = "placeBoth";
        }
         
        textengine.changeText(0);  
        
        towerengine.phase[0] = "arrow";
        towerengine.phase[1] = "arrow";
       
      }
      else if(leftTowerStatus.equals("correct") && rightTowerStatus.equals("notPlaced"))
      {
        rCounterFlag = 0;
        rightWrongTimeout = System.currentTimeMillis() + wrongTimeout;
        if(!currPlaying.equals("placeRight"))
        {
          aplayer.close();
          aplayer = minim.loadFile("Assets/audio/place_right.wav", 2048);
          aplayer.play();
          currPlaying = "placeRight";
        }
        
        textengine.changeText(5);
        
        towerengine.phase[0] = "correct";
        towerengine.phase[1] = "arrow";

      }
       
      else if(leftTowerStatus.equals("notPlaced") && rightTowerStatus.equals("correct"))
      {
        lCounterFlag = 0;
        leftWrongTimeout = System.currentTimeMillis() + wrongTimeout;
        if(!currPlaying.equals("placeLeft"))
        {
          aplayer.close();
          aplayer = minim.loadFile("Assets/audio/place_left.wav", 2048);
          aplayer.play();
          currPlaying = "placeLeft";
        }
        
        textengine.changeText(4);
        towerengine.phase[0] = "arrow";
        towerengine.phase[1] = "correct";
      
      }
      
      else if(leftTowerStatus.equals("notPlaced") && rightTowerStatus.equals("wrong"))
      {
        lCounterFlag = 0;
        leftWrongTimeout = System.currentTimeMillis() + wrongTimeout;
        placed1 = false;
        if (rightWrongTimeout < System.currentTimeMillis() )
        {
          if (rCounterFlag == 0)      
          {
            wrongCounter += 1;
            rCounterFlag = 1;
          }
          
          placed2 = true;
          textengine.changeText(2);
          
          towerengine.phase[0] = "arrow";
          towerengine.phase[1] = "wrong";
          uiengine.switchOn(new int[]{6});
         
          return;
        }    
        
        towerengine.phase[0] = "arrow";
      
        if(rightWrongTimeout <System.currentTimeMillis() +(wrongTimeout-handTimeout))
        {
          placed2 = true;
          textengine.changeText(25);
          towerengine.phase[0] = "handsoff";
          towerengine.phase[1] = "handsoff";
      
        }
        else
        {
          textengine.changeText(0);  
          towerengine.phase[1] = "arrow";
      
        }
      }
      else if(leftTowerStatus.equals("wrong") && rightTowerStatus.equals("notPlaced"))
      {
        rCounterFlag = 0;
        placed2 = false;
        rightWrongTimeout = System.currentTimeMillis() + wrongTimeout;
        if (leftWrongTimeout < System.currentTimeMillis() )
        {
          if (lCounterFlag == 0)
          {
            wrongCounter += 1;
            lCounterFlag = 1;
          }
          
          placed1 = true;
          textengine.changeText(3);
          
          towerengine.phase[0] = "wrong";
          towerengine.phase[1] = "arrow";
          uiengine.switchOn(new int[]{6});
      
          return;
        }
        
       
          towerengine.phase[1] = "arrow";
  
        if(leftWrongTimeout <System.currentTimeMillis() +(wrongTimeout-handTimeout))
        {
          placed1 = true;
          textengine.changeText(25);
          towerengine.phase[0] = "handsoff";
      
        }
        else
        {
          textengine.changeText(0);  
          
          towerengine.phase[0] = "arrow";
          
  
        }
      }
      
      else if(leftTowerStatus.equals("correct") && rightTowerStatus.equals("correct"))
      {
        placed1 = true;
        placed2 = true;
        if(!currPlaying.equals("placeContinue"))
        {
          aplayer.close();
          aplayer = minim.loadFile("Assets/audio/place_continue.wav", 2048);
          aplayer.play();
          currPlaying = "placeContinue";
        }
        
        textengine.changeText(1);
        towerengine.phase[0] = "correct";
          towerengine.phase[1] = "correct";
        
        uiengine.switchOn(new int[]{3,6});
    //    continueButton.setVisible(true);
    //    continueButtonProj.setVisible(true);
        break;
      }
      
      else if(leftTowerStatus.equals("correct") && rightTowerStatus.equals("wrong"))
      {
        placed1 = true;
        if (rightWrongTimeout < System.currentTimeMillis() )
        {
          if (rCounterFlag ==0)
          {
            wrongCounter += 1;
            rCounterFlag = 1;
          }
          
          placed2 = true;
          textengine.changeText(2);
          towerengine.phase[0] = "correct";
          towerengine.phase[1] = "wrong";
          uiengine.switchOn(new int[]{6});
          return;
        }
              
        
        towerengine.phase[0] = "correct";
        
        if(rightWrongTimeout <System.currentTimeMillis() +(wrongTimeout-handTimeout))
        {
          placed2 = true;
          textengine.changeText(25);
          towerengine.phase[1] = "handsoff";
        }
        
        else
        {
           textengine.changeText(5);
          towerengine.phase[1] = "arrow";
        }
      }
      
      else if(leftTowerStatus.equals("wrong") && rightTowerStatus.equals("correct"))
      {
        placed2 = true;
        if (leftWrongTimeout < System.currentTimeMillis())
        {
          if (lCounterFlag ==0)
          {
            wrongCounter += 1;
            lCounterFlag = 1;
          }
          
          placed1 = true;
          textengine.changeText(3);
          towerengine.phase[0] = "wrong";
          towerengine.phase[1] = "correct";
          uiengine.switchOn(new int[]{6});
          return;
        }
        
          towerengine.phase[1] = "correct";
       
        if(leftWrongTimeout <System.currentTimeMillis() +(wrongTimeout-handTimeout))
        {
          placed1 = true;
          textengine.changeText(25);
          towerengine.phase[0] = "handsoff";
        }
        
        else
        {
          textengine.changeText(4);
          towerengine.phase[0] = "arrow";
        }
      }
      
      else if(leftTowerStatus.equals("wrong") && rightTowerStatus.equals("wrong"))
      {
        // Here 
        if (leftWrongTimeout < System.currentTimeMillis() && rightWrongTimeout <System.currentTimeMillis())
        {
          if (lCounterFlag ==0 || rCounterFlag == 0)
          {
            wrongCounter += 1;
            lCounterFlag =1;
            rCounterFlag =1;
          }
          
          placed1 = true;
          placed2 = true;
          textengine.changeText(6);
          towerengine.phase[0] = "wrong";
          towerengine.phase[1] = "wrong";
          uiengine.switchOn(new int[]{6});
          return;
        }
        
        else if (leftWrongTimeout < System.currentTimeMillis() && rightWrongTimeout > System.currentTimeMillis())
        {
          placed1 = true;
          towerengine.phase[0] = "wrong";
         
          if(rightWrongTimeout < System.currentTimeMillis()+(wrongTimeout -handTimeout))
          {
            placed2 = true;
            textengine.changeText(25);
            towerengine.phase[1] = "handsoff";
          }
          
          else
          {
            textengine.changeText(3);
          towerengine.phase[1] = "arrow";
          }
        }
        
        else if (leftWrongTimeout > System.currentTimeMillis() && rightWrongTimeout < System.currentTimeMillis())
        {
          placed2 = true;
          towerengine.phase[1] = "wrong";
          if(leftWrongTimeout < System.currentTimeMillis()+(wrongTimeout -handTimeout))
          {
            placed1 = true;
            textengine.changeText(25);
            towerengine.phase[0] = "handsoff";
          
          }
          
          else
          {
            textengine.changeText(2);
            towerengine.phase[0] = "arrow";
          }
        }
        
        else
        {
          if(leftWrongTimeout <System.currentTimeMillis() +wrongTimeout -handTimeout)
          {
            placed1 = true;
            placed2 = true;
            textengine.changeText(25);
            towerengine.phase[0] = "handsoff";
            towerengine.phase[1] = "handsoff";
          }
          
          else
          {
            textengine.changeText(0);  
            towerengine.phase[0] = "arrow";
          towerengine.phase[1] = "arrow";
          }
        }
      }
      
      else if(leftTowerStatus.equals("tooMany") && rightTowerStatus.equals("tooMany"))
      {
        placed1 = true;
        placed2 = true;
        //Need assets saying too many objects in scene. Maybe still search for towers once we know where the left and right ones shoudl roughly be
        //Same as length = 0 + additional message saying there is too much in the scene?
        textengine.changeText(8);
        towerengine.phase[0] = "wrong";
          towerengine.phase[1] = "wrong";
      }
      
      //Catch all, should not occur, repeating both wrong code
      else
      {
        placed1 = true;
        placed2 = true;
        textengine.changeText(6);
        towerengine.phase[0] = "wrong";
          towerengine.phase[1] = "wrong";
      }
      
      if(!(leftTowerStatus.equals("correct") && rightTowerStatus.equals("correct")))uiengine.switchOn(new int[]{6});
      //continueButton.setVisible(false);
      //continueButtonProj.setVisible(false);
      break;
      
      case FALL_PREDICTION:

       drawContours();
      if(guessed == false)
      {
        if(!currPlaying.equals("placePred"))
        {
          aplayer.close();
          aplayer = minim.loadFile("Assets/audio/prediction_intro.wav", 2048);
          aplayer.play();
          currPlaying = "placePred";
        }
                
        textengine.changeText(21);
        
        uiengine.switchOn(new int[]{12,13,14,15,16,17,6});
       
      }
      
      else
      {
       
        if(guess.equals("left"))
        {
          if(!currPlaying.equals("predLeft"))
          {
            aplayer.close();
            aplayer = minim.loadFile("Assets/audio/prediction_left_first.wav", 2048);
            aplayer.play();
            currPlaying = "predLeft";
            logger.logging(2,new String[]{"Left"});
          }
          
          textengine.changeText(22);
        }
        
        else if(guess.equals("right"))
        {
          if(!currPlaying.equals("predRight"))
          {
            aplayer.close();
            aplayer = minim.loadFile("Assets/audio/prediction_right_first.wav", 2048);
            aplayer.play();
            currPlaying = "predRight";
            logger.logging(2,new String[]{"Right"});
          }
          
          textengine.changeText(23);
        }
        
        else if(guess.equals("same"))
        {
          if(!currPlaying.equals("predSame"))
          {
            aplayer.close();
            aplayer = minim.loadFile("Assets/audio/prediction_same_first.wav", 2048);
            aplayer.play();
            currPlaying = "predSame";
            logger.logging(2,new String[]{"Both"});
          }
          
          textengine.changeText(24);
        }
        
        uiengine.switchOn(new int[]{4,6});
        //shakeButton.setVisible(true);
        //shakeButtonProj.setVisible(true);
      }
      
      
      break;
      
      case SHAKING:
      drawContours();
      //exit shaking state after something falls or after some number of seconds
      checkRelayStatus();
      handsOffTimeout = System.currentTimeMillis() + 40000;
              
      //should not happen! should go to diff landing
      if(shakingTimeout < System.currentTimeMillis())
      {
        println("neither tower fell");
        relayOff();
        ms = MainGameState.REASON_PREDICTION;
        fallen = "same";
        break;
      }
      
      if(IndexArray.size() < 2 || towerIndex.size() < 2)
      {
        relayOff();
        ms = MainGameState.REASON_PREDICTION;
        fallen = currentScenario.expectedResult;
        output.println("Time at tower fall: " + minute() + ":"+ second());
        logger.logging(0,new String[]{"Time at tower fall: " + minute() + ":"+ second()});
        break;
      }
      
      float centXL = bd.getBoxCentX(IndexArray.get(0));
      float centXR = bd.getBoxCentX(IndexArray.get(1)); 
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
              
      leftFallingHeight = towerFallingHeight(bd,towerIndex.get(leftInd),leftHeight);
      leftFallingAngle = towerFallingAngle(bd,towerIndex.get(leftInd),leftAngle,leftDensity);
       
//      leftFallingAngle2 = "Standing";
//      leftFallingDensity = "Standing";
         
      leftFalling = towerFallingFinalDecision(leftFallingHeight, leftFallingAngle);
            
      println("Left: " + leftFalling);
      println("LH: " + leftHeight);
      println("left curr: " + bd.getBlobHeight(towerIndex.get(leftInd)));
      debugScreen.text(leftFalling,bd.getA()[towerIndex.get(leftInd)].x-50,40);
      
      rightFallingHeight = towerFallingHeight(bd,towerIndex.get(rightInd),rightHeight);
      rightFallingAngle = towerFallingAngle(bd,towerIndex.get(rightInd),rightAngle,rightDensity);
      
//      rightFallingAngle2 = "Standing";
//      rightFallingDensity = "Standing";
      
      rightFalling = towerFallingFinalDecision(rightFallingHeight, rightFallingAngle);
      
      println("Right: " + rightFalling);
      println("RH: " + rightHeight);
      println("right curr: " + bd.getBlobHeight(towerIndex.get(rightInd)));
      debugScreen.text(rightFalling,bd.getA()[towerIndex.get(rightInd)].x,40);
      if (leftFalling == "Fallen" || rightFalling == "Fallen")
      {
        relayOff();
        ms = MainGameState.REASON_PREDICTION;
        if(leftFalling == "Fallen" && rightFalling == "Fallen")
          fallen = currentScenario.expectedResult;
        
        if(leftFalling == "Fallen")
          fallen = "left";
        
        else
          fallen = "right";//no scenario where towers fall at the same time, if they do, assume right fell first
      }
            
      
      break;
      
      case REASON_PREDICTION:
      drawContours();
      //backButton.setVisible(false);
      //backButtonProj.setVisible(false);
      if(!fallen.equals(currentScenario.expectedResult))
      {
        //The wrong tower fell! Go to a something went wrong state
        ms = MainGameState.UNEXPECTED_OUTCOME;
        
        uiengine.switchOn(new int[]{3,6});
       // continueButton.setVisible(true); 
       // continueButtonProj.setVisible(true);     
        output.println(" The wrong tower fell");
        logger.logging(0,new String[]{"The wrong tower fell"});
        return;
      }
            
      if(fallen.equals("left") && guess.equals("left"))
      {
        if(!currPlaying.equals("hypCorrectLeft"))
        {
          aplayer.close();
          aplayer = minim.loadFile("Assets/audio/hypothesis_correct_left.wav", 2048);
          aplayer.play();
          currPlaying = "hypCorrectLeft";
          output.println("The correct tower fell");
          output.println("The prediction is correct");
          logger.logging(0,new String[]{"The correct tower fell"});
          logger.logging(0,new String[]{"The prediction is correct"});
        }
        
        textengine.changeText(9);
      }
      
      else if(fallen.equals("left") && guess.equals("right"))
      {
        if(!currPlaying.equals("hypWrongLeft"))
        {
          aplayer.close();
          aplayer = minim.loadFile("Assets/audio/hypothesis_wrong_left.wav", 2048);
          aplayer.play();
          currPlaying = "hypWrongLeft";
          output.println("The correct tower fell");
          output.println("The prediction is incorrect");
          logger.logging(0,new String[]{"The correct tower fell"});
          logger.logging(0,new String[]{"The prediction is incorrect"});
        }
        
        textengine.changeText(10);
      }
      
      else if(fallen.equals("right") && guess.equals("left"))
      {
        if(!currPlaying.equals("hypWrongRight"))
        {
          aplayer.close();
          aplayer = minim.loadFile("Assets/audio/hypothesis_wrong_right.wav", 2048);
          aplayer.play();
          currPlaying = "hypWrongRight";
          output.println("The correct tower fell");
          output.println("The prediction is incorrect");
          logger.logging(0,new String[]{"The correct tower fell"});
          logger.logging(0,new String[]{"The prediction is incorrect"});
        }
        
        textengine.changeText(12);
      }
      
      else if(fallen.equals("right") && guess.equals("right"))
      {
        if(!currPlaying.equals("hypCorrectRight"))
        {
          aplayer.close();
          aplayer = minim.loadFile("Assets/audio/hypothesis_correct_right.wav", 2048);
          aplayer.play();
          currPlaying = "hypCorrectRight";
          output.println("The correct tower fell");
          output.println("The prediction is correct");
          logger.logging(0,new String[]{"The correct tower fell"});
          logger.logging(0,new String[]{"The prediction is correct"});
        }
        
        textengine.changeText(11);
      }
      
      else
      {
        //never have result where both fall at same time(code prefers left if they do)
        if(fallen.equals("right"))
        {
          textengine.changeText(12);
          if(!currPlaying.equals("guessSameRightFell"))
          {
            aplayer.close();
            aplayer = minim.loadFile("Assets/audio/hypothesis_wrong_right.wav", 2048);
            aplayer.play();
            currPlaying = "guessSameRightFell";
            output.println("The correct tower fell");
            output.println("The prediction is incorrect");
            logger.logging(0,new String[]{"The correct tower fell"});
            logger.logging(0,new String[]{"The prediction is incorrect"});
          }
        }
        
        else
        {
          textengine.changeText(10);
          if(!currPlaying.equals("guessSameLeftFell"))
          {
            aplayer.close();
            aplayer = minim.loadFile("Assets/audio/hypothesis_wrong_left.wav", 2048);
            aplayer.play();
            currPlaying = "guessSameLeftFell";
            output.println("The correct tower fell");
            output.println("The prediction is incorrect");
            logger.logging(0,new String[]{"Correct reason: " + "The tower has a thinner base"});
            logger.logging(0,new String[]{"The reason predicted is correct"});
          }
        }
      }
              
      //display guess buttons
      
      uiengine.switchOn(new int[]{18,19,20,21});
     
            
      break;
      
      
      case REASON:
     
      
      uiengine.switchOn(new int[]{3,6});
      
      if(guessedReason.equals(reason))
      {
        if(reason.equals("thinner"))
        {
          if(!currPlaying.equals("explCorrectThinner"))
          {
            aplayer.close();
            aplayer = minim.loadFile("Assets/audio/expl_correct_thinner.wav", 2048);
            aplayer.play();
            currPlaying = "explCorrectThinner";
            output.println("Correct reason: " + "The tower has a thinner base");
            output.println("The reason predicted is correct");
            logger.logging(0,new String[]{"Correct reason: " + "The tower has a thinner base"});
            logger.logging(0,new String[]{"The reason predicted is correct"});

          }
          
          textengine.changeText(17);
        }
        else if(reason.equals("taller"))
        {
          if(!currPlaying.equals("explCorrectTaller"))
          {
            aplayer.close();
            aplayer = minim.loadFile("Assets/audio/expl_correct_taller.wav", 2048);
            aplayer.play();
            currPlaying = "explCorrectTaller";
            output.println("Correct reason: " + "The tower is tall");
            output.println("The reason predicted is correct");
            logger.logging(0,new String[]{"Correct reason: " + "The tower is tall"});
            logger.logging(0,new String[]{"The reason predicted is correct"});
          }
          
          textengine.changeText(15);
        }
        
        else if(reason.equals("weight"))
        {
          if(!currPlaying.equals("explCorrectWeight"))
          {
            aplayer.close();
            aplayer = minim.loadFile("Assets/audio/expl_correct_weight.wav", 2048);
            aplayer.play();
            currPlaying = "explCorrectWeight";
            output.println("Correct reason: Tower has too much weight at the top");
            output.println("The reason predicted is correct");
            logger.logging(0,new String[]{"Correct reason: Tower has too much weight at the top"});
            logger.logging(0,new String[]{"The reason predicted is correct"});
          }
          
          textengine.changeText(19);
        }
        
        else if(reason.equals("symmetry"))
        {
          if(!currPlaying.equals("explCorrectSymm"))
          {
            aplayer.close();
            aplayer = minim.loadFile("Assets/audio/expl_correct_symm.wav", 2048);
            aplayer.play();
            currPlaying = "explCorrectSymm";
            output.println("Correct reason: Tower is unsymmetric");
            output.println("The reason predicted is correct");
            logger.logging(0,new String[]{"Correct reason: Tower is unsymmetric"});
            logger.logging(0,new String[]{"The reason predicted is correct"});
          }
          
          textengine.changeText(13);
        }
        
        else
        println(reason);
      }
      
      else
      {
        if(reason.equals("thinner"))
        {
          if(!currPlaying.equals("explWrongThinner"))
          {
            aplayer.close();
            aplayer = minim.loadFile("Assets/audio/expl_wrong_thinner.wav", 2048);
            aplayer.play();
            currPlaying = "explWrongThinner";
            output.println("Correct reason: " + "The tower has a thinner base");
            output.println("The reason predicted is incorrect");
            logger.logging(0,new String[]{"Correct reason: The tower has a thinner base"});
            logger.logging(0,new String[]{"The reason predicted is incorrect"});
          }
          
         textengine.changeText(18);
        }
        
        else if(reason.equals("taller"))
        {
          if(!currPlaying.equals("explWrongTaller"))
          {
            aplayer.close();
            aplayer = minim.loadFile("Assets/audio/expl_wrong_taller.wav", 2048);
            aplayer.play();
            currPlaying = "explWrongTaller";
            output.println("Correct reason: The tower is tall");
            output.println("The reason predicted is incorrect");
            logger.logging(0,new String[]{"Correct reason: The tower is tall"});
            logger.logging(0,new String[]{"The reason predicted is incorrect"});
          }
          
          textengine.changeText(16);
        }
        
        else if(reason.equals("weight"))
        {
          if(!currPlaying.equals("explWrongWeight"))
          {
            aplayer.close();
            aplayer = minim.loadFile("Assets/audio/expl_wrong_weight.wav", 2048);
            aplayer.play();
            currPlaying = "explWrongWeight";
            output.println("Correct reason: Tower has too much weight on the top");
            output.println("The reason predicted is incorrect");
            logger.logging(0,new String[]{"Correct reason: Tower has too much weight on the top"});
            logger.logging(0,new String[]{"The reason predicted is incorrect"});
          }
          
          textengine.changeText(20);
        }
        
        else if(reason.equals("symmetry"))
        {
          if(!currPlaying.equals("explWrongSymm"))
          {
            aplayer.close();
            aplayer = minim.loadFile("Assets/audio/expl_wrong_symm.wav", 2048);
            aplayer.play();
            currPlaying = "explWrongSymm";
            output.println("Correct reason: Tower is unsymmetric");
            output.println("The reason predicted is incorrect");
            logger.logging(0,new String[]{"Correct reason: Tower is unsymmetric"});
            logger.logging(0,new String[]{"The reason predicted is incorrect"});
          }
          
          textengine.changeText(14);
        }
      }
      
      String myReason = "expl_" + reason;
      towerengine.phase[0] = myReason;
      towerengine.phase[1] = myReason;
      
      break;
              
      
      case RESET:
      
      towerengine.on = false;
      wrongCounter = 0;
      rCounterFlag = 0;
      lCounterFlag = 0;
      if(!currPlaying.equals("clearTable"))
      {
        aplayer.close();
        aplayer = minim.loadFile("Assets/audio/clear_table.wav", 2048);
        aplayer.play();
        currPlaying = "clearTable";
        output.println(" ");
        output.println("New Scenario started @ Time: " + minute() + ":"+ second() );
        logger.logging(0,new String[]{" "});
        logger.logging(0,new String[]{"New Scenario started @ Time: " + minute() + ":"+ second() });
      }
      
      leftTower.clear();
      leftTower.add("notPlaced");
      leftTower.add("notPlaced");
      leftTower.add("notPlaced");
      rightTower.clear();
      rightTower.add("notPlaced");
      rightTower.add("notPlaced");
      rightTower.add("notPlaced");
      
      textengine.changeText(7);
      
      
      if(towers.size() == 0)
      {
        handsOffTimeout = System.currentTimeMillis() + 40000;
        currentScenarioIndex = (currentScenarioIndex+1)%scenarioList.length;
        //if(transitionCounter >= 3)
        //for reporter version
        if(transitionCounter >= 2)
        {
          ms = MainGameState.TRANSITION;
          uiengine.switchOn(new int[]{2,28});
          transitionCounter = 0;
        }
        
        else
        {
          ms = MainGameState.PLACING_TOWERS;
          transitionCounter++;
        }
      }
      
      //reset to new tower setup...
      break;
      
      
      case UNEXPECTED_OUTCOME:
      
      if(!currPlaying.equals("unexpected"))
      {
        aplayer.close();
        aplayer = minim.loadFile("Assets/audio/unexpected.wav", 2048);
        aplayer.play();
        currPlaying = "unexpected";
        output.println("Something unexpected happened");
        logger.logging(0,new String[]{"Something unexpected happened"});
      }
      
      textengine.changeText(34);
      uiengine.switchOn(new int[]{3,6});
      
     // image(txtUnexpectedOutcome, touchText.x, touchText.y);
     // g.removeCache(txtUnexpectedOutcome);
      // PImage howToPlaceResized = howToPlace.get();
      // howToPlaceResized.resize((int)(width*.5), 0);
      // image(howToPlaceResized, unexpectedImg.x, unexpectedImg.y - howToPlaceResized.height);
     // image(howToPlaceResizedDummyTab, unexpectedImg.x, unexpectedImg.y - howToPlaceResizedDummyTab.height);
      //g.removeCache(howToPlaceResizedDummyTab);
      break;
      
      
      case TRANSITION:
      
      if(!currPlaying.equals("transition"))
      {
        aplayer.close();
        aplayer = minim.loadFile("Assets/audio/transition_totestmytower.wav", 2048);
        aplayer.play();
        currPlaying = "transition";
      }
      textengine.changeText(-1);
     // image(txtTransition, touchText.x, touchText.y);
     // g.removeCache(txtTransition);
      break;
    }
    
    break;
  }
  
  
}


public void drawContours()
{
  
  drawCon();
}


//mouseClicked() is called after draw(), it is not an interrupt.
public void mouseClicked()
{

  //not checking for correctness of tower since that is done in the main game loop
  if(ms == MainGameState.FALL_PREDICTION && guessed == false)
  {
    //int blobNum = bd.getBlobNumberAt((int)(((mouseX) *680/projectorWidth/0.8) - blobLocation.x), (int)(((mouseY)*480/projectorHeight/0.9) - blobLocation.y));
    println("clicking a blob");
    //left tower
    if(mouseX > 250 && mouseX < 470 && mouseY > 250 && mouseY < 430)
    {
     // guessed = true; 
     // guess = "left";
      predictTower1Click(null,null);
    }
    
    else if(mouseX > 570 && mouseX < 730 && mouseY > 250 && mouseY < 430)
    {
     // guessed = true; 
     // guess = "right";
      predictTower2Click(null,null);
    }
  }
}


void drawCon()
{
  image(pgKinectTablet,0,0);
}
 
ArrayList<Contour> getContours()
{
   //Find all contours in input image
  
    
   ArrayList<Contour> towerContours = opencv.findContours();
   ArrayList<Contour> filteredContours = new ArrayList<Contour>();
   //translate(-780,0);
  
   //Filter contours to only lego towers
   for (Contour contour: towerContours)
   {
     if(contour.area() > HarryGlobal.minimumBlobSize)//used to be 1500
     {
       filteredContours.add(contour);
     }
   }
   //translate(780,0);
  
   return filteredContours;
}

public void GameUnAttended(){
  int t = bd.getBlobsNumber();
  if( t != oldNumBlobs){
    oldNumBlobs = t;
    gameTimeout = System.currentTimeMillis() + 120000;
  }
  if(System.currentTimeMillis() > gameTimeout){
    backButtonClick(null,null);
    oldNumBlobs = -1;
  }
}

public void freezeTouch(int len){
  untouchable = true;
  Timer timer = new Timer();
  timer.schedule(new TimerTask(){
    public void run(){
      untouchable = false;
    }
  },len);  
}

