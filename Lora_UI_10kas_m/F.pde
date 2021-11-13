

class F {
  public F() {
  }

  //GENERAL PURPOSE FUNCTIONS//////////////////////////////
  void clean_values(){
    for(int i=0;i<values.length;i++)values[i]=0;
  }
  String addChar(String s, char c, boolean isNumber) {
    if (Character.isLetter(c) || (c>='0' && c<='9') ||c==' ') {
      if (isNumber && (c>='0' && c<='9')) {
        s+=c;
      } else if (!isNumber) {
        s+=c;
      }
    } else if (c==8) {
      String s_t="";
      for (int i=0; i<s.length()-1; i++) {
        s_t+=s.charAt(i);
      }
      s=s_t;
    }
    return s;
  }

  boolean isIn(int x_test, int y_test, int x_0, int y_0, int w, int h) {
    if ( (x_0<=x_test && x_test <= x_0+w) && (y_0<=y_test && y_test<=y_0+h) ) return true;
    return false;
  }
  String secToHour(long seconds) {
    long SEC =  seconds%(60);
    long MIN =  (seconds%3600)/60;
    long HOUR = (seconds%86400)/3600;
    String rs = "";

    if (HOUR<10)rs+="0";
    rs+=String.valueOf(HOUR)+":";
    if (MIN<10)rs+="0";
    rs+=String.valueOf(MIN)+":";
    if (SEC<10)rs+="0";
    rs+=String.valueOf(SEC);
    return rs;
  }
  

  //DRAW//////////////////////////////////////////////////
  private void cleanBackground() {
    background(255);
  }
  private void drawDevices(int start_y, int del_y) {
    int Y= start_y+del_y;
    for (int i = 0; i<128; i++) {
      if (device_objs[i] != null) {
        Y=device_objs[i].drawDevice(Y, i);
      }
    }
  }
  //DEVICES//////////////////////////////////////////////////
  private void broadcastReplyToAllDevices(long SENDER_ID, long DESTINATION_ID,long TASK, long WHICH_ITEM, float FLOAT_VALUE ){
    for (int i = 0; i<128; i++) {
      if (device_objs[i] != null) {
        device_objs[i].analzeThisReply(SENDER_ID,DESTINATION_ID,TASK,WHICH_ITEM,FLOAT_VALUE);     
      }
    }
  }
  private void addDevice(String ID, String DEVICE_NAME) {
    for (int i = 0; i<128; i++) {
      if (device_objs[i] == null) {
        device_objs[i] = new Device(ID, DEVICE_NAME,i);
        break;
      }
    }
  }

  int[] related_Device(int y_test, int del_y) {
    //index,effective_x, effective Y
    int r[]=new int[3];
    int current_y=50+del_y;
    r[0]=-1;
    for (int i=0; i<128; i++) {
      if (device_objs[i]==null)continue;
      int y_next = current_y+ device_objs[i].SHIFT();
      
      if (current_y<=y_test && y_test <= y_next) {
        r[0]=i;
        r[1]=mouseX;
        r[2]=y_test-current_y;
        return r;
      }

      current_y = y_next;
    }

    return r;
  }
}//
