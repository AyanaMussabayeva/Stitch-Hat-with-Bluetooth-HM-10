#include <SoftwareSerial.h>
#include <Servo.h>
int rx = 10;
int tx = 11;
char s = ' ';
Servo servo; 
Servo servoS;
int servo1 = 2; 
int servo2 = 3;
SoftwareSerial BSerial = SoftwareSerial(rx, tx);
void setup() {
 // pinMode(9, OUTPUT);
 // digitalWrite(9, HIGH);
 
  BSerial.begin(9600);
  Serial.begin(9600);
   //servoS.attach(servo1); 
   //servo.attach(servo2); 
   
}
void move3(){
    servoS.attach(servo1); 
    servo.attach(servo2); 
    servo.write(90);
    servoS.write(90);
    delay(50);
    servo.write(60);
    servoS.write(60);
    delay(50);
    servo.write(30);
    servoS.write(30);
    delay(50);
    servo.write(0);
    servoS.write(0);
    delay(50);
}
void fastMove(){
    servoS.attach(servo1); 
    servo.attach(servo2); 
    servo.write(90);
    servoS.write(90);
    delay(100);
    servo.write(45);
    servoS.write(45);
    delay(100);
    servo.write(0);
    servoS.write(0);
    delay(100);
}
void fromSidetoSide(){
   servoS.attach(servo1); 
   servo.attach(servo2); 
  for(int i = 0; i < 90; i+=4){
    servo.write(i);
    servoS.write(i);
    delay(50);
  }
  for(int i = 80; i >0; i-=4){
    servo.write(i);
    servoS.write(i);
    delay(50); 
  }
}
void loop() {
  // put your main code here, to run repeatedly:
  if(BSerial.available()){
    //Serial.write(BSerial.read());
    s = BSerial.read();
    Serial.write(s);
     if(s == '1'){
        Serial.write("Hi");
        for(int i = 1; i < 10; i++){
          fastMove();
          delay(100);
        }  
     }
     else if (s == '2'){
        fromSidetoSide();
        delay(10);
      }
      else if(s == '3'){
       for(int i = 0; i < 30; i++){
         move3();
       }
         
      }
  servoS.detach(); 
   servo.detach();
   s = ' ';
  } 
 

 
  
  
  
}
