#include <Wire.h>
#include "Keyboard.h"

#define Button5 9

int SLAVE_ADDRESS = 0x24; //I2Cのアドレスを0x04に設定

#define KEY_UP_ARROW    0xDA
#define KEY_DOWN_ARROW    0xD9
#define KEY_LEFT_ARROW    0xD8
#define KEY_RIGHT_ARROW   0xD7
#define KEY_BACKSPACE   0xB2

void led_blink(){
  digitalWrite(LED_BUILTIN, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(500);                       // wait for a second
  digitalWrite(LED_BUILTIN, LOW);    // turn the LED off by making the voltage LOW
  delay(500);                       // wait for a second
  digitalWrite(LED_BUILTIN, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(500);                       // wait for a second
  digitalWrite(LED_BUILTIN, LOW);    // turn the LED off by making the voltage LOW
  delay(500);                       // wait for a second
}


void processMessage(int n) {
  int count = 0;
  char rxdata[11] = "";

  //rxdataの初期化
//  for (i = 0; i < 11; i = i + 1) {
//    rxdata[i] = "*";
//  }

//受信したデータのバイト数、TCのみ受け取るため11を想定
  Serial.print("Wire.available(): ");
  Serial.println(Wire.available());
  
  while(Wire.available())  {
    rxdata[count] =  Wire.read();
    count += 1;
  }

  
  String rxdata_str = String((char*) rxdata);
  Serial.print("rxdata_str: ");
  Serial.println(rxdata_str);
  if (rxdata_str.indexOf("cmd") == 0) {
    Serial.print("KeyCommand, ");
    Serial.println(rxdata_str);

    if (rxdata_str == "cmd:left" ){ Keyboard.press(KEY_LEFT_ARROW); }
    if (rxdata_str == "cmd:right"){ Keyboard.press(KEY_RIGHT_ARROW); }
    if (rxdata_str == "cmd:up"){ Keyboard.press(KEY_UP_ARROW); }
    if (rxdata_str == "cmd:down"){ Keyboard.press(KEY_DOWN_ARROW); }
    Keyboard.releaseAll();
  }
  else {
    Serial.print("Timecode, ");
    Serial.println(rxdata_str);
  }

  Serial.println("");
}

  // Keyboard.println(timecode);


void setup() {
  Serial.println("Connection start");
  //I2C接続を開始
  Wire.begin(SLAVE_ADDRESS);
  Serial.println("I2C start");
  //Raspberry Piから何かを受け取るたび、processMessage関数を呼び出す
  // Wire.onReceive(Serial.println(Wire.read()));
  // Serial.println("Rx detect!");
  
  Wire.onReceive(processMessage);
  Serial.println("processMessage");
}

void loop() {
}


// void processMessage(int n) {
//   // int i;
//   int count = 0;
// //受信したデータのバイト数、TCのみ受け取るため11を想定
//   char rxdata[11] = "";
  
//   while(Wire.available())  {
//     rxdata[count] =  Wire.read();
//     count += 1;
//   }
//   Serial.print("yes!");

  
//   // String timecode = String((char*) rxdata);
//   // Keyboard.println(timecode);
// }
