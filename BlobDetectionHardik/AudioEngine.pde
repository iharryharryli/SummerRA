public class AudioEngine{
  HashMap search;
  
 
  
  
  int lastPlayed = -1;
  
  
  AudioPlayer player;
  
  public  AudioEngine(){
    search = new HashMap();
  } 
  
  public void addToEngine(Object[] stuff){
    for(int i=0; i<stuff.length; i+=2){
      Integer ID = (Integer)stuff[i];
      String file = (String)stuff[i+1];
      search.put(ID,file);
    }
  }
  
  
  
 
  
  public void play(int i){
    
            String file = (String)search.get(i);
            
            player = null;
            
            player = minim.loadFile(file, 2048);
            
            player.play();
  }
  
  public void playOnce(int i){
    if(lastPlayed == i){
      return;
    }
    lastPlayed = i;
    play(i);
  }
  
  public void shutUp(){
    if(player!=null)player.pause();
  }
  
  public void cleanUp(){
    shutUp();
    if(player!=null){
        player.close();
        player = null;
    }
    lastPlayed = -1; 
  }
  
  public boolean isPlaying(){
    if(player == null)return false;
    return player.isPlaying();
  }
}

public void setupAudio(){
   AudioEngine e = new AudioEngine();
   e.addToEngine(new Object[]{
           0,"Assets/audio/clear_table.wav",
           1,"Assets/audio/testmytower_prompt.wav",
           2,"Assets/audio/testmytower_toomanytowers.wav",
           3,"Assets/audio/testmytower_standing.wav",
           4,"Assets/audio/testmytower_fell.wav",
//           2,"Assets/audio/testmytower_prompt.wav",
           
   });
   HarryGlobal.audioEngine = e;
}


