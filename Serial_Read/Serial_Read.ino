// Unsigned long 4,294,967,295 (2^32 - 1).
#define THIS_ID 1
#define TROUBLESHOOTING true

#define SERIAL_TIMEOUT_MS 1000
#define DEVICE_REPLY_TIMEOUT_MS 5000

#include "LoRa_E32.h"
#include <SoftwareSerial.h>

SoftwareSerial mySerial(10, 11);
LoRa_E32 e32ttl(&mySerial);

struct msg {
  unsigned long SENDER_ID = "";
  unsigned long DESTINATION_ID = "";
  int TASK = 0;
  int WHICH_OBJECT = 0;
  float FLOAT_VALUE = 0;
};
struct msg serialMsg, data_lora;
void print_serialMsg() {
  Serial.println("SerialMsg----(" + String(millis()) + ")");
  Serial.println("SENDER_ID:" + String(serialMsg.SENDER_ID));
  Serial.println("DESTINATION_ID:" + String(serialMsg.DESTINATION_ID));
  Serial.println("TASK:" + String(serialMsg.TASK));
  Serial.println("WHICH_OBJECT:" + String(serialMsg.WHICH_OBJECT));
  Serial.println("FLOAT_VALUE:" + String(serialMsg.FLOAT_VALUE, 5));
  Serial.println("---------------");
}
void setup() {
  Serial.begin(9600);
  e32ttl.begin();
  delay(5000);
}
void loop() {
 serialCheck();
 LoRaCheck();
}

//LORA
void shareLoRaDataWithDevice() {
  Serial.print("#");
  Serial.print(data_lora.SENDER_ID);
  Serial.print(",");
  Serial.print(data_lora.DESTINATION_ID);
  Serial.print(",");
  Serial.print(data_lora.TASK);
  Serial.print(",");
  Serial.print(data_lora.WHICH_OBJECT);
  Serial.print(",");
  Serial.print(data_lora.FLOAT_VALUE);
  Serial.println("$");
}
void LoRaCheck() {

  while (e32ttl.available() > 1) { // LoRa'da okunabilecek mesaj var mı?
    if (TROUBLESHOOTING)Serial.println("LoRa'daki mesaj okunuyor");
    ResponseStructContainer rsc = e32ttl.receiveMessage(sizeof(msg));//LoRa'daki mesajı oku
    data_lora = *(msg*) rsc.data; //LoRa'daki mesajı data_lora'ya kaydet

    if (data_lora.DESTINATION_ID != THIS_ID) { // mesaj bana mı gelmiş, gelmediyse mesajı yoksay
      if (TROUBLESHOOTING)Serial.println("Mesaj bana gelmemiş");
      return;//mesajı yoksay
    }

    while (Serial.available()) char c = Serial.read(); //bana bağlı cihazın gönderdiği tüm önceki mesajları sildim

    if (data_lora.TASK == 2 || data_lora.TASK == 3) { // bana bağlı olan cihazın bu mesaja cevap vermesini bekliyor muyum
      shareLoRaDataWithDevice(); //ve gelen mesajı bana bağlı olan cihazla paylaştım
      if (TROUBLESHOOTING)Serial.println("Lora üzerinden gelen mesajı bana bağlı alet ile paylaştım,Bana bağlı olan alet bu mesaja cevap vermeyecek");
      return; // Aletin cevap vermesini beklemediğimden işlemi bitirdim.
    } else {
      shareLoRaDataWithDevice(); //ve gelen mesajı bana bağlı olan cihazla paylaştım
      if (TROUBLESHOOTING)Serial.println("Lora üzerinden gelen mesajı bana bağlı alet ile paylaştım");
    }
    //-----------

    if (listen_serial_this_ms_long(DEVICE_REPLY_TIMEOUT_MS)) { //Bana bağlı cihaz DEVICE_REPLY_TIMEOUT_MS dan kısa sürede bana cevap vermiş ise
      serialMsg.SENDER_ID = THIS_ID; //Kendi ID'mi bu mesaja ekliyorum
      serialMsg.TASK = 2; //Bana bağlı alet cevap verdi, bu da verdiği cevap
      e32ttl.sendFixedMessage(0, 0, 0, &serialMsg, sizeof(msg)); //bana bağlı aletin mesajını lora üzerinden yayıyorum
      if (TROUBLESHOOTING)Serial.println("Bana bağlı aletin mesajını lora üzerinden yayıyorum");
    } else {//Benim bu mesajı aldığıma ama bana bağlı aletin cevap vermediğine yönelik bir mesaj hazırlıyorum?
      serialMsg.SENDER_ID = THIS_ID; //Kendi ID'mi bu mesaja ekliyorum
      serialMsg.DESTINATION_ID = data_lora.SENDER_ID;
      serialMsg.TASK = 3; // bana bağlı alet cevap vermedi, ama ben burdayım;
      e32ttl.sendFixedMessage(0, 0, 0, &serialMsg, sizeof(msg)); //bana bağlı alet cevap vermedi, ama ben burdayımı lora üzerinden yayıyorum
      if (TROUBLESHOOTING)Serial.println("bana bağlı alet cevap vermedi, ama ben burdayımı lora üzerinden yayıyorum");
    }
    rsc.close();
  }
}
boolean listen_serial_this_ms_long(int t) {
  if (t < 0) {
    return false;
  } else if (t == 0) {
    return read_serial();
  } else {
    unsigned long now = millis();
    while (millis() - now < t) {
      boolean b = read_serial();
      if (b == true) {
        return true;
      }
    }
    return false;
  }
}


//SERIAL
void serialCheck() {
  if (read_serial()) {
    serialMsg.SENDER_ID=THIS_ID;
    e32ttl.sendFixedMessage(0, 0, 0, &serialMsg, sizeof(msg)); //eğer serial'dan bir mesaj gekdiyse mesajı lora üzerinden yayıyorum
   if (TROUBLESHOOTING)Serial.println("Serial'dan okuduğum datayı lora üzerinden yayıyorum");
  }
}

unsigned long values[] = {0, 0, 0, 0, 0, 0, 0}; // [0]:SENDER_ID, [1]:DESTINATION_ID, [2]:TASK, [3]:WHICH_OBJECT, [4]: FLOAT_INTEGER, [5]:FLOAT_DECIMAL, [6]: counter
boolean isSerialLocked = true;
unsigned long lastTimeSerialData = 0;

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
    clean_values();
    isSerialLocked = false;
    lastTimeSerialData = millis();
    if (TROUBLESHOOTING)Serial.println("Serial'daki data okunmaya başlandı");
  }
  else if (millis() - lastTimeSerialData > SERIAL_TIMEOUT_MS) {
    isSerialLocked = true;
    if (TROUBLESHOOTING)Serial.println("Serial'daki mesaj " + String(SERIAL_TIMEOUT_MS) + " ms boyunca tamamlanmadı, Serial kilitlendi" );
    return false;
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
    //
    clean_values();
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
void clean_values() {
  for (int i = 0 ; i < 7; i ++) {
    values[i] = 0;
  }
}
