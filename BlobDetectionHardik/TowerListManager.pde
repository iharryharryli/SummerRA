/*
 * The towerManager() is used to mitigate flickering. In runner.pde, 2 ArrayList<String> are defined, 'leftTower' and 'rightTower'. 
 * The ArrayLists hold a snapshot of the states of the left and right towers for the past 2 frames + the current frame(3 frames total).
 * Tower states are "notPlaced", "correct", "wrong", and "tooMany"(too many towers placed).
 *
 * The oldest data is removed when towerManager() is called. Then the towers current state is added.
 */

public void towerManager()
{
  leftTower.remove(0);
  rightTower.remove(0);
  if(towers.size() == 0)
  {
    leftTower.add("notPlaced");
    rightTower.add("notPlaced");            
  }
  else if(towers.size() == 1)
  {
    float centX = bd.getBoxCentX(towerIndex.get(0));
    
    
    
    if(towers.contains(t[0]) && (centX < kinectCenter) && (centX > leftTowerLeft && centX < leftTowerRight))
    {
      leftTower.add("correct");
    rightTower.add("notPlaced"); 
    }
    else if(towers.contains(t[1]) && (centX > kinectCenter) && (centX > rightTowerLeft && centX < rightTowerRight))
    {
    leftTower.add("notPlaced");
    rightTower.add("correct"); 
    }
    else//decide if a left or right tower is placed
    {  
      //on left side
      if(centX < kinectCenter)
      {
        leftTower.add("wrong");
    rightTower.add("notPlaced"); 
      }
      //on right side
      else
      {
       leftTower.add("notPlaced");
    rightTower.add("wrong"); 
      }
      
    }
  }
  //assuming the two towers are in the correctish locations, in the right order, might need to change if 2 on left side...use contours here?
  else if(towers.size() == 2)
  {
    float left = bd.getBoxCentX(towerIndex.get(0));
    float right = bd.getBoxCentX(towerIndex.get(1));
    float centXL, centXR;
    int leftLocation;
    int rightLocation;
    
    if(left < right)
    {
      centXL = bd.getBoxCentX(towerIndex.get(0));
      centXR = bd.getBoxCentX(towerIndex.get(1));
      leftLocation = 0;
      rightLocation = 1;
    }
    else
    {
      centXL = bd.getBoxCentX(towerIndex.get(1));
      centXR = bd.getBoxCentX(towerIndex.get(0));
      leftLocation = 1;
      rightLocation = 0;
    }
    
    if(towers.get(leftLocation).equals(t[0]) && (centXL > leftTowerLeft && centXL < leftTowerRight))leftTower.add("correct");
    else leftTower.add("wrong");
    
    if(towers.get(rightLocation).equals(t[1]) && (centXR > rightTowerLeft && centXR < rightTowerRight)) rightTower.add("correct");
    else rightTower.add("wrong");
    
   
  }
  else if(towers.size() > 2)
  {
    leftTower.add("tooMany");
    rightTower.add("tooMany"); 
  }          
}
