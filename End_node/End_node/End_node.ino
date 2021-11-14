

boolean led = false;
void setup() {
  Serial.begin(9600);
  pinMode(LED_BUILTIN,OUTPUT);
}

void loop() {
  if(Serial.available()>0){
    char c = Serial.read();
    if(c=='A'){
    Serial.println("B");
    led = !led;
    }
  }

  if(led)digitalWrite(LED_BUILTIN,HIGH);
  else digitalWrite(LED_BUILTIN,LOW);

}
