//------------------------------------------------------------------PROYECTO DOMOTICA------------------------------------------------------------------------------//
import processing.serial.*;
import java.util.Date;
import java.util.Calendar;

// VARIABLES PARA LA COMUNICACION 

String MensajeLectura; //Variable para guardar lo que recibo desde arduino//
String MensajeEscritura; //Variable para guardar lo que voy a enviar a arduino//
Serial myPort;

String [] DividirReplayAcciones; //Lista para guardar las acciones que extraemos desde la cadena larga enviada por arduino//
String [] DividirReplayTiempo; //Lista para guardar el tiempo real de las acciones que extraemos desde la cadena larga enviada por arduino//
String [] DividirReplayGeneral; //Lista para guardar las dos cadenas en las que voy a separar la cadena larga enviad por arduino, una parte acciones y otra tiempo//
String MensajeReciboBuffer; //Variable para recibir la cadena larga con informacion desde arduino//
 
//VARIABLES PARA EL USO DEL PROGRAMA//

int Delay; //Variable para guardar el tiempo convertido de cadena a entero, previamente recibido desde arduino//

PFont fuente; //Variable para el tipo de letra//

String filename = "Daatos.txt";  //Cadena que almacena el nombre del archivo donde estoy guardadndo los datos//
String[] list ; //Esta lista de cadenas la usamos para guardar las partes del buffer cuando la seccionamos//

boolean Pido_Primera_Vez_Fondo_Menu = true; //Algunas variables para manejar estados//
boolean Pido_Primera_Vez = true;
boolean CambioDeColor1=true;
boolean CambioDeColor2=true;
boolean CambioDeColor3=true;
boolean CambioDeColor4=true;
boolean CambioDeColor5=true;
boolean CambioDeColor6=true;
boolean CambioDeColor7=true;

int MantenerPrendidoLed1=0; //Variables para manejar estados//
int MantenerPrendidoLed2=0;
int MantenerPrendidoLed3=0;
int MantenerPrendidoLed4=0;
int MantenerPrendidoLed5=0;
int MantenerPrendidoLed6=0;
int MantenerPrendidoLed7=0;
int Grafico_Menu=0;
int BorroReplay=0;

int EncenderLed=1; //Variables para pasarle a funciones y ser mas claros, es decir, en vez de pasarle un 1 le pasamos EndenderLed//
int ApagarLed=2;
int EncenderSensor=1;
int ApagarSensor=2;
int Contador=0;
int ContadorNumero=0;

//VARIABLES PARA EL MANEJO DEL MENU//

int Selector_Menu = 0; // El 0 representa que estoy en el menu principal, 1 voy al boton IR, 2 voy al boton REPLAY//


//VARIABLE QUE MANEJA LA MAMORIA DURANTE LA EJECUCION DEL PROGRAMA//

String Buffer=""; //Cadena que se usa para ir almacenando todos los datos mientras se ejecuta el programa//


//VARIABLES PARA TRABAJAR CON LAS IMAGENES DE LOS FONDOS//

PImage fondo; 
PImage fondoMenu; 


//------------------------------------------------------------------------------------------------------------------------------------------------//

class Dispositivos
{
  private 
  int anio;
  int mes;
  int dia;
  int hora;
  int minutos;
  int segundos;
  String Evento;
  public
  String Convertir_A_Cadena_Y_Concatenar(int ANIO, int MES, int DIA, int HORA, int MINUTOS, int SEGUNDOS, String BUFFER)
  {
    String[] Arreglo = new String[7];
    String ArregloDeEspacio="     ";
    String ArregloDeDosPuntos=":";
    String ArregloDeBarra="|";
    String Fecha="Fecha: ";
    String Hora="Hora: ";
    Arreglo[0] = ",";
    Arreglo[1] = nf(ANIO);
    Arreglo[2] = nf(MES);
    Arreglo[3] = nf(DIA);
    Arreglo[4] = nf(HORA);
    Arreglo[5] = nf(MINUTOS);
    Arreglo[6] = nf(SEGUNDOS);
    
    BUFFER =Fecha+Arreglo[1]+ArregloDeBarra+Arreglo[2]+ArregloDeBarra+Arreglo[3]+ArregloDeEspacio+Hora+Arreglo[4]+ArregloDeDosPuntos+Arreglo[5]+ ArregloDeDosPuntos+Arreglo[6]+ArregloDeEspacio;
    
    return(BUFFER);
  }
  
  void Setter_Fecha()
  {
   // Crea una instancia de Calendar y establece la fecha actual
   Calendar calendario = Calendar.getInstance();
   Date fechaActual = new Date();  //variable para poder trabajar con el tiempo//
   calendario.setTime(fechaActual);
  
   anio = calendario.get(Calendar.YEAR);
   mes = calendario.get(Calendar.MONTH) + 1; // Los meses se indexan desde 0
   dia = calendario.get(Calendar.DAY_OF_MONTH);
   hora = calendario.get(Calendar.HOUR_OF_DAY);
   minutos = calendario.get(Calendar.MINUTE);
   segundos = calendario.get(Calendar.SECOND);
   }
  
};



//------------------------------------------------------------------------------------------------------------------------------------------------//





void setup() 
{
  
  size(542, 650); //establezco la dimension en pixeles de la pantalla//
  frameRate(90);
  fuente = createFont("Comic Sans MS", 24);
  textFont(fuente);
  textAlign(CENTER, CENTER);
  
  fondo=loadImage("plano.jpg");
  fondoMenu = loadImage("FondoMenu.jpg");
  

  
  //LEO DESDE EL ARCHIVO LO QUE TENGO GUARDADO Y LO CARGO EN EL BUFFER//
  list = loadStrings(filename);
  
  // Reinicio el Buffer
  Buffer = "";
  
  // Iterar sobre las líneas y agregarlas al Buffer
  for (String line : list) 
  {
    Buffer = Buffer + line + '-';
  }
  
  myPort = new Serial(this,"COM5", 11200);
  
}




//------------------------------------------------------------------------------------------------------------------------------------------------//
//PROGRAMA PRINCIPAL, LAZO INFINITO//

void draw() 
{
    
  if(Selector_Menu == 0)
  {
    //Dibujo los tres botones y coloco el fondo del programa//
    
    DibujarMenuPrincipal();
    
    //Verifico si estoy encima de algun boton y lo pinto de un color//
    
    if(mouseX > 30  &&  mouseX < 100+30  &&  mouseY > 100   && mouseY < 100+30 ) //¿estoy sobre IR?//
    {
      fill(220,240,255); 
      rect(30,100,100,30); 
      stroke(0);
      textSize(18);
      fill(0, 120, 200); 
      text("Ir",50,110);
    }
    else if (mouseX > 30  &&  mouseX < 100+30  &&  mouseY > 60  && mouseY < 60+30) //¿estoy sobre GUARDAR?//
    {
      fill(220,240,255); 
      rect(30,60,100,30); 
      stroke(0);
      textSize(18);
      fill(0); 
      text("Guardar",70,70);;
    }
    
    else if (mouseX > 30  &&  mouseX < 100+30  &&  mouseY > 140  && mouseY < 140+30) //¿estoy sobre REPLAY?//
    {
      fill(220,240,250); 
      rect(30,140,100,30); 
      stroke(0);
      textSize(18);
      fill(0); 
      text("Replay",70,150);
    
    }
    
    //VERIFICO SI ESTOY EN ALGUN BOTON Y ME HICIERON CLICK//
    
    if(enRect(30,140,100,30)==true && mousePressed) // si me hacen click en REPLAY voy al control de memoria//
    { 
      background(100);
      image(fondo,0,0);
      DibujarLuces();
      Selector_Menu=2;
      Contador=0;
      Pido_Primera_Vez = true; 
      BorroReplay=1;
    }
    
    if(enRect(30,100,100,30)==true && mousePressed) // si me hacen click en IR voy al control de las luces//
    {
      Selector_Menu = 1;
      Grafico_Menu=1;
      background(100);
      if(BorroReplay==1)
      {
            String MensajeBorrarBuff="BORRO\n";
            myPort.write(MensajeBorrarBuff); 
      }
      BorroReplay=0;
      
    }
    
    if(enRect(30,60,100,30)==true && mousePressed) // si me hacen click en GUARDAR guardo los datos del buffer//
    {
        list = split(Buffer, '-');
        saveStrings(filename,list); 
    } 
  }
  
  //-------------------------------SENTENCIAS PARA EL BOTON IR----------------------------------------------//
  
 if(Selector_Menu == 1) //si me seleccionaron IR//
 {
    if(Grafico_Menu==1)
    {
     image(fondo,0,0); // Coloco el fondo del plano de la casa//
   
     // DIBUJO LED 1 //
     
     if(MantenerPrendidoLed1==0)
     {
       fill(255);
       ellipse(160,100,40,40);
       stroke(0);
       textSize(18);
       fill(255,0,0);
       text("L1",160,100);
     }else{
          fill(0,230,0);
          ellipse(160,100,40,40);
          stroke(0);
          textSize(18);
          fill(255,0,0);
          text("L1",160,100); 
          }
          
   //DIBUJO LED 2 //
   
     if(MantenerPrendidoLed2==0)
     {
       fill(255);
       ellipse(160,230,40,40);
       stroke(0);
       textSize(18);
       fill(255,0,0);
       text("L2",160,230);
     }else{
          fill(10,190,10);
          ellipse(160,230,40,40);
          stroke(0);
          textSize(18);
          fill(255,0,0);
          text("L2",160,230);
     }
   
   //DIBUJO LED 3 //
  
     if(MantenerPrendidoLed3==0)
     {
       fill(255);
       ellipse(130,380,40,40);
       stroke(0);
       textSize(18);
       fill(255,0,0);
       text("L3",130,380); 
     } else{
           fill(10,190,10);
           ellipse(130,380,40,40);
           stroke(0);
           textSize(18);
           fill(255,0,0);
           text("L3",130,380);
     }
  
   //DIBUJO LED 4 //
   
     if(MantenerPrendidoLed4==0)
     {
       fill(255);
       ellipse(130,550,40,40);
       stroke(0);
       textSize(18);
       fill(255,0,0);
       text("L4",130,550);
     }else{
           fill(10,190,10);
           ellipse(130,550,40,40);
           stroke(0);
           textSize(18);
           fill(255,0,0);
           text("L4",130,550);
     }
   
   //DIBUJO LED 5 //
   
     if(MantenerPrendidoLed5==0)
     {
       fill(255);
       ellipse(335,475,30,30);
       stroke(0);
       textSize(14);
       fill(255,0,0);
       text("L5",335,475);
      }else{
           fill(10,190,10);
           ellipse(335,475,30,30);
           stroke(0);
           textSize(14);
           fill(255,0,0);
           text("L5",335,475);
      }
   
   //DIBUJO LED 6 //
   
      if(MantenerPrendidoLed6==0)
      {
        fill(255);
        ellipse(410,555,40,40);
        stroke(0);
        textSize(18);
        fill(255,0,0);
        text("L6",410,555);
       }else{
             fill(10,190,10);
             ellipse(410,555,40,40);
             stroke(0);
             textSize(18);
             fill(255,0,0);
             text("L6",410,555);  
       }
   
   //DIBUJO LED 7 //
   
       if(MantenerPrendidoLed7==0)
       {
         fill(255);
         ellipse(430,360,40,40);
         stroke(0);
         textSize(18);
         fill(255,0,0);
         text("L7",430,360);
       }else{
             fill(10,190,10);
             ellipse(430,360,40,40);
             stroke(0);
             textSize(18);
             fill(255,0,0);
             text("L7",430,360);
       }
   
   // DIBUJO SENSOR 1 //
   
   fill(255); 
   ellipse(-8+width/2,600,50,30); 
   stroke(0);
   textSize(18);
   fill(255,0,0); 
   text("S1",-8+width/2,600); 
   
   // DIBUJO SENSOR 2 //
   
   fill(255); 
   ellipse(width-80,150,50,30); 
   stroke(0);
   textSize(18);
   fill(255,0,0); 
   text("S2",width-80,150); 
   
   Grafico_Menu=0;// Actualizo Grafico_Menu para que cuando Aprete voler y Ir de nuevo no me sobreescriba todo
    
   }//Fin if de grafico menu//
   
   //DIBUJO EL BOTON VOLVER//
   
   fill(255); 
   rect(30,40,100,30); 
   stroke(0);
   textSize(18);
   fill(255,0,0); 
   text("Volver",70,50);
  
   //-----------------------VERIFICO QUE HAGAN CLICK EN ALGUN BOTON DE LOS DIBUJADOS------------------------------//
   
   //BOTON LED 1//
  
   if(enElipse(160,100,40,40)==true && mousePressed)
   {
      
     if(CambioDeColor1==true)
      {
        //Marco como encendido el LED1//
        fill(0,230,0);
        ellipse(160,100,40,40);
        stroke(0);
        textSize(18);
        fill(255,0,0);
        text("L1",160,100); 
        
        MantenerPrendidoLed1=1;
        
        //Comunico al arduino el evento//
        MensajeEscritura="LE1";
        myPort.write(MensajeEscritura);
        
        //Declaro un arreglo de objetos para guardar todos los elementos de nuestro sistema//
        Dispositivos[] LED = new Dispositivos[9]; 
        LED[0] = new Dispositivos();
        Buffer = Encender_Y_Apagar(LED[0],EncenderLed,1,Buffer);
      }else{ 
            //Sino, lo dejo blanco al fondo como que no se presiono//
            fill(255);
            ellipse(160,100,40,40);
            stroke(0);
            textSize(18);
            fill(255,0,0);
            text("L1",160,100); 
            
            MantenerPrendidoLed1=0;
            
            //Comunico el evento a arduino//
            MensajeEscritura="LA1";
            myPort.write(MensajeEscritura);
            
            //Declaro un arreglo de objetos para guardar todos los elementos de nuestro sistema//
            Dispositivos[] LED = new Dispositivos[9];
            LED[0] = new Dispositivos();
            Buffer = Encender_Y_Apagar(LED[0],ApagarLed,1,Buffer);
            }
            
        delay(150);
        CambioDeColor1=!CambioDeColor1;
    }//Fin Click BOTON LED 1//
   
   //BOTON LED 2//
   
    if(enElipse(160,230,40,40)==true && mousePressed)
    {
     if (CambioDeColor2==true) 
     {
        //Color verde de encendido//
        fill(10,190,10);
        ellipse(160,230,40,40);
        stroke(0);
        textSize(18);
        fill(255,0,0);
        text("L2",160,230);
        
        MantenerPrendidoLed2=1;
        
        //Comunico el evento a arduino//
        MensajeEscritura="LE2";
        myPort.write(MensajeEscritura);
       
        //Guardo en el arreglo de objetos//
        Dispositivos[] LED = new Dispositivos[9]; 
        LED[1] = new Dispositivos();
        Buffer = Encender_Y_Apagar(LED[1],EncenderLed,2,Buffer);
         
      }else{
            //Esta apagado//
            fill(255);
            ellipse(160,230,40,40);
            stroke(0);
            textSize(18);
            fill(255,0,0);
            text("L2",160,230);
            
            MantenerPrendidoLed2=0;
            
            //Comunico el evento a arduino//
            MensajeEscritura="LA2";
            myPort.write(MensajeEscritura);
            
            //Guardo en arreglo de objetos//
            Dispositivos[] LED = new Dispositivos[9]; 
            LED[1] = new Dispositivos();
            Buffer = Encender_Y_Apagar(LED[1],ApagarLed,2,Buffer);
            }
            
    delay(150);
    CambioDeColor2=!CambioDeColor2;
   }//Fin Click BOTON LED 2//
   
   // BOTON LED 3// 
   
   if(enElipse(130,380,40,40)==true && mousePressed)
   {
     if (CambioDeColor3==true) 
     {
        //Color verde de encendido// 
        fill(10,190,10);
        ellipse(130,380,40,40);
        stroke(0);
        textSize(18);
        fill(255,0,0);
        text("L3",130,380);
        
        MantenerPrendidoLed3=1;
        
        //Comunico el evento a arduino//
        MensajeEscritura="LE3";
        myPort.write(MensajeEscritura);
        
        //Guardo en el arreglo de objetos//
        Dispositivos[] LED = new Dispositivos[9]; 
        LED[2] = new Dispositivos();
        Buffer = Encender_Y_Apagar(LED[2],EncenderLed,3,Buffer);
      }else{
            //Esta apagado//
            fill(255);
            ellipse(130,380,40,40);
            stroke(0);
            textSize(18);
            fill(255,0,0);
            text("L3",130,380);
            
            MantenerPrendidoLed3=0;
            
            //Comunico el evento a arduino//
            MensajeEscritura="LA3";
            myPort.write(MensajeEscritura);
            
            //Guardo en un arreglo de objetos//
            Dispositivos[] LED = new Dispositivos[9]; 
            LED[2] = new Dispositivos();
            Buffer = Encender_Y_Apagar(LED[2],ApagarLed,3,Buffer);
            }
            
     delay(150);
     CambioDeColor3=!CambioDeColor3;
   }//Fin Click BOTON LED 3//
   
   // BOTON DE LED 4
   
   if(enElipse(130,550,40,40)==true && mousePressed)
   {
     if (CambioDeColor4==true) 
     {
        //Color verde de encendido//
        fill(10,190,10);
        ellipse(130,550,40,40);
        stroke(0);
        textSize(18);
        fill(255,0,0);
        text("L4",130,550);
        
        MantenerPrendidoLed4=1;
        
        //Comunico el evento a arduino//
        MensajeEscritura="LE4";
        myPort.write(MensajeEscritura);
            
        //Guardo en un arreglo de objetos//    
        Dispositivos[] LED = new Dispositivos[9]; 
        LED[3] = new Dispositivos();
        Buffer = Encender_Y_Apagar(LED[3],EncenderLed,4,Buffer);    
      }else{
            //Esta apagado//
            fill(255);
            ellipse(130,550,40,40);
            stroke(0);
            textSize(18);
            fill(255,0,0);
            text("L4",130,550);
            
            MantenerPrendidoLed4=0;
            
            //Comunico el evento a arduino//
            MensajeEscritura="LA4";
            myPort.write(MensajeEscritura);
            
            //Guardo en un arreglo de objetos//
            Dispositivos[] LED = new Dispositivos[9]; 
           
            LED[3] = new Dispositivos();
            Buffer = Encender_Y_Apagar(LED[3],ApagarLed,4,Buffer);
            }
            
     delay(150);
     CambioDeColor4=!CambioDeColor4;
   }//Fin Click BOTON LED 4//
   
   //BOTON  LED 5//
   
   if(enElipse(335,475,30,30)==true && mousePressed)
   {
     if (CambioDeColor5==true) 
     {
         //Color verde de encendido//
         fill(10,190,10);
         ellipse(335,475,30,30);
         stroke(0);
         textSize(14);
         fill(255,0,0);
         text("L5",335,475);
         
         MantenerPrendidoLed5=1;
         
         //Comunico el evento a arduino//
         MensajeEscritura="LE5";
         myPort.write(MensajeEscritura);
         
         //Guardo en un arreglo de objetos//
         Dispositivos[] LED = new Dispositivos[9]; 
         LED[4] = new Dispositivos();
         Buffer = Encender_Y_Apagar(LED[4],EncenderLed,5,Buffer);
         
      }else{
            fill(255);
            ellipse(335,475,30,30);
            stroke(0);
            textSize(14);
            fill(255,0,0);
            text("L5",335,475);
            
            MantenerPrendidoLed5=0; 
            
            //Comunico el evento a arduino//
            MensajeEscritura="LA5";
            myPort.write(MensajeEscritura);
            
            //Guardo en un arreglo de objetos//
            Dispositivos[] LED = new Dispositivos[9]; 
            LED[4] = new Dispositivos();
            Buffer = Encender_Y_Apagar(LED[4],ApagarLed,5,Buffer);
            }
            
     delay(150);
     CambioDeColor5=!CambioDeColor5;
   }//Fin Click BOTON LED 5//
   
   //BOTON LED 6//
   
   if(enElipse(410,555,40,40)==true && mousePressed)
   {
     if (CambioDeColor6==true) 
     {
         //Color verde de encendido//
         fill(10,190,10);
         ellipse(410,555,40,40);
         stroke(0);
         textSize(18);
         fill(255,0,0);
         text("L6",410,555);
         
         MantenerPrendidoLed6=1;
         
         //Comunico el evento a arduino//
         MensajeEscritura="LE6";
         myPort.write(MensajeEscritura);
            
         //Guardo en un arreglo de objetos//   
         Dispositivos[] LED = new Dispositivos[9]; 
         LED[5] = new Dispositivos();
         Buffer = Encender_Y_Apagar(LED[5],EncenderLed,6,Buffer);
         
      }else{
            //Esta apagado//
            fill(255);
            ellipse(410,555,40,40);
            stroke(0);
            textSize(18);
            fill(255,0,0);
            text("L6",410,555);
            
            MantenerPrendidoLed6=0;    
            
            //Comunico el evento a arduino//
            MensajeEscritura="LA6";
            myPort.write(MensajeEscritura);
            
            //Guardo en un arreglo de objetos//
            Dispositivos[] LED = new Dispositivos[9];   
            LED[5] = new Dispositivos();
            Buffer = Encender_Y_Apagar(LED[5],ApagarLed,6,Buffer);
            }
            
     delay(150);
     CambioDeColor6=!CambioDeColor6;
   }//Fin CLick BOTON LED 6//
   
   //BOTON LED 7//
   
   if(enElipse(430,360,40,40)==true && mousePressed)
   {
     if (CambioDeColor7==true) 
     {
         //Color verde de encendido//
         fill(10,190,10);
         ellipse(430,360,40,40);
         stroke(0);
         textSize(18);
         fill(255,0,0);
         text("L7",430,360);
         
         MantenerPrendidoLed7=1;
        
         //Comunico el evento a arduino//
         MensajeEscritura="LE7";
         myPort.write(MensajeEscritura);
            
         //Guardo en un arreglo de objetos//
         Dispositivos[] LED = new Dispositivos[9]; 
         LED[6] = new Dispositivos();
         Buffer = Encender_Y_Apagar(LED[6],EncenderLed,7,Buffer);
      }else{
            fill(255);
            ellipse(430,360,40,40);
            stroke(0);
            textSize(18);
            fill(255,0,0);
            text("L7",430,360);
            
            MantenerPrendidoLed7=0;   
            
            //Comunico el evento a arduino//
            MensajeEscritura="LA7";
            myPort.write(MensajeEscritura);
            
            //Guardo en un arreglo de objetos//
            Dispositivos[] LED = new Dispositivos[9]; 
            LED[6] = new Dispositivos();
            Buffer = Encender_Y_Apagar(LED[6],ApagarLed,7,Buffer);
            }
            
     delay(150);
     CambioDeColor7=!CambioDeColor7;
   }//Fin Click BOTON 7//
   
   //-------------------------------VERIFICO LA SEÑAL DE ARDUINO--------------------------------//
   
   if(myPort.available()>0)
   {   
             MensajeLectura=myPort.readStringUntil('\n');
             
             if(MensajeLectura!=null)
             {
             
             //CONTROL DE LED 1 CON ARDUINO//
             
                 if(MensajeLectura.compareTo("LE1\n")==0)
                 {
                  //Color verde de encendido//
                  fill(0,230,0);
                  ellipse(160,100,40,40);
                  stroke(0);
                  textSize(18);
                  fill(255,0,0);
                  text("L1",160,100); 
                  
                  MantenerPrendidoLed1=1;
                  
                  Dispositivos[] LED = new Dispositivos[9]; 
                  LED[0] = new Dispositivos();
                  Buffer = Encender_Y_Apagar(LED[0],EncenderLed,1,Buffer);
                  
                      if(CambioDeColor1==true)
                      {
                        CambioDeColor1=!CambioDeColor1;
                      }
                 }
                 
                 if(MensajeLectura.compareTo("LA1\n")==0)
                 {
                    //Esta apagado//
                    fill(255);
                    ellipse(160,100,40,40);
                    stroke(0);
                    textSize(18);
                    fill(255,0,0);
                    text("L1",160,100); 
                    
                    MantenerPrendidoLed1=0; 
                    
                    Dispositivos[] LED = new Dispositivos[9];
                    LED[0] = new Dispositivos();
                    Buffer = Encender_Y_Apagar(LED[0],ApagarLed,1,Buffer);
                      
                      if(CambioDeColor1==false)
                      {
                        CambioDeColor1=!CambioDeColor1;
                      }
                 }//Fin Control LED 1//
                 
                 
             //CONTROL DE LED 2 CON ARDUINO// 
             
                 if(MensajeLectura.compareTo("LE2\n")==0)
                 {
                  //Color verde de encendido//
                  fill(10,190,10);
                  ellipse(160,230,40,40);
                  stroke(0);
                  textSize(18);
                  fill(255,0,0);
                  text("L2",160,230);
                  
                  MantenerPrendidoLed2=1;
                  
                  Dispositivos[] LED = new Dispositivos[9]; //Declaro un arreglo de objetos para guardar todos los elementos de nuestro sistema//
                  LED[1] = new Dispositivos();
                  Buffer = Encender_Y_Apagar(LED[1],EncenderLed,2,Buffer);
                      
                      if(CambioDeColor2==true)
                      {
                        CambioDeColor2=!CambioDeColor2;
                      }
                 }
                 
                 if(MensajeLectura.compareTo("LA2\n")==0)
                 {
                    //Esta apagado//
                    fill(255);
                    ellipse(160,230,40,40);
                    stroke(0);
                    textSize(18);
                    fill(255,0,0);
                    text("L2",160,230);
                    
                    MantenerPrendidoLed2=0;  
                    
                    Dispositivos[] LED = new Dispositivos[9];
                    LED[1] = new Dispositivos();
                    Buffer = Encender_Y_Apagar(LED[1],ApagarLed,2,Buffer);
                    
                      if(CambioDeColor2==false)
                      {
                        CambioDeColor2=!CambioDeColor2;
                      }
                  }//Fin Control LED 2//
                 
                 
             //CONTROL DE LED 3 CON ARDUINO// 
             
                 if(MensajeLectura.compareTo("LE3\n")==0)
                 {
                  //Color verde de encendido//
                  fill(10,190,10);
                  ellipse(130,380,40,40);
                  stroke(0);
                  textSize(18);
                  fill(255,0,0);
                  text("L3",130,380);
                  
                  MantenerPrendidoLed3=1;
                  
                  Dispositivos[] LED = new Dispositivos[9]; 
                  LED[2] = new Dispositivos();
                  Buffer = Encender_Y_Apagar(LED[2],EncenderLed,3,Buffer);
                      
                      if(CambioDeColor3==true)
                      {
                        CambioDeColor3=!CambioDeColor3;
                      }
                  }
                 
                  if(MensajeLectura.compareTo("LA3\n")==0)
                  {
                   //Esta apagado//
                   fill(255);
                   ellipse(130,380,40,40);
                   stroke(0);
                   textSize(18);
                   fill(255,0,0);
                   text("L3",130,380);
                   
                   MantenerPrendidoLed3=0;  
                   
                   Dispositivos[] LED = new Dispositivos[9];
                   LED[2] = new Dispositivos();
                   Buffer = Encender_Y_Apagar(LED[2],ApagarLed,3,Buffer);
                    
                      if(CambioDeColor3==false)
                      {
                        CambioDeColor3=!CambioDeColor3;
                      }
                  }//Fin Control LED 3//     
                 
             //CONTROL DE LED 4 CON ARDUINO// 
             
                 if(MensajeLectura.compareTo("LE4\n")==0)
                 {
                  //Color verde de encendido//
                  fill(10,190,10);
                  ellipse(130,550,40,40);
                  stroke(0);
                  textSize(18);
                  fill(255,0,0);
                  text("L4",130,550);
                  
                  MantenerPrendidoLed4=1;
                  
                  Dispositivos[] LED = new Dispositivos[9]; 
                  LED[3] = new Dispositivos();
                  Buffer = Encender_Y_Apagar(LED[3],EncenderLed,4,Buffer);
                      
                      if(CambioDeColor4==true)
                      {
                        CambioDeColor4=!CambioDeColor4;
                      }
                  }
                 
                  if(MensajeLectura.compareTo("LA4\n")==0)
                  {
                   //Esta apagado//
                   fill(255);
                   ellipse(130,550,40,40);
                   stroke(0);
                   textSize(18);
                   fill(255,0,0);
                   text("L4",130,550);
                   
                   MantenerPrendidoLed4=0;  
                   
                   Dispositivos[] LED = new Dispositivos[9];
                   LED[3] = new Dispositivos();
                   Buffer = Encender_Y_Apagar(LED[3],ApagarLed,4,Buffer);
                    
                      if(CambioDeColor4==false)
                      {
                        CambioDeColor4=!CambioDeColor4;
                      }
                  }//Fin Control LED 4//    
                 
             //CONTROL DE LED 5 CON ARDUINO// 
             
                 if(MensajeLectura.compareTo("LE5\n")==0)
                 {
                  //Color verde de encendido//
                  fill(10,190,10);
                  ellipse(335,475,30,30);
                  stroke(0);
                  textSize(14);
                  fill(255,0,0);
                  text("L5",335,475);
                  
                  MantenerPrendidoLed5=1;
                  
                  Dispositivos[] LED = new Dispositivos[9]; 
                  LED[4] = new Dispositivos();
                  Buffer = Encender_Y_Apagar(LED[4],EncenderLed,5,Buffer);
                      
                      if(CambioDeColor5==true)
                      {
                        CambioDeColor5=!CambioDeColor5;
                      }
                  }
                 
                  if(MensajeLectura.compareTo("LA5\n")==0)
                  {
                   //Esta apagado//
                   fill(255);
                   ellipse(335,475,30,30);
                   stroke(0);
                   textSize(14);
                   fill(255,0,0);
                   text("L5",335,475);
                   
                   MantenerPrendidoLed5=0;  
                   
                   Dispositivos[] LED = new Dispositivos[9];
                   LED[4] = new Dispositivos();
                   Buffer = Encender_Y_Apagar(LED[4],ApagarLed,5,Buffer);
                    
                      if(CambioDeColor5==false)
                      {
                        CambioDeColor5=!CambioDeColor5;
                      }
                  }//Fin Control LED 5//    
                 
               //CONTROL DE LED 6 CON ARDUINO// 
             
                 if(MensajeLectura.compareTo("LE6\n")==0)
                 {
                  //Color verde de encendido//
                  fill(10,190,10);
                  ellipse(410,555,40,40);
                  stroke(0);
                  textSize(18);
                  fill(255,0,0);
                  text("L6",410,555);
                  
                  MantenerPrendidoLed6=1;
                  
                  Dispositivos[] LED = new Dispositivos[9]; 
                  LED[5] = new Dispositivos();
                  Buffer = Encender_Y_Apagar(LED[5],EncenderLed,6,Buffer);
                      
                      if(CambioDeColor6==true)
                      {
                        CambioDeColor6=!CambioDeColor6;
                      }
                  }
                 
                  if(MensajeLectura.compareTo("LA6\n")==0)
                  {
                  //Esta apagado//
                   fill(255);
                   ellipse(410,555,40,40);
                   stroke(0);
                   textSize(18);
                   fill(255,0,0);
                   text("L6",410,555);
                   
                   MantenerPrendidoLed6=0;  
                   
                   Dispositivos[] LED = new Dispositivos[9];
                   LED[5] = new Dispositivos();
                   Buffer = Encender_Y_Apagar(LED[5],ApagarLed,6,Buffer);
                    
                      if(CambioDeColor6==false)
                      {
                        CambioDeColor6=!CambioDeColor6;
                      }
                  }//Fin Control LED 6//    
                 
                //CONTROL DE LED 7 CON ARDUINO// 
             
                 if(MensajeLectura.compareTo("LE7\n")==0)
                 {
                  //Color verde de encendido//
                  fill(10,190,10);
                  ellipse(430,360,40,40);
                  stroke(0);
                  textSize(18);
                  fill(255,0,0);
                  text("L7",430,360);
                  
                  MantenerPrendidoLed7=1;
                  
                  Dispositivos[] LED = new Dispositivos[9]; 
                  LED[6] = new Dispositivos();
                  Buffer = Encender_Y_Apagar(LED[6],EncenderLed,7,Buffer);
                      
                      if(CambioDeColor7==true)
                      {
                        CambioDeColor7=!CambioDeColor7;
                      }
                  }
                 
                  if(MensajeLectura.compareTo("LA7\n")==0)
                  {
                   //Esta apagado//
                   fill(255);
                   ellipse(430,360,40,40);
                   stroke(0);
                   textSize(18);
                   fill(255,0,0);
                   text("L7",430,360);
                   
                   MantenerPrendidoLed7=0;  
                   
                   Dispositivos[] LED = new Dispositivos[9];
                   LED[6] = new Dispositivos();
                   Buffer = Encender_Y_Apagar(LED[6],ApagarLed,7,Buffer);
                    
                      if(CambioDeColor7==false)
                      {
                        CambioDeColor7=!CambioDeColor7;
                      }
                  }//Fin Control LED 7//    
                  
                 
                // CONTROL DEL SENSOR 1 CON ARDUINO//
                
                 if(MensajeLectura.compareTo("SE1\n")==0)
                 {
                   //Color verde de encendido//
                   fill(0,190,10); 
                   ellipse(-8+width/2,600,50,30); 
                   stroke(0);
                   textSize(18);
                   fill(255,0,0); 
                   text("S1",-8+width/2,600); 
                   
                   Dispositivos[] LED = new Dispositivos[9]; //Declaro un arreglo de objetos para guardar todos los elementos de nuestro sistema//
                   LED[7] = new Dispositivos();
                   Buffer = Encender_Y_Apagar_Sensor(LED[7],EncenderSensor,1,Buffer);
                 }
                 
                 if(MensajeLectura.compareTo("SA1\n")==0)
                 {
                   //Esta apagado//
                   fill(255); 
                   ellipse(-8+width/2,600,50,30); 
                   stroke(0);
                   textSize(18);
                   fill(255,0,0); 
                   text("S1",-8+width/2,600); 
                   
                   Dispositivos[] LED = new Dispositivos[9]; //Declaro un arreglo de objetos para guardar todos los elementos de nuestro sistema//
                   LED[7] = new Dispositivos();
                   Buffer = Encender_Y_Apagar_Sensor(LED[7],ApagarSensor,1,Buffer);
                 }//Fin Control SENSOR 1//
                 
                 
                // CONTROL DEL SENSOR 2 CON ARDUINO//
                
                 if(MensajeLectura.compareTo("SE2\n")==0)
                 {
                   //Color verde de encendido//
                   fill(0,190,10); 
                   ellipse(width-80,150,50,30); 
                   stroke(0);
                   textSize(18);
                   fill(255,0,0); 
                   text("S2",width-80,150); 
                   
                   Dispositivos[] LED = new Dispositivos[9]; //Declaro un arreglo de objetos para guardar todos los elementos de nuestro sistema//
                   LED[8] = new Dispositivos();
                   Buffer = Encender_Y_Apagar_Sensor(LED[8],EncenderSensor,2,Buffer);
                 }
                 
                 if(MensajeLectura.compareTo("SA2\n")==0)
                 {
                   //Esta apagado//
                   fill(255); 
                   ellipse(width-80,150,50,30); 
                   stroke(0);
                   textSize(18);
                   fill(255,0,0); 
                   text("S2",width-80,150); 
                   
                   Dispositivos[] LED = new Dispositivos[9]; //Declaro un arreglo de objetos para guardar todos los elementos de nuestro sistema//
                   LED[8] = new Dispositivos();
                   Buffer = Encender_Y_Apagar_Sensor(LED[8],ApagarSensor,2,Buffer);
                 }//Fin Control SENSOR 2//
                              
     
      }//fin if de mensaje lectura es distinto de null// 
      
   }//Fin de if de serial.avilable()//
   
   //SI ESTOY SOBRE EL BOTON VOLVER LO MARCO CON UN COLOR DISTINTO//
   
   if(mouseX > 30  &&  mouseX < 100+30  &&  mouseY > 40  && mouseY < 40+30 )
   {
     fill(100,100,250); 
     rect(30,40,100,30); 
     stroke(0);
     textSize(18);
     fill(255,0,0); 
     text("Volver",70,50);
   }
   
   //SI ME HACEN CLICK EN EL BOTON VOLVER, VUELVO//
   
   if(enRect(30,40,100,30) == true && mousePressed)
   {
     Selector_Menu = 0; //vuelvo al menu principal//
     background(100);
   }
   
 }//Fin Selector_Menu=0, fin de sentencias para el BOTON IR//
 
 
 //-------------------------SENTENCIAS PARA BOTON REPLAY---------------------------------------//

   if(Selector_Menu == 2)
       {
            if(Pido_Primera_Vez == true)
            {
            
              String MensajeBuffer="BUF\n";
              myPort.write(MensajeBuffer); //Envio a arduino la palabra BUF para que me pase lo que ha guardado en su memoria//
              
              delay(300);
              
              MensajeReciboBuffer=myPort.readStringUntil('\n');  //Recibo una cadena con toda la informacion de arduino//
              DividirReplayGeneral = split(MensajeReciboBuffer, '?'); //Separo la cadena en dos, es decir, del ? para atras estan las acciones y para adelante el tiempo//
              
              if(MensajeReciboBuffer!=null)
              {
                DividirReplayAcciones=split(DividirReplayGeneral[0],'-'); //Separo las acciones en una lista//
                DividirReplayTiempo=split(DividirReplayGeneral[1],'-'); //Separo el tiempo en una lista//
              }
              
              Pido_Primera_Vez = false; //Variable para evitar pedirle informacion a arduino de manera repetitiva//
           
            }

            if(MensajeReciboBuffer!=null)
            {
           
              if(Contador <= DividirReplayAcciones.length-1)
              {          
               Delay = int (DividirReplayTiempo[Contador]); //Convierto el tiempo que envió el arduino tipo String a un Entero y lo guardo en Delay.Luego lo uso en cada evento//
               
               //Como ya dibuje el fondo y las luces cuando hicieron click en replay, solo verifico y las pongo en verde//
               
               //¿Se encendió el LED 1//
               
               if(DividirReplayAcciones[Contador].compareTo("LE1")==0)
               {
                 //Color verde de encendido//
                 fill(10,190,10);
                 ellipse(160,100,40,40);
                 stroke(0);
                 textSize(18);
                 fill(255,0,0);
                 text("L1",160,100);
                 delay(Delay);
               }
               
               //¿Se apago el LED 1//
             
               if(DividirReplayAcciones[Contador].compareTo("LA1")==0)
               {
                 //Esta apagado//
                 fill(255);
                 ellipse(160,100,40,40);
                 stroke(0);
                 textSize(18);
                 fill(255,0,0);
                 text("L1",160,100);
                 delay(Delay);
               }
               
               //¿Se encendio el LED 2?//
               
               if(DividirReplayAcciones[Contador].compareTo("LE2")==0)
               {
                 //Color verde de encendido//
                 fill(10,190,10);
                 ellipse(160,230,40,40);
                 stroke(0);
                 textSize(18);
                 fill(255,0,0);
                 text("L2",160,230);  
                 delay(Delay);
               }
               
               //¿Se apagó el LED 2?
             
               if(DividirReplayAcciones[Contador].compareTo("LA2")==0)
               {
                 //Esta apagado//
                 fill(255);
                 ellipse(160,230,40,40);
                 stroke(0);
                 textSize(18);
                 fill(255,0,0);
                 text("L2",160,230);
                 delay(Delay);
               }
               
               //¿Se prendio el LED 3?//
               
               if(DividirReplayAcciones[Contador].compareTo("LE3")==0)
               {
                 //Color verde de encendido//
                 fill(10,190,10);
                 ellipse(130,380,40,40);
                 stroke(0);
                 textSize(18);
                 fill(255,0,0);
                 text("L3",130,380);
                 delay(Delay);
               }
               
               //¿Se apago el LED 3?//
               
               if(DividirReplayAcciones[Contador].compareTo("LA3")==0)
               {
                 //Esta apagado//
                 fill(255);
                 ellipse(130,380,40,40);
                 stroke(0);
                 textSize(18);
                 fill(255,0,0);
                 text("L3",130,380);
                 delay(Delay);
               }
               
                //¿Se prendio el LED 4?//
               
               if(DividirReplayAcciones[Contador].compareTo("LE4")==0)
               {
                 //Color verde de encendido//
                 fill(10,190,10);
                 ellipse(130,550,40,40);
                 stroke(0);
                 textSize(18);
                 fill(255,0,0);
                 text("L4",130,550);
                 delay(Delay);
               }
               
               //¿Se apago el LED 4?//
               
               if(DividirReplayAcciones[Contador].compareTo("LA4")==0)
               {
                 //Esta apagado//
                 fill(255);
                 ellipse(130,550,40,40);
                 stroke(0);
                 textSize(18);
                 fill(255,0,0);
                 text("L4",130,550);
                 delay(Delay);
               }
               
               //¿Se prendio el LED 5?//
               
               if(DividirReplayAcciones[Contador].compareTo("LE5")==0)
               {
                  //Color verde de encendido//
                  fill(10,190,10);
                  ellipse(335,475,30,30);
                  stroke(0);
                  textSize(14);
                  fill(255,0,0);
                  text("L5",335,475);
                  delay(Delay);
               }
               
               //¿Se apago el LED 5?//
               
               if(DividirReplayAcciones[Contador].compareTo("LA5")==0)
               {
                  //Esta apagado//
                  fill(255);
                  ellipse(335,475,30,30);
                  stroke(0);
                  textSize(14);
                  fill(255,0,0);
                  text("L5",335,475);
                  delay(Delay);
               }
               
               //¿Se prendio el LED 6?//
               
               if(DividirReplayAcciones[Contador].compareTo("LE6")==0)
               {
                  //Color verde de encendido//
                  fill(10,190,10);
                  ellipse(410,555,40,40);
                  stroke(0);
                  textSize(18);
                  fill(255,0,0);
                  text("L6",410,555);
                  delay(Delay);
               }
               
               //¿Se apago el LED 6?//
               
               if(DividirReplayAcciones[Contador].compareTo("LA6")==0)
               {
                  //Esta apagado//
                  fill(255);
                  ellipse(410,555,40,40);
                  stroke(0);
                  textSize(18);
                  fill(255,0,0);
                  text("L6",410,555);
                  delay(Delay);
               }
               
               //¿Se prendio el LED 7?//
               
               if(DividirReplayAcciones[Contador].compareTo("LE7")==0)
               {
                  //Color verde de encendido//
                  fill(10,190,10);
                  ellipse(430,360,40,40);
                  stroke(0);
                  textSize(18);
                  fill(255,0,0);
                  text("L7",430,360);
                  delay(Delay);
               }
               
               //¿Se apago el LED 7?//
               
               if(DividirReplayAcciones[Contador].compareTo("LA7")==0)
               {
                  //Esta apagado//
                  fill(255);
                  ellipse(430,360,40,40);
                  stroke(0);
                  textSize(18);
                  fill(255,0,0);
                  text("L7",430,360);
                  delay(Delay);
               }
               
               //¿El SENSOR 1 detectó movimiento?//
               
               if(DividirReplayAcciones[Contador].compareTo("SE1")==0)
               {
                  //Color verde de encendido//
                  fill(10,190,10);
                  ellipse(-8+width/2,600,50,30); 
                  stroke(0);
                  textSize(18);
                  fill(255,0,0); 
                  text("S1",-8+width/2,600); 
                  delay(Delay);
               }
               
               //¿El SENSOR 1 dejó de detectar movimiento?//
             
               if(DividirReplayAcciones[Contador].compareTo("SA1")==0)
               {
                  fill(255); 
                  ellipse(-8+width/2,600,50,30); 
                  stroke(0);
                  textSize(18);
                  fill(255,0,0); 
                  text("S1",-8+width/2,600); 
                  delay(Delay);
                }
                
               //¿El SENSOR 2 detecto movimiento?//
             
               if(DividirReplayAcciones[Contador].compareTo("SE2")==0)
               {
                   fill(0,190,10); 
                   ellipse(width-80,150,50,30); 
                   stroke(0);
                   textSize(18);
                   fill(255,0,0); 
                   text("S2",width-80,150); 
                   delay(Delay);
                }
                
               //¿El SENSOR 2 dejó de detectar movimiento?//
             
               if(DividirReplayAcciones[Contador].compareTo("SA2")==0)
               {
                  fill(255); 
                  ellipse(width-80,150,50,30); 
                  stroke(0);
                  textSize(18);
                  fill(255,0,0); 
                  text("S2",width-80,150);  
                  delay(Delay);
                }
                Contador++;
                  
             } //Fin de if del contador, llegamos al final de los hechos//  
             
            } //Fin de if de si el buffer(mensaje recibido) es null// 
       
            //DIBUJO EL BOTON VOLVER//
         
            fill(255); 
            rect(30,40,100,30); 
            stroke(0);
            textSize(18);
            fill(255,0,0); 
            text("Volver",70,50);
           
            //SI ESTOY SOBRE EL BOTON VOLVER LO MARCO CON UN COLOR DISTINTO//
         
            if(mouseX > 30  &&  mouseX < 100+30  &&  mouseY > 40  && mouseY < 40+30 )
            {
              fill(100,100,250); 
              rect(30,40,100,30); 
              stroke(0);
              textSize(18);
              fill(255,0,0); 
              text("Volver",70,50);
            }
         
            //SI ME HACEN CLICK EN EL BOTON VOLVER, VUELVO AL MENU PRINCIPAL//
         
            if(enRect(30,40,100,30) == true && mousePressed)
            {
              Selector_Menu = 0; //vuelvo al menu principal//
              background(100);
            }
       } //Fin de if de selector_menu=2, fin sentencias para el boton REPLAY//

 
} //FIN VOID LOOP()//


//------------------------------------------------------------------------------------------------------------------------------------------------//
//FUNCIONES CREADAS POR NOSOTROS PARA EL FUNCIONAMIENTO//

//Funcion que detecta si estoy dentro de un rectangulo o cuadrado con el puntero del mause//

boolean enRect(int x, int y, int ancho, int alto)  
{
  if (mouseX >= x && mouseX <= x+ancho &&  mouseY >= y && mouseY <= y+alto) 
      {
        return true;
      } 
      else 
      {
        return false;
      }
}

//Funcion que detecta si estoy dentro de un circulo o elipse//

boolean enElipse(int x, int y, int a, int b) {
    // Calcula la distancia desde el centro de la elipse (x, y) al cursor del mouse (mouseX, mouseY).
    float distancia = dist(x, y, mouseX, mouseY);

    // Verifica si la distancia es menor o igual a la mitad del ancho (a) de la elipse y la mitad de la altura (b).
    if (distancia <= a && distancia <= b) {
        return true;
    } else {
        return false;
    }
}

//Funcion usada para ir guardando los eventos que suceden en cada uno de los dispositivos declarados como luces//

String Encender_Y_Apagar(Dispositivos Objeto,int On_Off, int Cual_Objeto,String BUFFER)
{
  switch(On_Off)
  {
    case 1: 
            Objeto.Evento="Se encendio el LED ";
            Objeto.Setter_Fecha();
            BUFFER=BUFFER+Objeto.Convertir_A_Cadena_Y_Concatenar(Objeto.anio,Objeto.mes,Objeto.dia,Objeto.hora,Objeto.minutos,Objeto.segundos,BUFFER);
            BUFFER = BUFFER + Objeto.Evento + Cual_Objeto + "-";
            break;
            
    case 2:  
            Objeto.Evento="Se apagó el LED ";
            Objeto.Setter_Fecha();
            BUFFER=BUFFER+Objeto.Convertir_A_Cadena_Y_Concatenar(Objeto.anio,Objeto.mes,Objeto.dia,Objeto.hora,Objeto.minutos,Objeto.segundos,BUFFER);
            BUFFER = BUFFER + Objeto.Evento + Cual_Objeto + "-";
            break;
            
    default:break;
      
  }
  return(BUFFER);
}

//FUncion usada para ir guardando los eventos que suceden en cada uno de los dispositivos declarados como sensores//

String Encender_Y_Apagar_Sensor(Dispositivos Objeto,int On_Off, int Cual_Objeto,String BUFFER)
{
  switch(On_Off)
  {
    case 1: 
            Objeto.Evento="Se detecto movimiento en el sensor ";
            Objeto.Setter_Fecha();
            BUFFER=BUFFER+Objeto.Convertir_A_Cadena_Y_Concatenar(Objeto.anio,Objeto.mes,Objeto.dia,Objeto.hora,Objeto.minutos,Objeto.segundos,BUFFER);
            BUFFER = BUFFER + Objeto.Evento + Cual_Objeto + "-";
            break;
            
    case 2:  
            Objeto.Evento="Dejo de detectar movimiento en el sensor ";
            Objeto.Setter_Fecha();
            BUFFER=BUFFER+Objeto.Convertir_A_Cadena_Y_Concatenar(Objeto.anio,Objeto.mes,Objeto.dia,Objeto.hora,Objeto.minutos,Objeto.segundos,BUFFER);
            BUFFER = BUFFER + Objeto.Evento + Cual_Objeto + "-";
            break;
            
    default:break;
      
  }
  return(BUFFER);
}

//Funcion usada para dibujar en pantalla el mapa de luces y sensores//

void DibujarLuces()
{
         fill(255);
         ellipse(160,100,40,40);
         stroke(0);
         textSize(18);
         fill(255,0,0);
         text("L1",160,100);
       
         fill(255);
         ellipse(160,230,40,40);
         stroke(0);
         textSize(18);
         fill(255,0,0);
         text("L2",160,230);
        
         fill(255);
         ellipse(130,380,40,40);
         stroke(0);
         textSize(18);
         fill(255,0,0);
         text("L3",130,380); 
         
         
         fill(255);
         ellipse(130,550,40,40);
         stroke(0);
         textSize(18);
         fill(255,0,0);
         text("L4",130,550);
         
         fill(255);
         ellipse(335,475,30,30);
         stroke(0);
         textSize(14);
         fill(255,0,0);
         text("L5",335,475);
         
         
         fill(255);
         ellipse(410,555,40,40);
         stroke(0);
         textSize(18);
         fill(255,0,0);
         text("L6",410,555);  
         
         fill(255);
         ellipse(430,360,40,40);
         stroke(0);
         textSize(18);
         fill(255,0,0);
         text("L7",430,360);      
         
         
         fill(255); 
         ellipse(-8+width/2,600,50,30); 
         stroke(0);
         textSize(18);
         fill(255,0,0); 
         text("S1",-8+width/2,600); 
      
      
         fill(255); 
         ellipse(width-80,150,50,30); 
         stroke(0);
         textSize(18);
         fill(255,0,0); 
         text("S2",width-80,150); 
}

//Funcion usada para dibujar el fondo y los tres botones correspondientes al menu principal//

void DibujarMenuPrincipal()
{
    background(100);
    
    image(fondoMenu,-5,-35);
    
    textSize(26);
    fill(220,240,255);
    text("MENÚ PRINCIPAL",width/2-122,height/2-300);
    
    
    textSize(42);
    fill(0, 240, 255);
    text("PROYECTO DOMÓTICA", width / 2, height / 2);
  
    // Definir el sombreado debajo del texto en un tono más oscuro de azul
    fill(0, 120, 200);
    text("PROYECTO DOMÓTICA", width / 2, height / 2 + 10);   
    
    textSize(20);
    fill(0);
    text("Alumnos: Salas - Masman",width/2+50,height/2+310);
    

    //Dibujo un boton que se llame IR//
    fill(255); 
    rect(30,100,100,30); 
    stroke(0);
    textSize(18);
    fill(0); 
    text("Ir",50,110); 
    
    //Dibujo un boton que dice GUARDAR// 
    fill(255); 
    rect(30,60,100,30); 
    stroke(0);
    textSize(18);
    fill(0); 
    text("Guardar",70,70);
    
    //Dibujo un boton que dice REPLAY// 
    fill(255); 
    rect(30,140,100,30); 
    stroke(0);
    textSize(18);
    fill(0); 
    text("Replay",70,150); 
  
}
