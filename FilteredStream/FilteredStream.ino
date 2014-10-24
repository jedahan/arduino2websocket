// serial rate
#define baudRate 57600

#include <MPR121.h>
#include <Wire.h>

void setup(){  
  Serial.begin(baudRate);
  while(!Serial); // only needed for Arduino Leonardo or Bare Touch Board 

  // 0x5C is the MPR121 I2C address on the Bare Touch Board
  if(!MPR121.begin(0x5C)){ 
    Serial.println("error setting up MPR121");  
    switch(MPR121.getError()){
      case NO_ERROR:
        Serial.println("no error");
        break;  
      case ADDRESS_UNKNOWN:
        Serial.println("incorrect address");
        break;
      case READBACK_FAIL:
        Serial.println("readback failure");
        break;
      case OVERCURRENT_FLAG:
        Serial.println("overcurrent on REXT pin");
        break;      
      case OUT_OF_RANGE:
        Serial.println("electrode out of range");
        break;
      case NOT_INITED:
        Serial.println("not initialised");
        break;
      default:
        Serial.println("unknown error");
        break;      
    }
    while(1);
  }
}

void loop(){
   readRawInputs();  
}

void readRawInputs(){
    int i;
    
    MPR121.updateAll();
    Serial.print(MPR121.getFilteredData(11));
    Serial.print("&");
}
