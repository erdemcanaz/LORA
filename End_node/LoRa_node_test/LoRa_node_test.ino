void setup() {
  Serial.begin(9600);
}

void loop() {
  if(Serial.available()>0){
     char c = Serial.read();
     if(c=='B'){
       Serial.println("C");
     }
  }

  Serial.println('A');
  delay(2000)

}
