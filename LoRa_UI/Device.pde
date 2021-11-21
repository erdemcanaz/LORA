class Device {
  int index_of_this_object;
  String ID;
  String DEVICE_NAME;
  String tag="";
  int last_update_LoRa[] = new int[3]; //hour, minute, seconds
  boolean needUpdate= false;
  boolean isActive = false;
  boolean isVisible = false;
  boolean isDeviceAvailable = true;

  long update_rate = 40;
  long last_communication_unix=0;
  long last_update_unix = 0;

  String texts[] = {"-", "-", "-", "-", "-", "-"};
  float floats[]={0, 0, 0};
  boolean booleans[]={false, false, false};
  //long unixTime = System.currentTimeMillis() / 1000L;

  String deviceTexts[][] =
  {
  {"hava sensörleri","Sıcaklık (C)", "Nem (%)", "Işık (Lux)"," "," "," "},
  {"mesafe","Mesafe (cm)"," "," "," "," "," "},
  {"röle"," "," "," ","Röle"," "," "},
  {"GPS","Enlem","Boylam"," "," "," "," "},
  {"Rüzgar Hızı","Hız(m/s)"," "," "," "," "," "},
  {"CO2","CO2 (ppm)"," "," "," "," "," "},
  {"pH","Asitlik (pH)"," "," "," "," "," "},
  {"EC","EC (ppm)"," "," "," "," "," "},
  {"kütle","Kütle (kg)"," "," "," "," "," "},
  {"hareket sensörü","Son hareketten beri (s)"," "," "," "," "," "},
  {"tarım sensörleri","Toprak nem (%)","Hava nem(%)","Hava sıcaklık(%)"," "," "," "},
  {"dijital","In0","In1","In2","Out3","Out4","Out5"},
  };

  public  Device(String ID, String DEVICE_NAME, int index_of_this_object) {
    this.index_of_this_object = index_of_this_object;
    this.ID = ID;
    this.DEVICE_NAME= DEVICE_NAME;
    last_communication_unix = System.currentTimeMillis() /1000L;//the last data received or when it is generated as a device
    last_update_unix = System.currentTimeMillis() /1000L; //the last time its questions are added to que

    for(int i=0;i<6;i++)texts[i] = "item"+String.valueOf(i);

    for(int i = 0 ; i<deviceTexts.length; i++){
        if(deviceTexts[i][0].equals(DEVICE_NAME)){
          for(int j = 1; j<deviceTexts[i].length;j++){
              texts[j-1]=deviceTexts[i][j];
          }
          break;
        }
    }
  }

  /////////////////
  private int drawDevice(int y_last, int counter) {

    long since_last_update = System.currentTimeMillis() /1000L -last_update_unix ;
    if ( !(update_rate-since_last_update>0))needUpdate = true;
    else needUpdate = false;

    // 50<= y <= 1000
    int shift = 46;
    if (isVisible)shift = 256;

    int start_y= y_last+10;
    int end_y = start_y+ shift;

    if (start_y>1000 || end_y<0)return (y_last+shift);
    //
    image(img[1], 50, start_y);
    //DEVICE_MENU TEXTS
    textSize(25);
    fill(0, 162, 232);
    text(counter, 140, start_y+25);
    text(ID, 265, start_y+25);
    text(DEVICE_NAME, 495, start_y+25);

    if (!isActive)fill(255, 0, 0);
    else {
      if (isDeviceAvailable)fill(0, 255, 0);
      else fill(255, 255, 0);
    }
    text(f.secToHour(last_communication_unix), 820, start_y+25);
    //DEVICE SUB MENU TEXTS
    if (isVisible) {
      fill(0, 162, 232);
      image(img[2], 50, start_y+46);
      textSize(20);
      text(tag, 165, start_y+70);
      text(String.valueOf(update_rate), 285, start_y+90);
      text(f.secToHour(last_update_unix), 242, start_y+170);

      since_last_update = System.currentTimeMillis() /1000L -last_update_unix ;
      if (update_rate-since_last_update>0 && !needUpdate)text(String.valueOf(update_rate-since_last_update), 300, start_y+192);
      else if(!isActive)text(0, 300, start_y+192);
      else {
        text("güncelleme bekleniyor", 300, start_y+192);
      }

      fill(0);
      text(texts[0], 532, start_y+92);
      text(texts[1], 674, start_y+92);
      text(texts[2], 805, start_y+92);
      text(texts[3], 532, start_y+182);
      text(texts[4], 674, start_y+182);
      text(texts[5], 805, start_y+182);
      fill(255);
      text(floats[0], 532, start_y+122);
      text(floats[1], 674, start_y+122);
      text(floats[2], 805, start_y+122);
      text(String.valueOf(booleans[0]), 532, start_y+212);
      text(String.valueOf(booleans[1]), 674, start_y+212);
      text(String.valueOf(booleans[2]), 805, start_y+212);
    }
    return (y_last+shift);
  }

  private int SHIFT() {
    int shift = 46;
    if (isVisible)shift = 256;
    return shift;
  }

  private boolean mouseAction(int x, int y) {
    //if true, erase this object,
    //println(x, y);

    if (f.isIn(x, y, 50, 10, 30, 30))return true;
    else if (f.isIn(x, y, 80, 10, 690, 30))isVisible = !isVisible;
    else if (f.isIn(x, y, 780, 10, 170, 30))isActive = !isActive;
    else if (f.isIn(x, y, 108, 105, 72, 22)) update_rate = 5;
    else if (f.isIn(x, y, 187, 105, 72, 22)) update_rate = 20;
    else if (f.isIn(x, y, 266, 105, 72, 22)) update_rate = 40;
    else if (f.isIn(x, y, 345, 105, 72, 22)) update_rate = 60;
    else if (f.isIn(x, y, 425, 105, 72, 22)) update_rate = 180;

    else if (f.isIn(x, y, 108, 133, 72, 22)) update_rate = 300;
    else if (f.isIn(x, y, 187, 133, 72, 22)) update_rate = 600;
    else if (f.isIn(x, y, 266, 133, 72, 22)) update_rate = 1800;
    else if (f.isIn(x, y, 345, 133, 72, 22)) update_rate = 3600;
    else if (f.isIn(x, y, 425, 133, 72, 22)) update_rate = 10800;

    else if (f.isIn(x, y, 210, 210, 180, 40)) {       
      needUpdate=true;
      if(!isActive)return true;
      refreshQue();
      indexNow = index_of_this_object;
      
    } else if (f.isIn(x, y, 633, 165, 30, 30))booleans[0] = ! booleans[0];
    else if (f.isIn(x, y, 770, 165, 30, 30))booleans[1] = ! booleans[1];
    else if (f.isIn(x, y, 910, 165, 30, 30))booleans[2] = ! booleans[2];
    return false;
  }

  private boolean keyAction(char c, int x, int y) {
    if (f.isIn(x, y, 160, 60, 330, 20)) { //ID
      tag= f.addChar(tag, c, false);
      return true;
    }
    return false;
  }
  //------
   //UPDATES///////
  void updated() {
    last_update_unix = System.currentTimeMillis() /1000L;
    needUpdate=false;
  }

  void analzeThisReply(long SENDER_ID, long DESTINATION_ID,long TASK, long WHICH_ITEM, float FLOAT_VALUE ){
    if(SENDER_ID != Long.valueOf(ID))return;
    //println("reply",SENDER_ID,DESTINATION_ID,TASK,WHICH_ITEM, FLOAT_VALUE);
    if(TASK==0)return;
    else if(TASK==1)return;
    else if(TASK==2){//device replies
      last_communication_unix = System.currentTimeMillis() /1000L;
      if(WHICH_ITEM<3)floats[(int)WHICH_ITEM]=FLOAT_VALUE;
      isDeviceAvailable=true;
    }
  }
  String addThisToQue() {
    //[0]:SENDER_ID, [1]:DESTINATION_ID, [2]:TASK 0:set, 1:learn, 2:reply_device, 3:reply_lora, [3]:WHICH_OBJECT, [4+5]: FLOAT
    String rs = "";
    if (DEVICE_NAME.equals("hava sensörleri")) {
      rs+="#0,"+ID+",1,0,0.0$-";//sıcaklığı öğrenmek istiyorum
      rs+="#0,"+ID+",1,1,0.0$-";//nemi öğrenmek istiyorum
      rs+="#0,"+ID+",1,2,0.0$";//ışık şiddetini öğrenmek istiyorum
    } else if (DEVICE_NAME.equals("mesafe")) {
      rs+="#0,"+ID+",1,0,0.0$";//mesafeyi öğrenmek istiyorum
    } else if (DEVICE_NAME.equals("röle")) {
      String b0="";
      if (booleans[0]==true)b0="1.0";
      else b0="0.0";
      rs+="#0,"+ID+",0,3,"+b0 +"$";//röleyi açıyor veya kapıyorum
    } else if (DEVICE_NAME.equals("GPS")) {
      rs+="#0,"+ID+",1,0,0.0$-";//enlemi öğrenmek istiyorum
      rs+="#0,"+ID+",1,1,0.0$";//boylamı öğrenmek istiyorum
    } else if (DEVICE_NAME.equals("rüzgar hızı")) {
      rs+="#0,"+ID+",1,0,0.0$";//Rüzgar hızını öğrenmek istiyorum
    } else if (DEVICE_NAME.equals("CO2")) {
      rs+="#0,"+ID+",1,0,0.0$";//CO2 derişimini öğrenmek istiyorum
    } else if (DEVICE_NAME.equals("pH") ) {
      rs+="#0,"+ID+",1,0,0.0$";//pH değerini öğrenmek istiyorum
    } else if (DEVICE_NAME.equals("EC") ) {
      rs+="#0,"+ID+",1,0,0.0$";//EC değerini öğrenmek istiyorum
    } else if (DEVICE_NAME.equals("kütle")) {
      rs+="#0,"+ID+",1,0,0.0$";//kütleyi öğrenmek istiyorum
    } else if (DEVICE_NAME.equals("hareket sensörü")) {
      rs+="#0,"+ID+",1,0,0.0$";//son hareketten beri geçen saniyeyi öğrenmek istiyorum
    } else if (DEVICE_NAME.equals("tarım sensörleri")) {
      rs+="#0,"+ID+",1,0,0.0$-";//Toprak nemini öğrenmek istiyorum
      rs+="#0,"+ID+",1,1,0.0$-";//hava nemini öğrenmek istiyorum
      rs+="#0,"+ID+",1,2,0.0$";//hava sıcaklığını öğrenmek istiyorum
    } else if (DEVICE_NAME.equals("dijital")) {
      rs+="#0,"+ID+",1,0,0.0$-";//In0'yu öğrenmek istiyorum
      rs+="#0,"+ID+",1,1,0.0$-";//In1'i öğrenmek istiyorum
      rs+="#0,"+ID+",1,2,0.0$-";//In2'yi öğrenmek istiyorum

      String b[] = new String[3];
      if (booleans[0])b[0]="1.0";
      else b[0]="0.0";
      if (booleans[1])b[1]="1.0";
      else b[1]="0.0";
      if (booleans[2])b[2]="1.0";
      else b[2]="0.0";
      rs+="#0,"+ID+",0,3,"+b[0]+"$-";//OUT3'ü set etmek istiyorum
      rs+="#0,"+ID+",0,4,"+b[1]+"$-";//OUT4'ü set etmek istiyorum
      rs+="#0,"+ID+",0,5,"+b[2]+"$";//OUT5'i set etmek istiyorum
    } else {
      rs+="#0,"+ID+",1,0,0.0$-";//item0'yu öğrenmek istiyorum
      rs+="#0,"+ID+",1,1,0.0$-";//item1'i öğrenmek istiyorum
      rs+="#0,"+ID+",1,2,0.0$-";//item2'yi öğrenmek istiyorum

      String b[] = new String[3];
      if (booleans[0])b[0]="1.0";
      else b[0]="0.0";
      if (booleans[1])b[1]="1.0";
      else b[1]="0.0";
      if (booleans[2])b[2]="1.0";
      else b[2]="0.0";
      rs+="#0,"+ID+",0,3,"+b[0]+"$-";//item3'ü set etmek istiyorum
      rs+="#0,"+ID+",0,4,"+b[1]+"$-";//item4'ü set etmek istiyorum
      rs+="#0,"+ID+",0,5,"+b[2]+"$";//item5'i set etmek istiyorum
    }
    return rs;
  }




}
