import processing.serial.*;
PImage img[]= new PImage[3];//upper menu-device menu-subdevice menu
Serial myPort;
MainMenu menu = new MainMenu();
Device device_objs[] = new Device[128];
String que[] = new String[128];
F f = new F();

void setup() {
  size(1000, 600);
  frameRate(30);
  img[0] = loadImage("ust menu.png");
  img[1] = loadImage("cihaz menu.png");
  img[2] = loadImage("alt menu.png");
  String portName = Serial.list()[1]; //change the 0 to a 1 or 2 etc. to match your port
  myPort = new Serial(this, portName, 9600);
}

void draw() {
  draws();
  listenSerial();
  askQue();
}
//Updates
long values[] = {0, 0, 0, 0, 0, 0, 0}; // [0]:SENDER_ID, [1]:DESTINATION_ID, [2]:TASK, [3]:WHICH_OBJECT, [4]: FLOAT_INTEGER, [5]:FLOAT_DECIMAL, [6]: counter
boolean isSerialLocked = true;

boolean listenSerial() {
  //#: start $:end ;:other variable .:other variable
  //negative values are omited
  if (!(myPort.available() > 0))return false;
  char c = (char)myPort.read();

  if (isSerialLocked && c != '#') {
    return false;
  } else if (c == '#') {
    f.clean_values();
    isSerialLocked = false;
  } else if (c == '$') {
    int counter = (int)(values[6]);
    if (counter != 5) {
      isSerialLocked = true;
      return false;
    }
    //

    float k = values[5];
    while (k > 1)k = k / 10.0f;
    println("reply", values[0], values[1], values[2], values[3], values[4]+k);
    f.broadcastReplyToAllDevices(values[0], values[1], values[2], values[3], values[4]+k);
    //
    f.clean_values();
    isSerialLocked = true;
    return true;
  } else if (c >= '0' && c <= '9') {
    int counter = (int)values[6];
    values[counter] = values[counter] * 10 + (c - '0');
  } else if (c == ',' || c == '.') {
    values[6] = values[6] + 1;
    if (values[6] == 6) {
      isSerialLocked = true;
    }
  }
  return false;
}

long QUE_DELAY_MS = 8000;
int indexNow=0;
long lastTimeQueAsked = 0;

void askQue() {


  //----
  for (; indexNow<128; indexNow++) {
    if (que[indexNow]==null) {
      refreshQue();
    } else {
      break;
    }
  }
  if (indexNow==128) {
    indexNow=0;
    return;
  }

  ///---
  if (System.currentTimeMillis()-lastTimeQueAsked<QUE_DELAY_MS)return;
  lastTimeQueAsked=System.currentTimeMillis();
  //
  String subQues[]= que[indexNow].split("-");
  String nextQue= "";
  if (subQues.length>1) {
    for (int i=1; i<subQues.length; i++) {
      nextQue+= subQues[i]+"-";
    }
    nextQue.substring(0, nextQue.length() - 2);
  } else {
    device_objs[indexNow].updated();
  }
  println(millis(), "soruldu:", subQues[0]);
  myPort.write(subQues[0]);
  if (nextQue.equals(""))que[indexNow]=null;
  else que[indexNow]=nextQue;
}

void refreshQue() {
  for (int i=0; i<128; i++) {
    if (device_objs[i]==null)continue;
    if (device_objs[i].needUpdate && device_objs[i].isActive) {
      que[i]=device_objs[i].addThisToQue();
    }
  }
}

//
int del_y=0;
void draws() {
  f.cleanBackground();
  f.drawDevices(50, del_y);
  menu.drawMenu();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      del_y +=46;
      if (del_y>0)del_y=0;
    } else if (keyCode == DOWN) {
      del_y -= 46;
    } else if ( keyCode == RIGHT || keyCode == LEFT) {
      del_y = 0;
    }
  }

  if (menu.keyAction(char(key), mouseX, mouseY));
  else if (f.related_Device(mouseY, del_y)[0]!=-1) {
    int k[] = f.related_Device(mouseY, del_y);
    if (device_objs[k[0]].keyAction(char(key), k[1], k[2]));
  }
}

void mousePressed() {
  if (menu.mouseAction(mouseX, mouseY)) {
  } else if (f.related_Device(mouseY, del_y)[0]!=-1) {//eğer click cihazlardan biri üzerine yapıldıysa
    int k[] = f.related_Device(mouseY, del_y);
    boolean shouldDelete = device_objs[k[0]].mouseAction(k[1], k[2]);
    if (shouldDelete) {
      device_objs[k[0]]=null;
      que[k[0]]=null;
    }
  }
}
