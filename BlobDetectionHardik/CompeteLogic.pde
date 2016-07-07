public class SideController{
  SideCondition[] sides;
  int boundary;
  public SideController(int b){
    boundary = b;
    sides = new SideCondition[]{new SideCondition(),new SideCondition()};
  }
}

public class SideCondition{
  int tower_num = 0;
  int targetTower = -1;
}
