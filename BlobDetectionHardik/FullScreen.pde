/*
 * This file is used to launch the main processing window to a specific display(indicated by the --display flag) and as a full screen window.
 * This important for making both frames full screen and for placing them on separate screens when we export our application.
 *
 * IMPORTANT: The location of our data changes when we do this! Instead of using the sketches data folder, instead 
 * "C:\Users\NorillaPC\Desktop\processing-2.2.1\data" is used. This should also apply for when the application is exported.
 */

static final void
main(String[] args){
  String sketch = Thread.currentThread()
    .getStackTrace()[1].getClassName();
    
 System.out.println(System.getProperty("user.dir"));
 
  main(sketch, args
    , "--full-screen"
    , "--hide-stop"
    , "--bgcolor=#000000"
    , "--stop-color=#000000"
    , "--display=1"
    );
    
}



 
static final void
main(String name, String[] oldArgs, String... newArgs) {
  runSketch(concat(append(newArgs, name), oldArgs), null);
}
