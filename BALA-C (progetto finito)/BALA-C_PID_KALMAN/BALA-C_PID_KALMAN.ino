#include <M5StickCPlus.h>
#include "bugC.h"

//
float K = 0; 
float A = 1;
float B = 1;
float C = 1;
float D = 1;
float P = 0; 
float P_pre = 0;
float P_1 = 0;
float y = 0;
float x = 0;
float x_pre = 0;
float v1 = 0;
float v2 = 0;
float Q = 0.1;  //cov disturbo e incertezza sul processo/sensore IMU (parecchia incertezza sulla modellazione del sensore/sistema)
float R =  0.0228; //cov rumore sensore ROll IMU (trovata sperimentalmente)
// 
float rif = -100.5; //angolo di riferimento
float err = 0.0; 
float pre_err = 0.0;
float sum_err = 0.0; 
float proporzionale = 0.0; //controllo proporzionale
float integrale = 0.0; //controllo integrale
float derivativo = 0.0; //controllo derivativo
float P_gain = 3.0; //guadagno proporzionale 
float I_gain = 0.025; //guadagno integrale
float D_gain = 2.0; //guadagno derivativo
float PID = 0.0;
float pre_time = 0.0;
float act_time = 0.0;
float dt = 0.0;
//

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
  M5.Lcd.setCursor(15, 70);
  M5.Lcd.println("Real Roll"); 
}

void loop() {
  //Acquisizione misura angolo
  M5.IMU.getAhrsData(&v1, &y,&v2); 

  //Implementazione in linea del filtro di Kalman
  P_1=A*P_pre*A + B*Q*B;
  K = P_1*C/(C*P_1*C + D*R*D); 
  x = A*x_pre + K*(y-C*A*x_pre);
  P = (1 - K)*P_1;
  
  x_pre = x;
  P_pre = P;

  //Print su LCD  
  M5.Lcd.setCursor(15, 90); 
  M5.Lcd.printf("%5.2f", x); 
  M5.Lcd.setCursor(15, 40); 
  M5.Lcd.printf("%5.2f", y);

  //Controllo PID
  err= rif - x;
  act_time = millis();
  dt = act_time  - pre_time;
  if(err > 0.1 or err < -0.1){
    sum_err = sum_err + err * dt;
    proporzionale = P_gain * err;
    integrale = I_gain * sum_err ;
    derivativo = D_gain * ((err - pre_err) / dt);
    PID = proporzionale + integrale + derivativo;
    BugC.BugCSetAllSpeed(-PID, PID, 0, 0);
    pre_err = err;
  }
  else
  {
    BugC.BugCSetAllSpeed(0, 0, 0, 0);
  }
  
  pre_time = act_time;
  delay(10);
}
