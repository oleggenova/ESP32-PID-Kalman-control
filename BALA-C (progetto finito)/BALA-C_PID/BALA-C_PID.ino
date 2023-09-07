#include <M5StickCPlus.h>
#include "bugC.h"

float roll = 0.0F; //rick
float v1 = 0.0F; 
float v2 = 0.0F; 
float rif = -100.0F;
float err = 0.0F;
float pre_err = 0.0F;
float sum_err = 0.0F;
float proporzionale = 0.0F;
float integrale = 0.0F;
float derivativo = 0.0F;
float P = 4.0F;
float I = 0.025F;
float D = 1.5F;
float PID = 0.0F;
float pre_time = 0.0F;
float act_time = 0.0F;
float dt = 0.0F;

BUGC BugC;

void setup() {
  M5.begin(); 
  M5.IMU.Init(); 
  BugC.Init();
  
  M5.Lcd.setRotation(2);
  M5.Lcd.fillScreen(BLACK); 
  M5.Lcd.setTextSize(1); 
  M5.Lcd.setCursor(15, 20);
  M5.Lcd.println("Roll"); 
}

void loop() {
  act_time = millis();
  dt=act_time  - pre_time;
  M5.IMU.getAhrsData(&v1,&roll,&v2);
  M5.Lcd.setCursor(15, 40); 
  M5.Lcd.printf("%5.2f", roll); 
  err= rif - roll;
  if(err > 0.1 or err < -0.1){
    sum_err = sum_err + err * dt;
    proporzionale = P * err;
    integrale = I * sum_err ;
    derivativo = D * ((err - pre_err)/dt);
    PID = proporzionale + integrale + derivativo;
    BugC.BugCSetAllSpeed(-PID, PID, 0, 0);
    pre_err = err;
  }
  else
  {
    BugC.BugCSetAllSpeed(0, 0, 0, 0);
  }
  pre_time = act_time;
  delay(15);

}
