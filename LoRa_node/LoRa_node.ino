#define TROUBLESHOOTING false
#define AUX_PIN 8
#include "LoRa_E32.h"
#include <SoftwareSerial.h>

SoftwareSerial mySerial(10, 11);
LoRa_E32 e32ttl(&mySerial);

struct msg {
  unsigned long SENDER_ID = 0;
  unsigned long DESTINATION_ID = 0;
  int TASK = 0;
  int WHICH_OBJECT = 0;
  float FLOAT_VALUE = 0;
};
struct msg serialMsg, loraMsg;
void setup() {
  Serial.begin(9600);
  e32ttl.begin();
  pinMode(AUX_PIN, INPUT);
}


void loop() {
  read_serial_and_broadcast_it(2000);
  listen_broadcast_and_write_it_to_serial();
}


unsigned long values[] = {0, 0, 0, 0, 0, 0, 0}; // [0]:SENDER_ID, [1]:DESTINATION_ID, [2]:TASK, [3]:WHICH_OBJECT, [4]: FLOAT_INTEGER, [5]:FLOAT_DECIMAL, [6]: counter
boolean isSerialLocked = true;
unsigned long last_time_broadcast = 0;

boolean read_serial_and_broadcast_it(int period) {
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

    if (millis() - last_time_broadcast < period) {
      if (TROUBLESHOOTING)Serial.println("Son broadcast'ten beri yeterince zaman gecmedi icin bu mesaji yayinlamadim");
      return;
    }
    last_time_broadcast = millis();

    while (digitalRead(AUX_PIN) == 0) {
      if (TROUBLESHOOTING)Serial.println("LoRa'nin musait olmasini bekliyorum");
      delay(5);
    }
    e32ttl.sendFixedMessage(0, 0, 0, &serialMsg, sizeof(msg));
    if (TROUBLESHOOTING)Serial.println("serialMsg'i lora uzerinden yaydim");
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

void listen_broadcast_and_write_it_to_serial() {
  while (e32ttl.available() > 1) { // LoRa'da okunabilecek mesaj var mı?
    if (TROUBLESHOOTING)Serial.println("LoRa'daki mesaj okunuyor");
    ResponseStructContainer rsc = e32ttl.receiveMessage(sizeof(msg));//LoRa'daki mesajı oku
    loraMsg = *(msg*) rsc.data; //LoRa'daki mesajı data_lora'ya kaydet
    print_msg(false,true);

  }
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
      Serial.print("#" + String(loraMsg.SENDER_ID));
      Serial.print("," + String(loraMsg.DESTINATION_ID));
      Serial.print("," + String(loraMsg.TASK));
      Serial.print("," + String(loraMsg.WHICH_OBJECT));
      Serial.print("," + String(loraMsg.FLOAT_VALUE, 5));
      Serial.println("$");
    }
  }else{}
  if (isSerial) {
    Serial.print("SerialMsg //:");
    Serial.print(" SENDER_ID:" + String(serialMsg.SENDER_ID));
    Serial.print(" DESTINATION_ID:" + String(serialMsg.DESTINATION_ID));
    Serial.print(" TASK:" + String(serialMsg.TASK));
    Serial.print(" WHICH_OBJECT:" + String(serialMsg.WHICH_OBJECT));
    Serial.println(" FLOAT_VALUE:" + String(serialMsg.FLOAT_VALUE, 5));
  }
  else {
    Serial.print("loraMsg //:");
    Serial.print(" SENDER_ID:" + String(loraMsg.SENDER_ID));
    Serial.print(" DESTINATION_ID:" + String(loraMsg.DESTINATION_ID));
    Serial.print(" TASK:" + String(loraMsg.TASK));
    Serial.print(" WHICH_OBJECT:" + String(loraMsg.WHICH_OBJECT));
    Serial.println(" FLOAT_VALUE:" + String(loraMsg.FLOAT_VALUE, 5));
  }
}
}
