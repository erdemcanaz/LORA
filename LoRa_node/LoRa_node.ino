#define TROUBLESHOOTING true

void setup() {
  // put your setup code here, to run once:

}

void loop() {
  // put your main code here, to run repeatedly:

}

struct msg {
  unsigned long SENDER_ID = "";
  unsigned long DESTINATION_ID = "";
  int TASK = 0;
  int WHICH_OBJECT = 0;
  float FLOAT_VALUE = 0;
};
struct msg serialMsg;

unsigned long values[] = {0, 0, 0, 0, 0, 0, 0}; // [0]:SENDER_ID, [1]:DESTINATION_ID, [2]:TASK, [3]:WHICH_OBJECT, [4]: FLOAT_INTEGER, [5]:FLOAT_DECIMAL, [6]: counter
boolean isSerialLocked = true;

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
    for (int i = 0 ; i < 7; i ++)values[i]=0;
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

    if (TROUBLESHOOTING)print_serialMsg();
      for (int i = 0 ; i < 7; i ++)values[i]=0;
    isSerialLocked = true;
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
void print_serialMsg() {
  Serial.println("SerialMsg----(" + String(millis()) + ")");
  Serial.println("SENDER_ID:" + String(serialMsg.SENDER_ID));
  Serial.println("DESTINATION_ID:" + String(serialMsg.DESTINATION_ID));
  Serial.println("TASK:" + String(serialMsg.TASK));
  Serial.println("WHICH_OBJECT:" + String(serialMsg.WHICH_OBJECT));
  Serial.println("FLOAT_VALUE:" + String(serialMsg.FLOAT_VALUE, 5));
  Serial.println("---------------");
}
