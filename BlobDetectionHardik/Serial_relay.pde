

//////////////////////////////////////////////////
// This function Setups up serial communication for the relay and Checks whether the relay has been connected to the respective device or not 
/*
boolean serialInited;
void relaySetup()
{
  
  initSerial();
}

void initSerial () {
    try {
        myPort = new Serial(this, Serial.list()[0], 9600);
        serialInited = true;
    } catch (RuntimeException e) {
        if (e.getMessage().contains("<init>")) {
            System.out.println("port in use, trying again later...");
            serialInited = false;
        }
    }
}
*/

void relaySetup(){
  
  int len=Serial.list().length; 
  println("number of serial ports available are " + len);
  // Just checking if any port is connected to the PC or not . 
  
 // Assumption here is that only serial port is Relay in case of use of multiple serial communication we would have to see which port to use.
 // By default I am using first port i.e "0"
 // Baud rate selected is 9600 
 
if (len==0){
  println("Relay/Serial Port not connected , please check Relay or USB ");
  exit();
  //image(relayImage,0,0);
 // delay(3000);
  return;
}

myPort = new Serial(this, Serial.list()[0], 9600);
//sendSignalOn = new byte[];
//println(Serial.list()); 
}

/////////////////////////////////////
//This function Starts the relay

void relayOn(){
  
  // always should clear whatever is there in the port Buffer
  println("relayon");
  myPort.clear();
  println("relayclear");
  myPort.write(carriage);// Carriage emulates Enter key.
  println("relayreturn");
  myPort.write(startRelay);
  println("relaystarted");
}

//////////////////////////////////////////////////////

// This function turns off the relay
void relayOff(){
  myPort.clear();
  myPort.write(carriage);
  myPort.write(stopRelay);
}
/*
void checkRelayStatus()
{
  if (serialInited) {
        // serial is up and running
        try {
            String b = myPort.readString();
            println(b);
            // fun with serial here...
        } catch (RuntimeException e) {
            // serial port closed :(
            serialInited = false;
        }
    } else {
        // serial port is not available. bang on it until it is.
        initSerial();
    }
}*/

void checkRelayStatus(){
    myPort.clear();
    myPort.write(carriage);
    myPort.write(relayStatus);
    delay(100);
    String relayOutput = myPort.readString();
   // println(relayOutput);
    if (relayOutput == null){
      println("Problem of null String");
      myPort.clear();
      myPort.stop();
      //myPort = null ;
      delay(300);
      relaySetup();
      relayOff();
    }
    //return returnCommand;
}
