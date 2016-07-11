
// This function cleans up the Kinect Data ( removes pixels that are outside the table, applies blurring for smooth contours and finally does thresholding to 0 and 1 so that we can run 
// Blob detection algorithm( BlobScanner lib)

void Image_filtering()
{
  context.update();
  CleanKinectData();// cleans the kinect data based on the hard-coded values inserted by us based on the location of the Kinect and the towers
  //srcImage = context.depthImage();
  
  // Now the stream that was cleaned is stored into an Image format
  PImage Image = (context.depthImage()); // Assign the Variable srcImage the depthMap from the camera
  Image = Image.get();
  // Image processing
  Image.filter(BLUR,3);// Blurring
  
  // BlurringFilter(Image);
  Image.filter(THRESHOLD);// This needs to be done for blob detection very important 
   opencv.loadImage(Image);
   opencv.gray();
   opencv.threshold(70); 
   srcImage = Image; 
   debugScreen.setImg(srcImage);
 
   
   HarryGlobal.kinectDrawer.updateCountours();
   
   
   HarryGlobal.kinectDrawDelegate.tablet();
   HarryGlobal.kinectDrawDelegate.projector();
   
  
}

void CleanKinectData()
{
  // 
  int leftThreshold = 80;
  int rightThreshold = 550;
//  int topThreshold = 145;
  int topThreshold = 480 - 95;
  
  int depthMin = 600; // This figure defines the mininum depth at which the kinect should look for objects. 
  //i.e this value will change if the table if moved w.r.t to the Kinect mounting position
  int depthMax = 1000;// This figure defines the max depth after which the kinect doesn't see anything.
  // The above two values need to be fined tuned once we have the right orientation of the Kinect
  int[] inputDepthMap = context.depthMap();
  context.depthImage().loadPixels();
  
  int depthMapSize = context.depthMapSize();
  int depthImgWidth = context.depthWidth();
  int depthImgHeight = depthMapSize / depthImgWidth;

  
  for(int i = 0 ; i < depthImgWidth ; i++){
    for (int j = 0 ; j < depthImgHeight ; j++){
      if (inputDepthMap[i+j*depthImgWidth] == 0){ //Error depth map value 
        context.depthImage().pixels[i+j*depthImgWidth] = color(0,0,0); 
      } else if ((inputDepthMap[i+j*depthImgWidth]< depthMin) || (inputDepthMap[i+j*depthImgWidth] > depthMax)){  //Irrelevant depths
        context.depthImage().pixels[i+j*depthImgWidth] = color(0,0,0);
      } else if (i < leftThreshold || i >= rightThreshold){
        context.depthImage().pixels[i+j*depthImgWidth] = color(0,0,0);
      } else if (j > topThreshold){
        context.depthImage().pixels[i+j*depthImgWidth] = color(0,0,0);
      } 
    }
  }
  
}  

  // New filter for edges and error points
  
void BlurringFilter (PImage MaskImage) 

{
  MaskImage.loadPixels();
  for (int i= 1; i < context.depthWidth()-1;i++ )
  {
    for (int j = 1; j < context.depthHeight()-1; j++)
    {
      int Ncounter = 0;
      if( context.depthImage().pixels[i + j*context.depthWidth()] > 0)
        Ncounter = Ncounter+1;
        
      if( context.depthImage().pixels[ (i+1) +j*context.depthWidth()] > 0)
        Ncounter = Ncounter+1;
        
      if( context.depthImage().pixels[(i-1)+ j*context.depthWidth()] > 0)
        Ncounter = Ncounter+1;
        
      if( context.depthImage().pixels[i+ (j+1)*context.depthWidth()] > 0)
        Ncounter = Ncounter+1;
        
      if( context.depthImage().pixels[i + (j-1)*context.depthWidth()] > 0)
        Ncounter = Ncounter+1;
      
      if( context.depthImage().pixels[ (i+1) + (j-1)*context.depthWidth()] > 0)
        Ncounter = Ncounter+1;
      
      if( context.depthImage().pixels[ (i-1) + (j-1)*context.depthWidth()] > 0)
        Ncounter = Ncounter+1;
        
      if( context.depthImage().pixels[(i+1) + (j+1)*context.depthWidth()] > 0)
        Ncounter = Ncounter+1;
     
      if( context.depthImage().pixels[(i-1) + (j+1)*context.depthWidth()] > 0)
        Ncounter = Ncounter+1;
    
      if(Ncounter < 5)
        MaskImage.pixels[i+j*context.depthWidth()] = color(0,0,0);
     }
   }
 }
