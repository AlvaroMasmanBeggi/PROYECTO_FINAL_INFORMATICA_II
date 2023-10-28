//------------------------------------------------------------------------------------------------------------------------------------------------//

import java.util.Date;
import java.util.Calendar;
import processing.serial.*;

//VARIABLES PARA LA COMUNICACIÓN//

String MensajeLectura;
String MensajeEscritura;
Serial myPort;

//VARIABLES PARA EL USO DEL PROGRAMA//

PFont fuente;

String filename = "Daatos.txt";  //cadena que almacena el nombre del archivo donde estoy guardadndo los datos//
String[] list ; //Esta lista de cadenas la usamos para guardar las partes del buffer cuando la seccionamos//

boolean CambioDeColor1=true;
boolean CambioDeColor2=true;
boolean CambioDeColor3=true;
boolean CambioDeColor4=true;
boolean CambioDeColor5=true;
boolean CambioDeColor6=true;
boolean CambioDeColor7=true;

int MantenerPrendidoLed1=0;
int MantenerPrendidoLed2=0;
int MantenerPrendidoLed3=0;
int MantenerPrendidoLed4=0;
int MantenerPrendidoLed5=0;
int MantenerPrendidoLed6=0;
int MantenerPrendidoLed7=0;


int EncenderLed=1;
int ApagarLed=2;


//VARIABLES PARA EL MANEJO DEL MENU//
int Selector_Menu = 0; // El 0 representa que estoy en el menu principal, 1 voy al boton IR//
int Grafico_Menu=0;
//VARIABLE QUE MANEJA LA MAMORIA DURANTE LA EJECUCION DEL PROGRAMA//

String Buffer=""; //Cadena que se usa para ir almacenando todos los datos mientras se ejecuta el programa//


//----Ingreso la imagen-----

PImage fondo; // Declaro el fondo
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
  
  fuente = createFont("Comic Sans MS", 24);
  textFont(fuente);
  textAlign(CENTER, CENTER);
  
  fondo=loadImage("plano.jpg");
  fondoMenu = loadImage("FondoMenu.jpg");
  
  
  //myPort = new Serial(this,"com",9600);

  
  //LEO DESDE EL ARCHIVO LO QUE TENGO GUARDADO Y LO CARGO EN EL BUFFER//
  list = loadStrings(filename);
  
  // Reinicio el Buffer
  Buffer = "";
  
  // Iterar sobre las líneas y agregarlas al Buffer
  for (String line : list) 
  {
    Buffer = Buffer + line + '-';
  }

}




//------------------------------------------------------------------------------------------------------------------------------------------------//
//PROGRAMA PRINCIPAL, LAZO INFINITO//

void draw() 
{
    
  if(Selector_Menu == 0)
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
    
    //Verifico si estoy encima de ALGUN BOTON y lo pinto de un color//
    
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
    
    //Ahora verifico si estoy en el boton y me hicieron click//
    if(enRect(30,100,100,30)==true && mousePressed) // si me hacen click en IR voy al control de las luces//
    {
      Selector_Menu = 1;
      Grafico_Menu=1;
      background(100);
    }
    
    if(enRect(30,60,100,30)==true && mousePressed) // si me hacen click en GURDAR guardo los datos del buffer//
    {
        list = split(Buffer, '-');
        saveStrings(filename,list); 
    } 
  }
  
  
 if(Selector_Menu == 1) //si me seleccionaron IR//
 {
    if(Grafico_Menu==1)
    {
   image(fondo,0,0); // DIBUJO FACHADA DE CASA
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
   
   // SENSOR 1 //
   
   fill(255); 
   ellipse(-8+width/2,600,50,30); 
   stroke(0);
   textSize(18);
   fill(255,0,0); 
   text("S1",-8+width/2,600); 
   
   // SENSOR 2 //
   
   fill(255); 
   ellipse(width-80,150,50,30); 
   stroke(0);
   textSize(18);
   fill(255,0,0); 
   text("S2",width-80,150); 
   
    Grafico_Menu=0;// Actualizo Grafico_Menu para que cuando Aprete voler y Ir de nuevo no me sobre escriba todo
    
   }
   //DIBUJO EL BOTON VOLVER//
   fill(255); 
   rect(30,40,100,30); 
   stroke(0);
   textSize(18);
   fill(255,0,0); 
   text("Volver",70,50);
  
    // SI ESTOY EN EL BOTON DE LED 1//
  
   if(enElipse(160,100,40,40)==true && mousePressed)
   {
      
     if(CambioDeColor1==true)
      {
        
        fill(0,230,0);
        ellipse(160,100,40,40);
        stroke(0);
        textSize(18);
        fill(255,0,0);
        text("L1",160,100); 
        MantenerPrendidoLed1=1;
        
        MensajeEscritura = "LE1";
        myPort.write(MensajeEscritura);
        
        Dispositivos[] LED = new Dispositivos[9]; //Declaro un arreglo de objetos para guardar todos los elementos de nuestro sistema//
         
        LED[0] = new Dispositivos();
        Buffer = Encender_Y_Apagar(LED[0],EncenderLed,1,Buffer);
      
      }else  { 
    
        //si no lo dejo blanco al fondo como que no se presiono//
          fill(255);
          ellipse(160,100,40,40);
          stroke(0);
          textSize(18);
          fill(255,0,0);
          text("L1",160,100); 
          MantenerPrendidoLed1=0;
          
          MensajeEscritura = "LA1";
          myPort.write(MensajeEscritura);
          
          Dispositivos[] LED = new Dispositivos[9];
          LED[0] = new Dispositivos();
          
          Buffer = Encender_Y_Apagar(LED[0],ApagarLed,1,Buffer);
          
        }
        delay(150);
        CambioDeColor1=!CambioDeColor1;
     
        
   }
   
   //BOTON LED 2//
   
   if(enElipse(160,230,40,40)==true && mousePressed)
   {
     if (CambioDeColor2==true) 
     {
      
        //Color verde
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
         
     }else{
            fill(255);
            ellipse(160,230,40,40);
            stroke(0);
            textSize(18);
            fill(255,0,0);
            text("L2",160,230);
            MantenerPrendidoLed2=0;
            
            Dispositivos[] LED = new Dispositivos[9]; //Declaro un arreglo de objetos para guardar todos los elementos de nuestro sistema//
           
            LED[1] = new Dispositivos();
            Buffer = Encender_Y_Apagar(LED[1],ApagarLed,2,Buffer);
         }
    delay(150);
    CambioDeColor2=!CambioDeColor2;
   }
   
   // BOTON DE LED 3 
   
   if(enElipse(130,380,40,40)==true && mousePressed)
   {
     if (CambioDeColor3==true) 
     {
      
         //Color verde 
        fill(10,190,10);
        ellipse(130,380,40,40);
        stroke(0);
        textSize(18);
        fill(255,0,0);
        text("L3",130,380);
        MantenerPrendidoLed3=1;
        
        Dispositivos[] LED = new Dispositivos[9]; //Declaro un arreglo de objetos para guardar todos los elementos de nuestro sistema//
         
        LED[2] = new Dispositivos();
        Buffer = Encender_Y_Apagar(LED[2],EncenderLed,3,Buffer);
         
     }else{
            fill(255);
            ellipse(130,380,40,40);
            stroke(0);
            textSize(18);
            fill(255,0,0);
            text("L3",130,380); 
            MantenerPrendidoLed3=0;
            
            Dispositivos[] LED = new Dispositivos[9]; //Declaro un arreglo de objetos para guardar todos los elementos de nuestro sistema//
           
            LED[2] = new Dispositivos();
            Buffer = Encender_Y_Apagar(LED[2],ApagarLed,3,Buffer);
         }
     delay(150);
     CambioDeColor3=!CambioDeColor3;
   }
   
   // BOTON DE LED 4
   
   if(enElipse(130,550,40,40)==true && mousePressed)
   {
     if (CambioDeColor4==true) 
     {
      
         //Color verde 
        fill(10,190,10);
        ellipse(130,550,40,40);
        stroke(0);
        textSize(18);
        fill(255,0,0);
        text("L4",130,550);
        MantenerPrendidoLed4=1;
        Dispositivos[] LED = new Dispositivos[9]; //Declaro un arreglo de objetos para guardar todos los elementos de nuestro sistema//
         
        LED[3] = new Dispositivos();
        Buffer = Encender_Y_Apagar(LED[3],EncenderLed,4,Buffer);
         
     }else{
            fill(255);
            ellipse(130,550,40,40);
            stroke(0);
            textSize(18);
            fill(255,0,0);
            text("L4",130,550);
            MantenerPrendidoLed4=0;
            Dispositivos[] LED = new Dispositivos[9]; //Declaro un arreglo de objetos para guardar todos los elementos de nuestro sistema//
           
            LED[3] = new Dispositivos();
            Buffer = Encender_Y_Apagar(LED[3],ApagarLed,4,Buffer);
         }
     delay(150);
     CambioDeColor4=!CambioDeColor4;
   }
   
   // BOTON DE LED 5
   
   if(enElipse(335,475,30,30)==true && mousePressed)
   {
     if (CambioDeColor5==true) 
     {
      
         //Color verde 
         fill(10,190,10);
         ellipse(335,475,30,30);
         stroke(0);
         textSize(14);
         fill(255,0,0);
         text("L5",335,475);
         MantenerPrendidoLed5=1;
        Dispositivos[] LED = new Dispositivos[9]; //Declaro un arreglo de objetos para guardar todos los elementos de nuestro sistema//
         
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
           Dispositivos[] LED = new Dispositivos[9]; //Declaro un arreglo de objetos para guardar todos los elementos de nuestro sistema//
           
           LED[4] = new Dispositivos();
           Buffer = Encender_Y_Apagar(LED[4],ApagarLed,5,Buffer);
         }
     delay(150);
     CambioDeColor5=!CambioDeColor5;
   }
   
   // BOTON DE LED 6
   
   if(enElipse(410,555,40,40)==true && mousePressed)
   {
     if (CambioDeColor6==true) 
     {
      
         //Color verde 
         fill(10,190,10);
         ellipse(410,555,40,40);
         stroke(0);
         textSize(18);
         fill(255,0,0);
         text("L6",410,555);
         MantenerPrendidoLed6=1;
        Dispositivos[] LED = new Dispositivos[9]; //Declaro un arreglo de objetos para guardar todos los elementos de nuestro sistema//
         
        LED[5] = new Dispositivos();
        Buffer = Encender_Y_Apagar(LED[5],EncenderLed,6,Buffer);
         
     }else{
           fill(255);
           ellipse(410,555,40,40);
           stroke(0);
           textSize(18);
           fill(255,0,0);
           text("L6",410,555);
           MantenerPrendidoLed6=0;            
           Dispositivos[] LED = new Dispositivos[9]; //Declaro un arreglo de objetos para guardar todos los elementos de nuestro sistema//
           
           LED[5] = new Dispositivos();
           Buffer = Encender_Y_Apagar(LED[5],ApagarLed,6,Buffer);
         }
     delay(150);
     CambioDeColor6=!CambioDeColor6;
   }
   
   // BOTON DE LED 7
   
   if(enElipse(430,360,40,40)==true && mousePressed)
   {
     if (CambioDeColor7==true) 
     {
      
         //Color verde 
         fill(10,190,10);
         ellipse(430,360,40,40);
         stroke(0);
         textSize(18);
         fill(255,0,0);
         text("L7",430,360);
        MantenerPrendidoLed7=1;
        Dispositivos[] LED = new Dispositivos[9]; //Declaro un arreglo de objetos para guardar todos los elementos de nuestro sistema//
         
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
           Dispositivos[] LED = new Dispositivos[9]; //Declaro un arreglo de objetos para guardar todos los elementos de nuestro sistema//
           
           LED[6] = new Dispositivos();
           Buffer = Encender_Y_Apagar(LED[6],ApagarLed,7,Buffer);
         }
     delay(150);
     CambioDeColor7=!CambioDeColor7;
   }
   
   //PARTE PARA VERIFICAR Y ACCIONAR ANTE SEÑALES DEL ARDUINO//
   
   if(myPort.available()>0)
   {
     MensajeLectura = myPort.readStringUntil("\n");
     
     if(MensajeLectura != null)
     {
       //VERIFICO LED 1//
       if(MensajeLectura.compareTo("LE1\n") == 0)
       {
          fill(0,230,0);
          ellipse(160,100,40,40);
          stroke(0);
          textSize(18);
          fill(255,0,0);
          text("L1",160,100); 
          MantenerPrendidoLed1=1;
          Dispositivos[] LED = new Dispositivos[9]; //Declaro un arreglo de objetos para guardar todos los elementos de nuestro sistema//
         
          LED[0] = new Dispositivos();
          Buffer = Encender_Y_Apagar(LED[0],EncenderLed,1,Buffer);
          if(CambioDeColor1 == true)
          {
           CambioDeColor1 = !CambioDeColor1; 
          }
       }
       if(MensajeLectura.compareTo("LE1\n") == 0)
       {
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
           if(CambioDeColor1 == false)
          {
           CambioDeColor1 = !CambioDeColor1; 
          }
       }
     }
     
     
   }
   
   
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
   
 }
   
 
  
  
}


//------------------------------------------------------------------------------------------------------------------------------------------------//
//FUNCIONES CREADAS POR NOSOTROS PARA EL FUNCIONAMIENTO//

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
