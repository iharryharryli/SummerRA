
// This function is used to get the all the Blobs in the Image depthImg



Detector getBlobScannerObject (Detector blobObject, PImage depthImg)
{
  
  blobObject.imageFindBlobs(srcImage);
 
blobObject.loadBlobsFeatures();
//Draws the bounding box for all the blobs in the image.

blobObject.weightBlobs(false);// This function is called before anything related to the weight of the blobs needs to be calculated
// pass false in the argument if you do not intend to pint zero blobs found when running some functions
return bd;
}



////////////////////////////////////////////////////////////////////////////////////////
// This function returns the dynamic Array IntList  with number (index) of all the blobs which have a weight greater than the minimum weight 

IntList getNum_getIndex (Detector BlobObject)
{
  
  IntList blobArray = new IntList();
  
  for(int i = 0; i < bd.getBlobsNumber(); i++) 
  {
    if (bd.getBlobWeight(i)>minimumWeight)
    {
      blobArray.append(i);
    }
  }
 
 return blobArray;
}
