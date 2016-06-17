/*
 * The Scenario class defines tower pairs for the main game. The class contains 4 fields: reason, tower1, tower2, and expeectedResult
 * The reason is why the correct tower falls. The current reasons are "weight"(more weight on top than bottom), "thinner"(the bass is thinner),
 * "symmetry"(the tower is not symmetrical), and "taller"(the tower is taller). Tower1 is the left tower, and tower2 is the right tower. 
 * The expectedResult is the tower that is supposed to fall(either "left" or "right"). 
 *
 *listOfScenarios() returns a Scenario array. This array can be shuffled using shuffleArray(). The shuffle array code is 
 * from http://stackoverflow.com/questions/1519736/random-shuffling-of-an-array and is an implementation of the 
 * Fisher-Yates shuffle(https://en.wikipedia.org/wiki/Fisher%E2%80%93Yates_shuffle)
 */

import java.util.Random;

public class Scenario
{
  public String reason, tower1, tower2, expectedResult;
  
  public Scenario(String r, String t1, String t2, String e)
  {
     reason = r;
     tower1 = t1;
     tower2 = t2;
     expectedResult = e;
  } 
}


public Scenario[] listOfScenarios()
{
  Scenario s0 = new Scenario("weight", "A1", "A2", "left");
  //B2 Upside Down
  Scenario s1 = new Scenario("weight", "E2", "A2", "left");
  Scenario s2 = new Scenario("thinner", "B2", "B1", "right");
  Scenario s3 = new Scenario("thinner", "B4", "B3", "right");
  Scenario s4 = new Scenario("symmetry", "C1", "C2", "left");
  //D1 upside down
 // Scenario s5 = new Scenario("taller", "E1", "C2", "left");
  Scenario s6 = new Scenario("thinner", "D1", "D2", "right");
  Scenario s7 = new Scenario("taller", "D2", "D3", "left");
  Scenario s8 = new Scenario("symmetry", "D3", "D4", "right");
  
  Scenario[] s =  new Scenario[]{s0, s1, s2, s3, s4, s6, s7, s8};
  //Scenario[] s = new Scenario[]{s0};
  ShuffleArray(s);
  return s;
}

//http://stackoverflow.com/questions/1519736/random-shuffling-of-an-array
private void ShuffleArray(Scenario[] array)
{
    println("shuffling array");
    int index;
    Scenario temp;
    Random random = new Random();
    for (int i = array.length - 1; i > 0; i--)
    {
        index = random.nextInt(i + 1);
        temp = array[index];
        array[index] = array[i];
        array[i] = temp;
    }
}