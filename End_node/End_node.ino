#define TROUBLESHOOTING false //if you want to see th process ongoing, should be turned of while operating
#define RESET_PIN 7 //this pin directly connected to reset pin of arduino

#define HARD_RESET_TIME 90000 // after how much miliseconds should device reset itself
#define DEL_RESET_MAX 30000
unsigned long DEL_RESET_TIME; //to be sure that arduino reset time differs.

#define BROADCAST_DELAY 2000 // how much miliseconds should pass to broadcast the new data

struct msg {
  unsigned long SENDER_ID = 0;
  unsigned long DESTINATION_ID = 0;
  int TASK = 0;
  int WHICH_OBJECT = 0;
  float FLOAT_VALUE = 0;
};
struct msg serialMsg;

void setup() {
  digitalWrite(RESET_PIN,HIGH);//after defining a pin output, by default it is LOW. Thus if you put this after "pinMode(RESET_PIN,OUTPUT);", device continuously resets itself.
  Serial.begin(9600);
  pinMode(RESET_PIN,OUTPUT);
  DEL_RESET_TIME = random(DEL_RESET_MAX);
}

void loop() {
  ///
  if(millis()>HARD_RESET_TIME+DEL_RESET_TIME)digitalWrite(RESET_PIN,LOW);
  ///
  boolean isSerialMsgReceived = read_serial();
  if(isSerialMsgReceived){
      void reply_it();
  }

}

unsigned long values[] = {0, 0, 0, 0, 0, 0, 0}; // [0]:SENDER_ID, [1]:DESTINATION_ID, [2]:TASK, [3]:WHICH_OBJECT, [4]: FLOAT_INTEGER, [5]:FLOAT_DECIMAL, [6]: counter
boolean isSerialLocked = true;
unsigned long last_time_broadcast = 0;

void reply_it(){
  Serial.println("#1,2,3,4,5.0$");
}
boolean read_serial() {
  //#: start $:end ;:other variable .:other variable
  //negative values are omited

  if (!(Serial.available() > 0))return false;
  char c = Serial.read();

  if (isSerialLocked && c != '#') {
    if ( c == '\n') {
      if (TROUBLESHOOTING)Serial.println("Serial kilitlendi, yeni gelen char \'\\n\' kabul edilmedi");
    } else {
      if (TROUBLESHOOTING)Serial.println("Serial kilitlendi, yeni gelen char \'" + String(c) + "\'kabul edilmedi");
    }
    return false;
  }

  else if (c == '#') {
    for (int i = 0 ; i < 7; i ++)values[i] = 0;
    isSerialLocked = false;
    if (TROUBLESHOOTING)Serial.println("Serial'daki data okunmaya başlandı");
  }

  else if (c == '$') {
    int counter = values[6];
    if (counter != 5) {
      isSerialLocked = true;
      if (TROUBLESHOOTING)Serial.println("Serial kilitlendi, $'a ulaşıldı fakat data eksikti");
      return false;
    }
    //
    serialMsg.SENDER_ID = values[0];
    serialMsg.DESTINATION_ID = values[1];
    serialMsg.TASK = values[2];
    serialMsg.WHICH_OBJECT = values[3];

    float k = values[5];
    while (k > 1)k = k / 10.0f;
    serialMsg.FLOAT_VALUE = values[4] + k;

    if (TROUBLESHOOTING)print_msg(true,false);

    for (int i = 0 ; i < 7; i ++)values[i] = 0;
    isSerialLocked = true;

    if (TROUBLESHOOTING)Serial.println("serialMsg alındı");
    return true;

  } else if (c >= '0' && c <= '9') {
    int counter = values[6];
    values[counter] = values[counter] * 10 + (c - '0');
  } else if (c == ',' || c == '.') {
    values[6] = values[6] + 1;
    if (values[6] == 6) {
      isSerialLocked = true;
      if (TROUBLESHOOTING)Serial.println("Serial kilitlendi, gereğinden fazla data alındı");
    }

  }
  return false;
}
void print_msg(boolean isSerial,boolean isFormatted) {
  if(isFormatted){
    if (isSerial) {
      Serial.print("#" + String(serialMsg.SENDER_ID));
      Serial.print("," + String(serialMsg.DESTINATION_ID));
      Serial.print("," + String(serialMsg.TASK));
      Serial.print("," + String(serialMsg.WHICH_OBJECT));
      Serial.print("," + String(serialMsg.FLOAT_VALUE, 5));
      Serial.println("$");
    }
    else {
    }
  }else{
  if (isSerial) {
    Serial.print("SerialMsg //:");
    Serial.print(" SENDER_ID:" + String(serialMsg.SENDER_ID));
    Serial.print(" DESTINATION_ID:" + String(serialMsg.DESTINATION_ID));
    Serial.print(" TASK:" + String(serialMsg.TASK));
    Serial.print(" WHICH_OBJECT:" + String(serialMsg.WHICH_OBJECT));
    Serial.println(" FLOAT_VALUE:" + String(serialMsg.FLOAT_VALUE, 5));
  }
  else {
  }
}
}
