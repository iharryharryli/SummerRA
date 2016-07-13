void keyPressed(){
  if(!COMPETE_MODE_ON)return;
  if(key == 'a'){
    competelogic.startPlaying();
  }
  else if (key == 'b'){
    competelogic.userInput.shake();
  }
}

void mousePressed(){
  println(mouseX + " : " + mouseY);
}
