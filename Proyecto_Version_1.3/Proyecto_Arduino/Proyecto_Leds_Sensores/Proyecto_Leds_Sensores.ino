
//--------------------------------------------DECLARACION DE VARIABLES------------------------------------------//

//VARIABLES PARA LA TRANSMISION DE DATOS VIA PUERTO SERIE//
String Buffer = "";
String MensajeRecibido;
String BufferTiempo= "";

//VARIABLES PARA EL MANEJO DEL TIEMPO DE LOS LEDS//
int TiempoFinal;
int TiempoAnterior;
//VARIABLES PARA SETEAR LOS PINES A USAR//
int PULSADOR1 = A0;
int PULSADOR2 = A1;
int PULSADOR3 = A2;
int PULSADOR4 = A3;
int PULSADOR5 = A4;
int PULSADOR6 = A5;

int LED1 = 13;
int LED2 = 12;
int LED3 = 11;
int LED4 = 10;
int LED5 = 9;
int LED6 = 8;
int LedSensor1=7;
int Sensor1=2;

//VARIABLES PARA EL CONTROL DE ESTADOS DURANTE LA EJECUCION//
boolean Led1Encedido=false;
boolean Led2Encedido=false;
boolean Led3Encedido=false;
boolean Led4Encedido=false;
boolean Led5Encedido=false;
boolean Led6Encedido=false;
boolean Primera_Deteccion=true;
int ValorSensor;

//--------------------------------------------CONFIGURACION DEL PROGRAMA------------------------------------------//

void setup() {
  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
  pinMode(LED3, OUTPUT);
  pinMode(LED4, OUTPUT);
  pinMode(LedSensor1, OUTPUT);
  pinMode(PULSADOR1, INPUT);
  pinMode(PULSADOR2, INPUT);
  pinMode(PULSADOR3, INPUT);
  pinMode(PULSADOR4, INPUT);
  pinMode(Sensor1, INPUT);
  Serial.begin(11200);
  TiempoAnterior=millis();
}

//--------------------------------------------PROGRAMA PRINCIPAL------------------------------------------//

void loop() 
{
  
  //CONTROL FISICO LED1 //
  
  if (analogRead(PULSADOR1) == LOW) {
   if(!Led1Encedido)
      {
      digitalWrite(LED1, HIGH);
      Serial.print("LE1\n");
      Led1Encedido=true;
      Buffer = Buffer + "LE1-";
      delay(150);
      } else
        {
          digitalWrite(LED1, LOW);
          Serial.print("LA1\n");
          Led1Encedido=false;
          Buffer = Buffer + "LA1-";
          delay(150);
        }
      //REGISTRO DE TIMEPO DEL LED//
         Establecer_Tiempo();
       }//FIN CONTROL LED 1//
  

  //CONTROL FISICO LED2//

  if (analogRead(PULSADOR2) == LOW) {
     if(!Led2Encedido)
      {
      digitalWrite(LED2, HIGH);
      Led2Encedido=true;
      Serial.print("LE2\n");
      Buffer = Buffer + "LE2-";
      delay(150);
      } else
        {
          digitalWrite(LED2, LOW);
          Serial.print("LA2\n");
          Buffer = Buffer + "LA2-";
          Led2Encedido=false;
          delay(150);
        }
      //REGISTRO DE TIMEPO DEL LED//  
      
        Establecer_Tiempo();
         
       }//FIN CONTROL LED2//
  
  //CONTROL FISICO LED3//

  if (analogRead(PULSADOR3) == LOW) {
    if(!Led3Encedido)
      {
      digitalWrite(LED3, HIGH);
      Serial.print("LE3\n");
      Buffer = Buffer + "LE3-";
      Led3Encedido=true;
      delay(150);
      } else
        {
          digitalWrite(LED3, LOW);
          Serial.print("LA3\n");
          Buffer = Buffer + "LA3-";
          Led3Encedido=false;
          delay(150);
        }
      //REGISTRO DE TIMEPO DEL LED//
        Establecer_Tiempo();  
  }//FIN CONTROL LED3//

  //CONTROL FISICO LED4//

  if (analogRead(PULSADOR4) == LOW) {
    if(!Led4Encedido)
      {
      digitalWrite(LED4, HIGH);
      Serial.print("LE4\n");
      Buffer = Buffer + "LE4-";
      Led4Encedido=true;
      delay(150);
      } else
        {
          digitalWrite(LED4, LOW);
          Serial.print("LA4\n");
          Buffer = Buffer + "LA4-";
          Led4Encedido=false;
          delay(150);
        }
       //REGISTRO DE TIMEPO DEL LED//  
        Establecer_Tiempo();
  }//FIN CONTROL LED4//

  //CONTROL FISICO LED5//

  if (analogRead(PULSADOR5) == LOW) {
    if(!Led5Encedido)
      {
      digitalWrite(LED5, HIGH);
      Serial.print("LE5\n");
      Buffer = Buffer + "LE5-";
      Led5Encedido=true;
      delay(150);
      } else
        {
          digitalWrite(LED5, LOW);
          Serial.print("LA5\n");
          Buffer = Buffer + "LA5-";
          Led5Encedido=false;
          delay(150);
        }
       //REGISTRO DE TIMEPO DEL LED//  
        Establecer_Tiempo();
  }//FIN CONTROL LED5//

   //CONTROL FISICO LED6//

  if (analogRead(PULSADOR6) == LOW) {
    if(!Led6Encedido)
      {
      digitalWrite(LED6, HIGH);
      Serial.print("LE6\n");
      Buffer = Buffer + "LE6-";
      Led6Encedido=true;
      delay(150);
      } else
        {
          digitalWrite(LED6, LOW);
          Serial.print("LA6\n");
          Buffer = Buffer + "LA6-";
          Led6Encedido=false;
          delay(150);
        }
       //REGISTRO DE TIMEPO DEL LED//  
        Establecer_Tiempo();
  }//FIN CONTROL LED6//
  
  
  //CONTROL DEL SENSOR DE LA PUERTA//

  if(digitalRead(Sensor1)==HIGH && Primera_Deteccion==true)
    {
          digitalWrite(LedSensor1, HIGH);
          Serial.print("SE1\n");
          Buffer = Buffer + "SE1-";
          Primera_Deteccion=false;
          Establecer_Tiempo();
          delay(150);
     }else if(digitalRead(Sensor1) == LOW && Primera_Deteccion==false)
       {
          digitalWrite(LedSensor1,LOW);
          Serial.print("SA1\n");
          Establecer_Tiempo();
          Buffer = Buffer + "SA1-";
          Primera_Deteccion=true;
          delay(150);
       }//FIN CONTROL SENSOR DE LA PUERTA//


  //-----------------------------------------PARTE PARA ANALIZAR SI ME CONTROLAN LAS LUCES O ALGUN PROCESO DESDE PROCESSING---------------------------------------------------------//

  if(Serial.available() > 0)
  {
      MensajeRecibido=Serial.readStringUntil('\n');
      
      //ME ENCENDIERON EL LED1?//
      if(MensajeRecibido=="LE1")
      { 
        digitalWrite(LED1, HIGH);
        Buffer = Buffer+"LE1-";
        if(Led1Encedido=true)
        {
               Led1Encedido=!Led1Encedido;
        }
        //REGISTRO DE TIMEPO DEL LED//
          Establecer_Tiempo();
      }//FIN ENCENDIERON LED1//

      //ME APAGARON EL LED1?//
      if(MensajeRecibido=="LA1")
      {
        
        digitalWrite(LED1, LOW);
        Buffer = Buffer+"LA1-";
        if(Led1Encedido=false)
        {
               Led1Encedido=!Led1Encedido;
        }

        //REGISTRO DE TIMEPO DEL LED//
        Establecer_Tiempo();
      }//FIN APAGARON LED1//


       //ME ENCENDIERON EL LED2?//
      if(MensajeRecibido=="LE2")
      { 
        digitalWrite(LED2, HIGH);
        Buffer = Buffer+"LE2-";
        if(Led2Encedido=true)
        {
               Led2Encedido=!Led2Encedido;
        }
        //REGISTRO DE TIMEPO DEL LED//
          Establecer_Tiempo();
      }//FIN ENCENDIERON LED2//

      //ME APAGARON EL LED2?//
      if(MensajeRecibido=="LA2")
      {
        digitalWrite(LED2, LOW);
        Buffer = Buffer+"LA2-";
        if(Led2Encedido=false)
        {
               Led2Encedido=!Led2Encedido;
        }

        //REGISTRO DE TIMEPO DEL LED//
          Establecer_Tiempo();
      }//FIN APAGARON LED2//

       //ME ENCENDIERON EL LED3?//
      if(MensajeRecibido=="LE3")
      { 
        digitalWrite(LED3, HIGH);
        Buffer = Buffer+"LE3-";
        if(Led3Encedido=true)
        {
               Led3Encedido=!Led3Encedido;
        }
        //REGISTRO DE TIMEPO DEL LED//
        Establecer_Tiempo();
      }//FIN ENCENDIERON LED3//

      //ME APAGARON EL LED3?//
      if(MensajeRecibido=="LA3")
      {
        digitalWrite(LED3, LOW);
        Buffer = Buffer+"LA3-";
        if(Led3Encedido=false)
        {
               Led3Encedido=!Led3Encedido;
        }

        //REGISTRO DE TIMEPO DEL LED//
         Establecer_Tiempo();
      }//FIN APAGARON LED3//


       //ME ENCENDIERON EL LED4?//
      if(MensajeRecibido=="LE4")
      { 
        digitalWrite(LED4, HIGH);
        Buffer = Buffer+"LE4-";
        if(Led4Encedido=true)
        {
               Led4Encedido=!Led4Encedido;
        }
        //REGISTRO DE TIMEPO DEL LED//
          Establecer_Tiempo();
      }//FIN ENCENDIERON LED4//

      //ME APAGARON EL LED4?//
      if(MensajeRecibido=="LA4")
      {
        digitalWrite(LED4, LOW);
        Buffer = Buffer+"LA4-";
        if(Led4Encedido=false)
        {
               Led4Encedido=!Led4Encedido;
        }

        //REGISTRO DE TIMEPO DEL LED//
          Establecer_Tiempo();
      }//FIN APAGARON LED4//


       //ME ENCENDIERON EL LED5?//
      if(MensajeRecibido=="LE5")
      { 
        digitalWrite(LED5, HIGH);
        Buffer = Buffer+"LE5-";
        if(Led5Encedido=true)
        {
               Led5Encedido=!Led5Encedido;
        }
        //REGISTRO DE TIMEPO DEL LED//
          Establecer_Tiempo();
      }//FIN ENCENDIERON LED5//

      //ME APAGARON EL LED5?//
      if(MensajeRecibido=="LA5")
      {
        digitalWrite(LED5, LOW);
        Buffer = Buffer+"LA5-";
        if(Led5Encedido=false)
        {
               Led5Encedido=!Led5Encedido;
        }

        //REGISTRO DE TIMEPO DEL LED//
          Establecer_Tiempo();
      }//FIN APAGARON LED5//


       //ME ENCENDIERON EL LED6?//
      if(MensajeRecibido=="LE6")
      { 
        digitalWrite(LED6, HIGH);
        Buffer = Buffer+"LE6-";
        if(Led6Encedido=true)
        {
               Led6Encedido=!Led6Encedido;
        }
        //REGISTRO DE TIMEPO DEL LED//
          Establecer_Tiempo();
      }//FIN ENCENDIERON LED6//

      //ME APAGARON EL LED6?//
      if(MensajeRecibido=="LA6")
      {
        digitalWrite(LED6, LOW);
        Buffer = Buffer+"LA6-";
        if(Led6Encedido=false)
        {
               Led6Encedido=!Led6Encedido;
        }

        //REGISTRO DE TIMEPO DEL LED//
          Establecer_Tiempo();
      }//FIN APAGARON LED6//



      //ME PIDIERON LOS DATOS DESDE PROCESSING?//
      if(MensajeRecibido=="BUF")
      {
        Buffer = Buffer+ "?" + BufferTiempo+ "\n";
        Serial.print(Buffer);
        digitalWrite(LED1, HIGH);
      }
  } //FIN SERIAL AVAILABLE//
  
} //FIN LOOP//


//--------------------------------FUNCIONES PARA EL MANEJO DEL PROGRAMA-------------------------------------------------------------//
void Establecer_Tiempo()
{
         TiempoFinal=millis();
         TiempoAnterior=TiempoFinal-TiempoAnterior;
         String tiempoString = String(TiempoAnterior);
         BufferTiempo=BufferTiempo + tiempoString + "-";
         TiempoAnterior= TiempoFinal;
}
