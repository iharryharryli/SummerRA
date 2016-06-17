


// Start  of program 
SimpleOpenNI context;


PImage srcImage;
// Below two lines are for blobscanner
Detector bd;
float[] NtowersX,NtowersY;
String[] NtowerNames;
int minimumWeight = 2000;
////////////// Gaming  Variables
int leftHeight, rightHeight;
float leftAngle1, rightAngle1;
float leftAngle2, rightAngle2;
float leftDensity, rightDensity;

String leftFallingHeight = "Standing";
String leftFallingAngle1 = "Standing";
String leftFallingAngle2 = "Standing";
String leftFallingDensity = "Standing";


String rightFallingHeight = "Standing";
String rightFallingAngle1 = "Standing";
String rightFallingAngle2 = "Standing";
String rightFallingDensity = "Standing";

String leftFalling = "Standing";
String rightFalling = "Standing";

float blobArea = 0;

//////////////////////////////

// Variables for Serial Communication
Serial myPort ; // variable for serial communication
String carriage = "\r";
String startRelay = "relay on 0\r";
String stopRelay = "relay off 0\r";
String relayStatus = "relay read 0";
///////////////////////////////
//FloatList lookupXMoment,lookupYMoment,absvalue,lookupYMomentBottom,lookupYMomentTop,lookupXMoment_3D;// variables for tower Indentification
FloatList lookupYMomentBottom,lookupYMomentTop,lookupXMoment_3D;// variables for tower Indentification


//IntList blobArray,IndexArray;
 IntList IndexArray;
 // Below Function checks whether the kinect is connected or not and IF yes then It enables all the streams of Kinect to work i.e RGB , Depth etc.
 

 
 void setKinectElementsHardik() 
{
  
  
  context = new SimpleOpenNI(this);
  if(context.isInit() == false)
  {
     println("Can't init SimpleOpenNI, maybe the camera is not connected!"); 
     exit();
     return;  
  }
  //Enable all kinect cameras/sensors
  context.enableDepth();
  context.enableUser();// for generating skeleton/joints (May not be required in our project)
  context.enableRGB();
  //Calibrate depth and rgb cameras
  context.alternativeViewPointDepthToImage();// What does this command do ?
  
}


// Setup function is the first function called whenever u run a file in a folder
void setupHardik()
{
  
  setKinectElementsHardik();// Check if the Kinect is connected or not 
 
 // This function sets up the parameters for the Relay and makes sure that the relay is connected !!!
 
  relaySetup();
  
  // Initialize the Kinect Image 
  srcImage = context.depthImage();
  opencv = new OpenCV(this, srcImage);

 
bd = new Detector( this, 255 );// Initial value was 255

////// Game variable

leftHeight = 1;
rightHeight = 1;
////////////////
}
