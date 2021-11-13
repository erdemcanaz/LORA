class MainMenu {
  String ID="";
  String DEVICE_NAME="";

  public MainMenu() {
  }
  private void drawMenu() {
    image(img[0], 0, 0);
    textSize(25);
    fill(255, 174, 201);
    long unixTime = System.currentTimeMillis() / 1000L;
    text(f.secToHour(unixTime),25,33);
    text(ID, 200, 33);
    text(DEVICE_NAME, 555, 33);   
  }

  private boolean keyAction(char c, int x, int y) {
    if (f.isIn(x, y, 160, 0, 310, 50)) { //ID
      ID= f.addChar(ID, c, true);
      return true;
    } else if (f.isIn(x, y, 470, 0, 350, 50)) { //DEVICE_NAME
      DEVICE_NAME= f.addChar(DEVICE_NAME, c, false);
      return true;
    }
    return false;
  }
  
  private boolean mouseAction(int x, int y){
        if(f.isIn(x,y,825,0,130,50)){
          //
          if(!ID.equals("") && !DEVICE_NAME.equals("")) f.addDevice(ID,DEVICE_NAME);
          ID=""; 
          DEVICE_NAME ="";
          //
          return true;
        }
       return false;
  }
}
