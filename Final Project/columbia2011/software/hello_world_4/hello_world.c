/*
 * "Hello World" example.
 *
 * This example prints 'Hello from Nios II' to the STDOUT stream. It runs on
 * the Nios II 'standard', 'full_featured', 'fast', and 'low_cost' example
 * designs. It runs with or without the MicroC/OS-II RTOS and requires a STDOUT
 * device in your system's hardware.
 * The memory footprint of this hosted application is ~69 kbytes by default
 * using the standard reference design.
 *
 * For a reduced footprint version of this template, and an explanation of how
 * to reduce the memory footprint for a given application, see the
 * "small_hello_world" template.
 *
 */

#include <stdio.h>
#include <alt_types.h>
#include <stdlib.h>
#include <io.h>
#include <system.h>
#include <time.h>
#include "sound.h"
#include "DM9000A.h"
#include "basic_io.h"
#include "bomb.h"
#include "fire.h"
#include "hello_world.h"

#define MAX_MSG_LENGTH 128
#define UDP_PACKET_PAYLOAD_OFFSET 42
#define UDP_PACKET_LENGTH_OFFSET 38
#define UDP_PACKET_PAYLOAD (transmit_buffer + UDP_PACKET_PAYLOAD_OFFSET)
int test = 0;
int package = 0;
int gamestage = 0;
int pointer = 368;
int schedule = 32;
int turn = 24;
int initspeed = 8;
// Ethernet MAC address.  Choose the last three bytes yourself
unsigned char mac_address[6] = { 0x01, 0x60, 0x6E, 0x11, 0x02, 0x0F  };

unsigned int interrupt_number;



unsigned char transmit_buffer[] = {
  // Ethernet MAC header
  0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, // Destination MAC address
  0x01, 0x60, 0x6E, 0x11, 0xE2, 0x0F, // Source MAC address
  0x08, 0x00,                         // Packet Type: 0x800 = IP
                          
  // IP Header
  0x45,                // version (IPv4), header length = 20 bytes
  0x00,                // differentiated services field
  0x00,0x9C,           // total length: 20 bytes for IP header +
                       // 8 bytes for UDP header + 128 bytes for payload
  0x00, 0x00,          // packet ID
  0x00,                // flags
  0x00,                // fragment offset
  0x80,                // time-to-live
  0x11,                // protocol: 11 = UDP
  0xb6,0x00,           // header checksum: incorrect
  0xc0,0xa8,0x01,0x01, // source IP address
  0xFF,0xFF,0xFF,0xFF, // destination IP address
                          
  // UDP Header
  0x67,0xd9, // source port port (26585: garbage)
  0x27,0x2b, // destination port (10027: garbage)
  0x00,0x88, // length (136: 8 for UDP header + 128 for data)
  0x00,0x00, // checksum: 0 = none
                          
  // UDP payload
  0x74, 0x65, 0x73, 0x74, 0x20, 0x6d, 0x73, 0x67,
  0x74, 0x65, 0x73, 0x74, 0x20, 0x6d, 0x73, 0x67,
  0x74, 0x65, 0x73, 0x74, 0x20, 0x6d, 0x73, 0x67,
  0x74, 0x65, 0x73, 0x74, 0x20, 0x6d, 0x73, 0x67,
  0x74, 0x65, 0x73, 0x74, 0x20, 0x6d, 0x73, 0x67,
  0x74, 0x65, 0x73, 0x74, 0x20, 0x6d, 0x73, 0x67,
  0x74, 0x65, 0x73, 0x74, 0x20, 0x6d, 0x73, 0x67,
  0x74, 0x65, 0x73, 0x74, 0x20, 0x6d, 0x73, 0x67,
  0x74, 0x65, 0x73, 0x74, 0x20, 0x6d, 0x73, 0x67,
  0x74, 0x65, 0x73, 0x74, 0x20, 0x6d, 0x73, 0x67,
  0x74, 0x65, 0x73, 0x74, 0x20, 0x6d, 0x73, 0x67,
  0x74, 0x65, 0x73, 0x74, 0x20, 0x6d, 0x73, 0x67,
  0x74, 0x65, 0x73, 0x74, 0x20, 0x6d, 0x73, 0x67,
  0x74, 0x65, 0x73, 0x74, 0x20, 0x6d, 0x73, 0x67,
  0x74, 0x65, 0x73, 0x74, 0x20, 0x6d, 0x73, 0x67,
  0x74, 0x65, 0x73, 0x74, 0x20, 0x6d, 0x73, 0x67
};   

static void ethernet_interrupt_handler() {
  unsigned int receive_status;
  unsigned int receive_buffer_length;
  unsigned char receive_buffer[1600];
  //int i;
  int x,y;
 //  printf("package %d action %c ", test++,receive_buffer[43]);
  receive_status = ReceivePacket(receive_buffer, &receive_buffer_length);

  if (receive_status == DMFE_SUCCESS) {
    if(receive_buffer[27] == 0x00){
     printf("get dhcp");
     if(g.step==1)
     receive_status = ReceivePacket(receive_buffer, &receive_buffer_length);  
    } 
    if (receive_buffer_length >= 14) {
      //  A real Ethernet packet
  
      // A UDP packet
      if (receive_buffer_length >= UDP_PACKET_PAYLOAD_OFFSET) {
         if(receive_buffer[43] == 'm'){
            switch(receive_buffer[42]){
               case 1:
                    x = (((int)receive_buffer[44])<<8) + receive_buffer[45];
                    y = (((int)receive_buffer[46])<<8) + receive_buffer[47];       
                    p1.posX = x;
                    p1.posY = y;             
               break;   
               case 2:
                    x = (((int)receive_buffer[44])<<8) + receive_buffer[45];
                    y = (((int)receive_buffer[46])<<8) + receive_buffer[47];       
                    p2.posX = x;
                    p2.posY = y;                                             
               break;
               case 3:
                    x = (((int)receive_buffer[44])<<8) + receive_buffer[45];
                    y = (((int)receive_buffer[46])<<8) + receive_buffer[47];       
                    p3.posX = x;
                    p3.posY = y;                    
               break;             
            }           
         }
       else if(receive_buffer[43] == 'p'){
             insert_bomb((int)receive_buffer[44],(int)receive_buffer[45],(int)receive_buffer[46],receive_buffer[42]-1);             
             set_tile((int)receive_buffer[44],(int)receive_buffer[45],BOMB);                          
       }
       else if(receive_buffer[42] == 'g'){
             if(receive_buffer[43] == 1){ 
               g.step = 1;
               IOWR_16DIRECT(RASTER_BASE,20,g.step);  
              mapgen();
              setmap();                 
               if(pointer == 368){
                p3.state = DEAD;
                p4.state = DEAD;
                IOWR_16DIRECT(RASTER_BASE,26,p3.state); 
                IOWR_16DIRECT(RASTER_BASE,28,p4.state); 
               } else if(pointer == 384){
              
                p4.state = DEAD;
                IOWR_16DIRECT(RASTER_BASE,28,p4.state); 
               }
             }
             else if(receive_buffer[43] == 0 && g.step==2){
               reset(); 
             }
               
       } else if(receive_buffer[42] == 't'){
             pointer = receive_buffer[43]*4;     
       }
         /* Clear the DM9000A ISR: PRS, PTS, ROS, ROOS 4 bits, by RW/C1 */

                 
      }
   
    } else {
      printf("Malformed Ethernet packet\n");
    }

  } else {
    printf("Error receiving packet\n");
  }

  /* Display the number of interrupts on the LEDs */
  interrupt_number++;
       dm9000a_iow(ISR, 0x3F);
              
        /* Re-enable DM9000A interrupts */
       dm9000a_iow(IMR, INTR_set);
      
}



void move(int x,int y){
          unsigned char x1,x2;          
          unsigned char y1,y2;
          unsigned int packet_length;     
          
          int curMsgChar = 0;
          for (curMsgChar=MAX_MSG_LENGTH-1; curMsgChar>0; curMsgChar--) {
              UDP_PACKET_PAYLOAD[curMsgChar] = 0;
          }               
          if(transmit_buffer[25] == 0x00){
             transmit_buffer[25] = 0xFF;
             
             if(transmit_buffer[24] == 0x00)
                transmit_buffer[24] = 0xFF;
             else
                transmit_buffer[24]--;   
          
          }
          else
          transmit_buffer[25]--;
          
          if(transmit_buffer[19] == 0xFF){
             transmit_buffer[19] = 0x00;
             
             if(transmit_buffer[18] == 0xFF)
                transmit_buffer[18] = 0x00;
             else
                transmit_buffer[18]++;   
          
          }
          else
          transmit_buffer[19]++;
          x1 = (unsigned char)x;
          x2 = (unsigned char)(x>>8);          
  //        printf("number %d x  %d y %d\n",package,x,y);
     //     package++;
          y1 = (unsigned char)y;
          y2 = (unsigned char)(y>>8);
          
                      
          UDP_PACKET_PAYLOAD[curMsgChar++] = 4;
          UDP_PACKET_PAYLOAD[curMsgChar++] = 'm';
          UDP_PACKET_PAYLOAD[curMsgChar++] = x2;
          UDP_PACKET_PAYLOAD[curMsgChar++] = x1;
          UDP_PACKET_PAYLOAD[curMsgChar++] = y2;
          UDP_PACKET_PAYLOAD[curMsgChar++] = y1;          
          UDP_PACKET_PAYLOAD[curMsgChar++] = 0; // Terminate the string
          packet_length = 8 + curMsgChar;
          transmit_buffer[UDP_PACKET_LENGTH_OFFSET] = packet_length >> 8;
          transmit_buffer[UDP_PACKET_LENGTH_OFFSET + 1] = packet_length & 0xff;          
          if (TransmitPacket(transmit_buffer, UDP_PACKET_PAYLOAD_OFFSET + curMsgChar + 1)==DMFE_SUCCESS) { 
               printf("\nMessage sent successfully\n");
          }else {
               printf("\nMessage sending failed\n"); 
          }              
}

void put_bomb(int x, int y,int power){
          unsigned char x1;          
          unsigned char y1;
          unsigned char power1;
          unsigned int packet_length;           
          int curMsgChar = 0;
          for (curMsgChar=MAX_MSG_LENGTH-1; curMsgChar>0; curMsgChar--) {
              UDP_PACKET_PAYLOAD[curMsgChar] = 0;
          }               
          if(transmit_buffer[25] == 0x00){
             transmit_buffer[25] = 0xFF;
             
             if(transmit_buffer[24] == 0x00)
                transmit_buffer[24] = 0xFF;
             else
                transmit_buffer[24]--;   
          
          }
          else
          transmit_buffer[25]--;         
          if(transmit_buffer[19] == 0xFF){
             transmit_buffer[19] = 0x00;             
             if(transmit_buffer[18] == 0xFF)
                transmit_buffer[18] = 0x00;
             else
                transmit_buffer[18]++;             
          }
          else
          transmit_buffer[19]++;
          x1 = (unsigned char)x;       
          y1 = (unsigned char)y;  
   //      printf("x %d y %d \n",x1,y1);
          
          power1 = (unsigned char)power;
          UDP_PACKET_PAYLOAD[curMsgChar++] = 4;
          UDP_PACKET_PAYLOAD[curMsgChar++] = 'p';
          UDP_PACKET_PAYLOAD[curMsgChar++] = x1;
          UDP_PACKET_PAYLOAD[curMsgChar++] = y1;
          UDP_PACKET_PAYLOAD[curMsgChar++] = power1;                     
          UDP_PACKET_PAYLOAD[curMsgChar++] = 0; // Terminate the string
          packet_length = 8 + curMsgChar;
          transmit_buffer[UDP_PACKET_LENGTH_OFFSET] = packet_length >> 8;
          transmit_buffer[UDP_PACKET_LENGTH_OFFSET + 1] = packet_length & 0xff;          
          if (TransmitPacket(transmit_buffer, UDP_PACKET_PAYLOAD_OFFSET + curMsgChar + 1)==DMFE_SUCCESS) { 
               printf("\nMessage sent successfully\n");
          }else {
               printf("\nMessage sending failed\n"); 
          }    
}



void winf(){
      int i,j;
      for(i = 0 ; i < 15 ; i++){
          for(j = 0 ; j < 19 ; j++){
            usleep(5000);
            control_array[i][j] = win[i][j];               
            IOWR_16DIRECT(RASTER_BASE,18,j+i*32+control_array[i][j]*32*32);
          }
       }

}

void losef(){
      int i,j;
      for(i = 0 ; i < 15 ; i++){
          for(j = 0 ; j < 19 ; j++){
            usleep(5000);
            control_array[i][j]=lose[i][j];               
            IOWR_16DIRECT(RASTER_BASE,18,j+i*32+control_array[i][j]*32*32);
          }
       }

}

void setmap(){
      int i,j;
      for(i = 0 ; i < 15 ; i++){
          for(j = 0 ; j < 19 ; j++){            
            IOWR_16DIRECT(RASTER_BASE,18,j+i*32+control_array[i][j]*32*32);
          }
       }
}

void mapgen(){
     int i,j,seed;    

     srand(time(NULL));
     for(i = 0 ; i < 15 ; i++){
         for(j = 0 ; j < 19 ; j++){           
            control_array[i][j]=initial[i][j];       
         }
     }
          
     for(i = 1 ; i < 14 ; i++){
         for(j = 1 ; j < 19 ; j++){ 
           ////reserve corner
           if((i <= 2 && j <=2) || (i >= 12 && j<=2) ||(i <= 2&& j>=16 ) || (i >= 12&& j>=16 )) continue;  
           ///skip concrete
           if(control_array[i][j] == CONCRETE) continue;
           
           seed = rand()%2;
           if(seed)  control_array[i][j] = BRICK;
         }
     }
}                             
void reset(){     
     p1.state = 0;
     p2.state = 0;
     p3.state = 0;
     p4.state = 0;
     IOWR_16DIRECT(RASTER_BASE,22,p1.state);
     IOWR_16DIRECT(RASTER_BASE,24,p2.state);
     IOWR_16DIRECT(RASTER_BASE,26,p3.state);
     IOWR_16DIRECT(RASTER_BASE,28,p4.state);
     g.step = 0;
     IOWR_16DIRECT(RASTER_BASE,20 ,g.step);      
     p1.posX = 0x0030;
     p1.posY = 0x0030;
     p2.posX = 0x0230;
     p2.posY = 0x01B0;
     p3.posX = 0x0230;
     p3.posY = 0x0030;
     p4.posX = 0x0030;
     p4.posY = 0x01B0;
     p4.pos1X = (p4.posX - p4.posX%32)/32;
     p4.pos1Y = (p4.posY - p4.posY%32)/32;
     p4.speed = initspeed;
     p4.bomb  = 1;
     p4.power = 1;
     mapgen();
     setmap();
     IOWR_16DIRECT(RASTER_BASE,0 ,p1.posX);
     IOWR_16DIRECT(RASTER_BASE,2 ,p1.posY);
     IOWR_16DIRECT(RASTER_BASE,4 ,p2.posX);
     IOWR_16DIRECT(RASTER_BASE,6 ,p2.posY);
     IOWR_16DIRECT(RASTER_BASE,8  ,p3.posX);
     IOWR_16DIRECT(RASTER_BASE,10 ,p3.posY);
     IOWR_16DIRECT(RASTER_BASE,12 ,p4.posX);
     IOWR_16DIRECT(RASTER_BASE,14 ,p4.posY);     
}

void set_tile(int x, int y, int thing){
     IOWR_16DIRECT(RASTER_BASE,18,x+y*32+thing*32*32); 
     control_array[y][x] = thing;
}              


//////bomb 1 fire 2 brick 3 powerup 4 bombup 5 speedup 6 concrete 15 
int main(){
  int code;  
  int tempxleft;
  int tempxright;
  int tempy;

  
  printf("Ready\n");

  DM9000_init(mac_address);
  alt_irq_register(DM9000A_IRQ, NULL, (void*)ethernet_interrupt_handler);
  reset();
 while(1){
   
 while(!IORD_8DIRECT(PS2_BASE,0)||(g.current_time%schedule!=turn)){
       if(g.step == 0){
         IOWR_16DIRECT(RASTER_BASE,30,pointer);          
       } else{    
       p1.pos1X = (p1.posX - p1.posX%32)/32;
       p1.pos1Y = (p1.posY - p1.posY%32)/32;
       p2.pos1X = (p2.posX - p2.posX%32)/32;
       p2.pos1Y = (p2.posY - p2.posY%32)/32;
       p3.pos1X = (p3.posX - p3.posX%32)/32;
       p3.pos1Y = (p3.posY - p3.posY%32)/32;
       if(control_array[p1.pos1Y][p1.pos1X]==FIRE){
         p1.state = DEAD;
         IOWR_16DIRECT(RASTER_BASE,22,p1.state);                 
       }
       if(control_array[p2.pos1Y][p2.pos1X]==FIRE){
         p2.state = DEAD;
         IOWR_16DIRECT(RASTER_BASE,24,p2.state);                 
       }
       if(control_array[p3.pos1Y][p3.pos1X]==FIRE){
         p3.state = DEAD;
         IOWR_16DIRECT(RASTER_BASE,26,p3.state);                 
       }
       if(control_array[p4.pos1Y][p4.pos1X]==FIRE){
         p4.state = DEAD;
         IOWR_16DIRECT(RASTER_BASE,28,p4.state);      
          g.step = 2;               
       }       
       if(p1.state + p2.state + p3.state + p4.state >= 3){        
            g.step = 2;
            if(p4.state == DEAD)
              losef();
            else
              winf();                    
       }          
       if(control_array[p1.pos1Y][p1.pos1X]==POWERUP 
        ||control_array[p1.pos1Y][p1.pos1X]==BOMBUP
        ||control_array[p1.pos1Y][p1.pos1X]==SPEEDUP){          
          set_tile(p1.pos1X,p1.pos1Y,EMPTY); 
       }
       if(control_array[p2.pos1Y][p2.pos1X]==POWERUP 
        ||control_array[p2.pos1Y][p2.pos1X]==BOMBUP
        ||control_array[p2.pos1Y][p2.pos1X]==SPEEDUP){          
          set_tile(p2.pos1X,p2.pos1Y,EMPTY); 
       }
       if(control_array[p3.pos1Y][p3.pos1X]==POWERUP 
        ||control_array[p3.pos1Y][p3.pos1X]==BOMBUP
        ||control_array[p3.pos1Y][p3.pos1X]==SPEEDUP){          
          set_tile(p3.pos1X,p3.pos1Y,EMPTY); 
       }     
       IOWR_16DIRECT(RASTER_BASE,0 ,p1.posX);
       IOWR_16DIRECT(RASTER_BASE,2 ,p1.posY);
       IOWR_16DIRECT(RASTER_BASE,4 ,p2.posX);
       IOWR_16DIRECT(RASTER_BASE,6 ,p2.posY);
       IOWR_16DIRECT(RASTER_BASE,8  ,p3.posX);
       IOWR_16DIRECT(RASTER_BASE,10 ,p3.posY);
       IOWR_16DIRECT(RASTER_BASE,12 ,p4.posX);
       IOWR_16DIRECT(RASTER_BASE,14 ,p4.posY);       
       countdown_bomb();  
       countdown_fire();
       g.current_time = IORD_16DIRECT(RASTER_BASE,0);
       }
                  
  }

  code = IORD_8DIRECT(PS2_BASE,4);  

  if(g.step == 1){
   switch(code){

     case 117: //up
         p4.pos1X = (p4.posX - p4.posX%32)/32;
         tempxleft = (p4.posX-5)/32;
         tempxright = (p4.posX+5)/32;
         p4.pos1Y = (p4.posY - p4.posY%32)/32; 
         if(control_array[p4.pos1Y-1][p4.pos1X]==EMPTY
          ||control_array[p4.pos1Y-1][p4.pos1X]==FIRE 
          ||control_array[p4.pos1Y-1][p4.pos1X]==POWERUP
          ||control_array[p4.pos1Y-1][p4.pos1X]==BOMBUP
          ||control_array[p4.pos1Y-1][p4.pos1X]==SPEEDUP)          
         p4.posY -= p4.speed;
         else{
         p4.posY -= p4.speed;   
         if(p4.posY <= p4.pos1Y*32+16)
               p4.posY = p4.pos1Y*32+15;                        
         }
         move(p4.posX,p4.posY);
         usleep(10000);
     break;
     case 114: //down   
         p4.pos1X = (p4.posX - p4.posX%32)/32;
         p4.pos1Y = (p4.posY - p4.posY%32)/32;
         tempxleft = (p4.posX-5)/32;
         tempxright = (p4.posX+5)/32;         
         if((control_array[p4.pos1Y+1][p4.pos1X]==EMPTY)
          ||control_array[p4.pos1Y-1][p4.pos1X]==FIRE 
          ||control_array[p4.pos1Y+1][p4.pos1X]==POWERUP
          ||control_array[p4.pos1Y+1][p4.pos1X]==BOMBUP
          ||control_array[p4.pos1Y+1][p4.pos1X]==SPEEDUP)    
         p4.posY += p4.speed;
         else{
         p4.posY += p4.speed;        
         if(p4.posY >= p4.pos1Y*32+16)
               p4.posY = p4.pos1Y*32+17;                    
         }
         move(p4.posX,p4.posY);
         usleep(10000); 
     break;
     case 107: //left
         p4.pos1X = (p4.posX - p4.posX%32)/32;
         p4.pos1Y = (p4.posY - p4.posY%32)/32;
         tempy  = (p4.posY +14)/32;   
         if((control_array[p4.pos1Y][p4.pos1X-1]==EMPTY&&
             control_array[tempy][p4.pos1X-1]==EMPTY)
          ||control_array[p4.pos1Y-1][p4.pos1X]==FIRE    
          ||control_array[p4.pos1Y][p4.pos1X-1]==POWERUP
          ||control_array[p4.pos1Y][p4.pos1X-1]==BOMBUP
          ||control_array[p4.pos1Y][p4.pos1X-1]==SPEEDUP)  
          p4.posX -= p4.speed;
         else{
         p4.posX -= p4.speed;
         if(p4.posX <= p4.pos1X*32+16)
               p4.posX = p4.pos1X*32+15;                  
         }
         move(p4.posX,p4.posY);
         usleep(10000);
     break;
     case 116:
         p4.pos1X = (p4.posX - p4.posX%32)/32;
         p4.pos1Y = (p4.posY - p4.posY%32)/32;
         tempy = (p4.posY +14)/32; 
         if((control_array[p4.pos1Y][p4.pos1X+1]==EMPTY&&
             control_array[tempy][p4.pos1X+1]==EMPTY)
          ||control_array[p4.pos1Y-1][p4.pos1X]==FIRE 
          ||control_array[p4.pos1Y][p4.pos1X+1]==POWERUP
          ||control_array[p4.pos1Y][p4.pos1X+1]==BOMBUP
          ||control_array[p4.pos1Y][p4.pos1X+1]==SPEEDUP)  
         p4.posX += p4.speed;
         else{
         p4.posX += p4.speed;  
         if(p4.posX >= p4.pos1X*32+16)
               p4.posX = p4.pos1X*32+17;               
         }
         move(p4.posX,p4.posY);
         usleep(10000);
     break;
     case 41:
         p4.pos1X = (p4.posX - p4.posX%32)/32;
         p4.pos1Y = (p4.posY - p4.posY%32)/32;
         if(control_array[p4.pos1Y][p4.pos1X] == EMPTY && checkbomb(p4.bomb)){
             
             insert_bomb(p4.pos1X,p4.pos1Y, p4.power,player4);             
             set_tile(p4.pos1X,p4.pos1Y,BOMB);
             put_bomb(p4.pos1X, p4.pos1Y,p4.power);
             usleep(10000);              
         } 
         
                                   
     break;
     
     default:
     break;
    }

    if(control_array[p4.pos1Y][p4.pos1X]==POWERUP){
       p4.power++;
       set_tile(p4.pos1X,p4.pos1Y,EMPTY); 
    }
    if(control_array[p4.pos1Y][p4.pos1X]==BOMBUP){
       p4.bomb++;
       set_tile(p4.pos1X,p4.pos1Y,EMPTY);  
    }
    if(control_array[p4.pos1Y][p4.pos1X]==SPEEDUP){
       if(p4.speed < 10)
       p4.speed++;
       set_tile(p4.pos1X,p4.pos1Y,EMPTY);  
    }

   }//gamestep == 1;           
 } 
  
  return 0;
}
