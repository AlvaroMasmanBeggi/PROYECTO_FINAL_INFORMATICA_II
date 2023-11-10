int i = 2;
int brillo = 0; // Inicializa el brillo a 0
int PULSADOR1 = A0;
int PULSADOR2 = A1;
int PULSADOR3 = A2;
int PULSADOR4 = A3;
int Sensor1=2;
int LED1 = 13;
int LED2 = 12;
int LED3 = 11;
int LED4 = 10;
int LedSensor=9;
int estado;
String MensajeRecibido;
boolean Led1Encedido=false;
boolean Led2Encedido=false;
boolean Led3Encedido=false;
boolean Led4Encedido=false;
boolean Estado_Sensor=false;
boolean Primera_Deteccion=true;
int ValorSensor;
void setup() {
  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
  pinMode(LED3, OUTPUT);
  pinMode(LED4, OUTPUT);
  pinMode(LedSensor, OUTPUT);
  pinMode(PULSADOR1, INPUT);
  pinMode(PULSADOR2, INPUT);
  pinMode(PULSADOR3, INPUT);
  pinMode(PULSADOR4, INPUT);
  pinMode(Sensor1, INPUT);
  Serial.begin(9600);
  estado = LED1;
}
void loop() {
  
  if (analogRead(PULSADOR1) == LOW) {
   if(!Led1Encedido)
      {
      digitalWrite(LED1, HIGH);
      Serial.print("LE1\n");
      Led1Encedido=true;
      delay(150);
      } else
        {
          digitalWrite(LED1, LOW);
          Serial.print("LA1\n");
          Led1Encedido=false;
          delay(150);
        }
  }

  if (analogRead(PULSADOR2) == LOW) {

     if(!Led2Encedido)
      {
      digitalWrite(LED2, HIGH);
      Led2Encedido=true;
      delay(150);
      } else
        {
          digitalWrite(LED2, LOW);
          Serial.println("Apago L2");
          Led2Encedido=false;
          delay(150);
        }
   
  }
  
  if (analogRead(PULSADOR3) == LOW) {
    if(!Led3Encedido)
      {
      digitalWrite(LED3, HIGH);
      Serial.println("Prendio L3");
      Led3Encedido=true;
      delay(150);
      } else
        {
          digitalWrite(LED3, LOW);
          Serial.println("Apago L3");
          Led3Encedido=false;
          delay(150);
        }
  }
    if (analogRead(PULSADOR4) == LOW) {
    if(!Led4Encedido)
      {
      digitalWrite(LED4, HIGH);
      Serial.println("Prendio L4");
      Led4Encedido=true;
      delay(150);
      } else
        {
          digitalWrite(LED4, LOW);
          Serial.println("Apago L4");
          Led4Encedido=false;
          delay(150);
        }
  }
  
   if(digitalRead(Sensor1)==HIGH && Primera_Deteccion==true)
    {
          digitalWrite(LedSensor, HIGH);
          Serial.print("SE1\n");
          Primera_Deteccion=false;
          delay(150);
     }else if(digitalRead(Sensor1) == LOW && Primera_Deteccion==false)
       {
          Primera_Deteccion=true;
          digitalWrite(LedSensor,LOW);
          Serial.print("SA1\n");
          delay(150);
       }

  if(Serial.available() > 0)
  {
      MensajeRecibido=Serial.readStringUntil('\n');
      if(MensajeRecibido=="LE1")
      { 
        digitalWrite(LED1, HIGH);
        if(Led1Encedido=true)
        {
               Led1Encedido=!Led1Encedido;
        }
      }
      if(MensajeRecibido=="LA1")
      {
        digitalWrite(LED1, LOW);
        if(Led1Encedido=false)
        {
               Led1Encedido=!Led1Encedido;
        }
      }
  }

 
   // Actualiza el estado anterior 
}
