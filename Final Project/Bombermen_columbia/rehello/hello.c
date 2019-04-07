#include "sprite.h"
#include <sys/ioctl.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>
#include "usbkeyboard.h"
#include <pthread.h>
#include <libusb-1.0/libusb.h>
#include <stdint.h>
#include "vga_led.h"
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <time.h>


#define TIMES 30
int vga_led_fd;
/*for libusb_transfer keyboard_1*/
struct libusb_device_handle *keyboard1;
struct libusb_device_handle *keyboard2;
uint8_t endpoint_address_1;
uint8_t endpoint_address_2;

int gameover = 0; // 1 = over, 0 = not over
pthread_mutex_t mutex_write = PTHREAD_MUTEX_INITIALIZER;
pthread_mutex_t mutex_map   = PTHREAD_MUTEX_INITIALIZER;

//map array
int map[15][19]; 
//bomb time array
bomb bmap[15][19];
//status array
int smap[2];

//position for man1(x1,y1) and man2(x2,y2)
int x1;
int y1;
int x2;
int y2;

//bombermen
bomberman man1;
bomberman man2;

int judge_winner(int power, int x, int y, int owner);
void explode(int power, int x, int y, int owner);
void vanish(int power, int x, int y, int owner) ;
int create_gift() ;
int create_gift_center() ;
void win(int winner);
void get_gift(int x, int y, int man);

void write_segments(const unsigned int segs)
{
  pthread_mutex_lock(&mutex_write);
  vga_led_arg_t vla;
  int i;
  // alternate between sending x and y coordinates (send x when i = 0, send y when i = 1)
      vla.digit = 0;
      vla.segments = segs;
    if (ioctl(vga_led_fd, VGA_LED_WRITE_DIGIT, &vla)) {
      perror("ioctl(VGA_LED_WRITE_DIGIT) failed");
      return;
    }
  pthread_mutex_unlock(&mutex_write);  
}

// initialize game map
void init_map(){
    int i,j;
    for(i=0; i<15; i++){
        for(j=0; j<19; j++){
            map[i][j]=-2; //hardbrick
        }
    }
    for(i=1; i<14; i++){
        for(j=1; j<18; j++){
            if(j%2==1 || (i%2==1 && j%2==0))
                map[i][j]=-1; //softbrick
        }
    }
    map[1][1]=10; //man1
    map[13][17]=20; //man2
    map[1][2]=map[2][1]=map[13][16]=map[12][17]=0;
}

// initialize the bomb map
void init_bmap(){
    int i,j;
    for(i=0; i<15; i++){
        for(j=0; j<19; j++){
            bmap[i][j].power=-1;
            bmap[i][j].time=-1;
        }
    }
}
//init status map
void init_smap(){
    smap[0] = -1;
    smap[1] = -1;
}
// initialize both bombermen
void init_bomberman(){
    man1.numOfBombs=1;
    man1.power=1;
    man1.status=0;
    man1.special=0;

    man2.numOfBombs=1;
    man2.power=1;
    man2.status=0;
    man1.special=0;

    x1=1;
    y1=1;
    x2=13;
    y2=17;
}

// initialize a bomb
void init_bomb(bomb *b, int power, int time, int owner) {
      b->power = power;
      b->time = time;
      b->owner = owner;
}

//update map
void update_map(int x, int y, int value) {
    pthread_mutex_lock(&mutex_map);
    map[x][y] = value;
    pthread_mutex_unlock(&mutex_map);
}
// convert x,y positions to 1D coordinates
int convertXY (int x, int y) {
	return (y-1)+(x-1)*17;
}

// send position and updated item to hardware (only for items, controls are sent separately)
void send_to_HW (int x, int y, int item, int sound) {
	int send;
	if (x==0 && y==0 && item==0)
		send = sound; 
	else 
		send = convertXY(x,y)*64+32+item+sound; // address + 100000 + item#
        int i;	

        for (i=0;i<TIMES;i++) {
            write_segments(send); 
        }
	usleep(10);
}

// convert USB signal to char instruction
char parse_packet(struct usb_keyboard_packet *packet){
    if(packet->reserved== 0x1)
	return 'u';
    if(packet->reserved== 0x2)
	return 'd';
    if(packet->reserved== 0x4)
	return 'l';
    if(packet->reserved== 0x8)
	return 'r';
    if(packet->reserved== 0x1000)
	return 'b';
    if(packet->reserved== 0x2000)
	return 'b';
    if(packet->reserved== 0x4000)
	return 'b';
    if(packet->reserved== 0x8000)
	return 'b';
    return 0;
}

// control thread for gamepad 1
void *input1_thread(void *ignored){
    struct usb_keyboard_packet packet;
    int transferred,i;
    fprintf(stderr,"enter input2_thread\n");

    while(1){

    while(gameover==1) {
    	sleep(1);
    }
    
    libusb_interrupt_transfer(keyboard1, endpoint_address_1,
			    (unsigned char *)&packet, sizeof(packet),
		            &transferred,0);
    fprintf(stderr,"%x\n",packet.reserved);
    char ins = parse_packet(&packet);
    if(man1.status ==1 ) {
        if(ins == 'l')
            ins = 'r';
        else if(ins == 'r')
            ins = 'l';
        else if(ins == 'u')
            ins = 'd';
        else if(ins == 'd')
            ins = 'u';
    }
    
    if(ins=='l' && man1.status != 5){
        if(map[x1][y1-1] == 20 || map[x1][y1-1] == 0 || map[x1][y1-1] > 40){//if man1 is not stopped
            update_map(x1, y1, map[x1][y1]-10);
            update_map(x1, y1-1, map[x1][y1-1]+10);
	        if(map[x1][y1-1] > 50)
	    	    get_gift(x1,y1-1,1);
            y1--;
            for (i=0;i<TIMES;i++) {
                write_segments(1); // 000001
            }
            usleep(100000); 

            for (i=0;i<TIMES;i++) {
                write_segments(16); // 000001
            }

            for (i=0;i<TIMES;i++) {
                write_segments(0); // 000001
            }
            
        }
        fprintf(stderr,"player1: left\n");
    }

    if(ins=='r' && man1.status != 5){
        if(map[x1][y1+1] == 20 || map[x1][y1+1] == 0 || map[x1][y1+1] > 40){//if man1 is not stopped    
            update_map(x1, y1, map[x1][y1]-10);
            update_map(x1, y1+1, map[x1][y1+1]+10);
	        if(map[x1][y1+1] > 50)
	    	    get_gift(x1,y1+1,1);
            y1++;
            for (i=0;i<TIMES;i++) {
                write_segments(2); // 000010
            } 

            usleep(100000); 


            for (i=0;i<TIMES;i++) {
                write_segments(16); // 000001
            }

            for (i=0;i<TIMES;i++) {
                write_segments(0); // 000001
            }
 
       }
        fprintf(stderr,"player1: right\n");      
    }

    if(ins=='u' && man1.status != 5){
        if(map[x1-1][y1] == 20 || map[x1-1][y1] == 0 || map[x1-1][y1] > 40){//if man1 is not stopped
	        update_map(x1, y1, map[x1][y1]-10);
                update_map(x1-1, y1, map[x1-1][y1]+10);
	        if(map[x1-1][y1] > 50)
	    	    get_gift(x1-1,y1,1);
            x1--;
            for (i=0;i<TIMES;i++) {
                write_segments(3); // 000011
            }
             usleep(100000); 


            for (i=0;i<TIMES;i++) {
                write_segments(16); // 000001
            }

            for (i=0;i<TIMES;i++) {
                write_segments(0); // 000001
            }
            
        }
         fprintf(stderr,"player1: up\n");  
    }

    if(ins=='d' && man1.status != 5){
        if(map[x1+1][y1] == 20 || map[x1+1][y1] == 0 || map[x1+1][y1] > 40){//if man1 is not stopped
	        update_map(x1, y1, map[x1][y1]-10);
                update_map(x1+1, y1, map[x1+1][y1]+10);
	        if(map[x1+1][y1] > 50)
	    	    get_gift(x1+1,y1,1);
            x1++;
            for (i=0;i<TIMES;i++) {
                write_segments(4); //000100
            } 
            usleep(100000); 

            for (i=0;i<TIMES;i++) {
                write_segments(16); // 000001
            }

            for (i=0;i<TIMES;i++) {
                write_segments(0); // 000001
            }  

        }
         fprintf(stderr,"player1: down\n");  
    }

    if(ins=='b' && man1.status != 2){
         //no bomb is in current location and max number of bombs is not exceeded
        if((map[x1][y1] == 0 || map[x1][y1] == 10 || map[x1][y1] == 20 || map[x1][y1] == 30) && (man1.numOfBombs > 0)) {
            update_map(x1, y1, map[x1][y1]+man1.power);
            man1.numOfBombs--;
            bomb b;
            init_bomb(&b, man1.power, 4000, 1); // 1 is man1, 2 is man2
            bmap[x1][y1] = b;

	    send_to_HW(x1,y1,2,0); 
            send_to_HW(0,0,0,15872); // 11111000 000000  place bomb
       }
   }
   }
}

// control thread for gamepad 2
void *input2_thread (void *ignored){
    struct usb_keyboard_packet packet;
    int transferred,i;
    fprintf(stderr,"enter input1_thread\n");

    while(1){

    while(gameover==1) {
    	sleep(1);
    }

    libusb_interrupt_transfer(keyboard2, endpoint_address_2,
			    (unsigned char *)&packet, sizeof(packet),
		            &transferred,0);
    fprintf(stderr,"%x\n",packet.reserved);
    char ins = parse_packet(&packet);

    if(man2.status ==1 ) {
        if(ins == 'l')
            ins = 'r';
        else if(ins == 'r')
            ins = 'l';
        else if(ins == 'u')
            ins = 'd';
        else if(ins == 'd')
            ins = 'u';
    }

    if(ins=='l' && man2.status != 5){
        if(map[x2][y2-1] == 10 || map[x2][y2-1] == 0 || map[x2][y2-1] > 40){//if man1 is not stopped
	        update_map(x2, y2, map[x2][y2]-20);
                update_map(x2, y2-1, map[x2][y2-1]+20);
	        if(map[x2][y2-1] > 50)
	    	    get_gift(x2,y2-1,2);
            y2--;
            for (i=0;i<TIMES;i++) {
                write_segments(1+8); // 001001
            }
            usleep(100000);

             for (i=0;i<TIMES;i++) {
                write_segments(16+8); // 000001
            }

            for (i=0;i<TIMES;i++) {
                write_segments(0); // 000001
            }

        }
        fprintf(stderr,"player2: left\n");
    }

    if(ins=='r' && man2.status != 5){
        if(map[x2][y2+1] == 10 || map[x2][y2+1] == 0 || map[x2][y2+1] > 40){//if man1 is not stopped
	        update_map(x2, y2, map[x2][y2]-20);
                update_map(x2, y2+1, map[x2][y2+1]+20);
	        if(map[x2][y2+1] > 50)
	    	    get_gift(x2,y2+1,2);
            y2++;
            for (i=0;i<TIMES;i++) {
                write_segments(2+8); // 001010
            } 
            usleep(100000);

            for (i=0;i<TIMES;i++) {
                write_segments(16+8); // 000001
            }
            for (i=0;i<TIMES;i++) {
                write_segments(8); // 000001
            }
                  
        }
        fprintf(stderr,"player2: right\n");  
    }

    if(ins=='u' && man2.status != 5){
        if(map[x2-1][y2] == 10 || map[x2-1][y2] == 0 || map[x2-1][y2] > 40){//if man1 is not stopped
	        update_map(x2, y2, map[x2][y2]-20);
                update_map(x2-1, y2, map[x2-1][y2]+20);
	        if(map[x2-1][y2] > 50)
	    	    get_gift(x2-1,y2,2);
            x2--;
            for (i=0;i<TIMES;i++) {
                write_segments(3+8); // 001011
            }
            usleep(100000);
            for (i=0;i<TIMES;i++) {
                write_segments(8+16); // 000001
            }
            for (i=0;i<TIMES;i++) {
                write_segments(8); // 000001
            }
        }
         fprintf(stderr,":player2: up\n"); 
    }
    if(ins=='d' && man2.status != 5){
        if(map[x2+1][y2] == 10 || map[x2+1][y2] == 0 || map[x2+1][y2] > 40){//if man1 is not stopped
	        update_map(x2, y2, map[x2][y2]-20);
                update_map(x2+1, y2, map[x2+1][y2]+20);
	        if(map[x2+1][y2] > 50)
	    	    get_gift(x2+1,y2,2);
            x2++;
            for (i=0;i<TIMES;i++) {	
                write_segments(4+8); // 001100
            } 
            usleep(100000);  
            for (i=0;i<TIMES;i++) {
                write_segments(8+16); // 000001
            }
             
            for (i=0;i<TIMES;i++) {
                write_segments(8); // 000001
            }

        }
         fprintf(stderr,"player2: down\n");
    }

    if(ins=='b' && man2.status != 2){
        // no bomb is in current location and max number of bombs is not exceeded
        if((map[x2][y2] == 0 || map[x2][y2] == 10 || map[x2][y2] == 20 || map[x2][y2] == 30) && (man2.numOfBombs > 0)) {
            update_map(x2, y2, map[x2][y2]+man2.power);
            man2.numOfBombs--;
            bomb b;
            init_bomb(&b, man2.power, 5000, 2); // 1 is man1, 2 is man2
            bmap[x2][y2] = b;

	    send_to_HW(x2,y2,2,0); 
            send_to_HW(0,0,0,15872); // 11111000 000000  place bomb
        }
   }
   }
}

// timer thread for all placed bombs
void *bomb_thread(void *ignored) {
     int i,j, end, flag;
     while(1) {
        usleep(1000);
	flag = 0;
        for (i=0; i<15; i++) {
            for (j=0; j<19; j++) {
                if (bmap[i][j].time != -1) { // if there is a bomb at i,j
                     bmap[i][j].time--;
                }
                if (bmap[i][j].time == 150+(i*19+j)*4) { // when the bomb's time is up

                     explode(bmap[i][j].power, i, j, bmap[i][j].owner);
                     fprintf(stderr,"exploded!\n");

    		     int end = judge_winner(bmap[i][j].power,i,j, bmap[i][j].owner);
                     if (end != 0) {
			win(end);
			flag = 1;
		        for (i=0;i<TIMES;i++) {
            			write_segments(0); 
        		}
			break;
		     }

		     if (map[i][j] > 0 && map[i][j] < 7)
			update_map(i, j, 0);
		     else
			update_map(i, j, map[i][j]-bmap[i][j].power);

                     if (bmap[i][j].owner == 1) 
                         man1.numOfBombs++;
                     else 
                         man2.numOfBombs++;         
                }
                if (bmap[i][j].time == 0+(i*19+j)*4) { // when the bomb's explosion will disappear
                     vanish(bmap[i][j].power, i, j, bmap[i][j].owner); 
                     bmap[i][j].time = -1;

                }
            }
	 if (flag == 1) break;
        }   
     }           
}
//status thread for man1 man2, also the thread for creating random gifts
void *status_thread(void *ignored){
    int counter = 0;
    while(1) {

	 if (counter == 30) {
             counter = 0;
	     if (map[1][1] == 0) {
	     	int item = create_gift_center(); 
	     	send_to_HW(1,1,item,0); 
             	update_map(1,1,item+30);
	     }
	     if (map[13][17] == 0) {
	     	int item = create_gift_center(); 
	     	send_to_HW(13,17,item,0); 
             	update_map(13,17,item+30);
	     }
	 }

         if(smap[0] > 0)
            if(--smap[0] == 0) {
                smap[0] = -1;
                man1.status = 0;
            }
         if(smap[1] > 0)
            if(--smap[1] == 0) {
                smap[1] = -1;
                man2.status = 0;
            }
         counter++;
         sleep(1);
    }
}

int judge_winner(int power, int x, int y, int owner) {
     int alive1 = 1;
     int alive2 = 1; 
     int left, right, up, down, status;
     left = right = up = down = 1;
     if (owner == 1) {
	status = man1.status; // 3 = ultra, 4 = immunity
     }
     else {
	status = man2.status;
     }

     // judge center
     if(map[x][y] >= 10 && map[x][y] <17) {
        if (man1.status != 4) alive1 = 0;
     }
     if(map[x][y] >= 20  && map[x][y] <27) {
        if (man2.status != 4) alive2 = 0;
     }
     if(map[x][y] >= 30 && map[x][y] <37) {
        if (man1.status != 4) alive1 = 0;
        if (man2.status != 4) alive2 = 0;
     }

     // judge left
     while (left <= power) {
	if (map[x][y-left] == -1 && status != 3) break;
	else if (map[x][y-left] == -2) break;
        else if (map[x][y-left] == 10 || (map[x][y-left] > 10 && map[x][y-left] < 17)) {
             if (man1.status != 4) alive1 = 0; }

        else if (map[x][y-left] == 20 || (map[x][y-left] > 20 && map[x][y-left] < 27)) {
             if (man2.status != 4) alive2 = 0; }

        else if (map[x][y-left] == 30 || (map[x][y-left] > 30 && map[x][y-left] < 37)) {
             if (man1.status != 4) alive1 = 0;
             if (man2.status != 4) alive2 = 0;
	}
	left++;
     }

     // judge right
     while (right <= power) {
	if (map[x][y+right] == -1 && status != 3) break;
	else if (map[x][y+right] == -2) break;
        else if (map[x][y+right] == 10 || (map[x][y+right] > 10 && map[x][y+right] < 17)) {
             if (man1.status != 4) alive1 = 0; }

        else if (map[x][y+right] == 20 || (map[x][y+right] > 20 && map[x][y+right] < 27)) {
             if (man2.status != 4) alive2 = 0; }

        else if (map[x][y+right] == 30 || (map[x][y+right] > 30 && map[x][y+right] < 37)) {
             if (man1.status != 4) alive1 = 0;
             if (man2.status != 4) alive2 = 0;
	}
	right++;
     }

     // judge up
     while (up <= power) {
	if (map[x-up][y] == -1 && status != 3) break;
	else if (map[x-up][y] == -2) break;
        else if (map[x-up][y] == 10 || (map[x-up][y] > 10 && map[x-up][y] < 17)) {
             if (man1.status != 4) alive1 = 0; }

        else if (map[x-up][y] == 20 || (map[x-up][y] > 20 && map[x-up][y] < 27)) {
             if (man2.status != 4) alive2 = 0; }

        else if (map[x-up][y] == 30 || (map[x-up][y] > 30 && map[x-up][y] < 37)) {
             if (man1.status != 4) alive1 = 0;
             if (man2.status != 4) alive2 = 0;
	}
	up++;
     }

     // judge down
     while (down <= power) {
	if (map[x+down][y] == -1 && status != 3) break;
	else if (map[x+down][y] == -2) break;
        else if (map[x+down][y] == 10 || (map[x+down][y] > 10 && map[x+down][y] < 17)) {
             if (man1.status != 4) alive1 = 0; }

        else if (map[x+down][y] == 20 || (map[x+down][y] > 20 && map[x+down][y] < 27)) {
             if (man2.status != 4) alive2 = 0; }

        else if (map[x+down][y] == 30 || (map[x+down][y] > 30 && map[x+down][y] < 37)) {
             if (man1.status != 4) alive1 = 0;
             if (man2.status != 4) alive2 = 0;
	}
	down++;
     }

     if (alive1 == 0 && alive2 == 0) return 3; // draw game
     else if (alive1 == 1 && alive2 == 0) return 1; // man1 wins
     else if (alive1 == 0 && alive2 == 1) return 2; // man2 wins
     else return 0; // nobody dies
}

// game logic for what happens when a bomb explodes
void explode(int power, int x, int y, int owner) {
     int left, right, up, down, status;
     left = right = up = down = 1;

     if (owner == 1) {
	status = man1.status; // 3 = ultra, 4 = immunity
     }
     else {
	status = man2.status;
     }
     
     send_to_HW(x,y,25,0); // send center flame (bomb exploded) to position x,y 
     send_to_HW(0,0,0,16128); // 11111100 000000
     send_to_HW(0,0,0,16128); // 11111100 000000
     send_to_HW(0,0,0,16128); // 11111100 000000

     while (left <= power) {
        if (map[x][y-left] == 0 || map[x][y-left] == 10 || map[x][y-left] == 20 || map[x][y-left] == 30 || map[x][y-left] > 40 || (1<=map[x][y-left] && map[x][y-left]<=6)) {
             if (map[x][y-left] > 40) 
		update_map(x, y-left, 0);
             if (left == power) 
                send_to_HW(x,y-left,28,0); // left flame
             else 	         
                send_to_HW(x,y-left,26,0); // horizontal flame
        }
        else if (map[x][y-left] == -1) {
	        send_to_HW(x,y-left,26,0); // left flame
                if (status != 3) break; 
         }
        else if (map[x][y-left] == -2)
             break;
        left++;
    }

     while (right <= power) {
        if (map[x][y+right] == 0 || map[x][y+right] == 10 || map[x][y+right] == 20 || map[x][y+right] == 30 || map[x][y+right] > 40 || (1<=map[x][y+right] && map[x][y+right]<=6)) {
	     if (map[x][y+right] > 40)
                 update_map(x, y+right, 0);
             if (right == power) 
                send_to_HW(x,y+right,29,0); // right flame
             else 	         
                send_to_HW(x,y+right,26,0); // horizontal flame
        }
        else if (map[x][y+right] == -1) {
	        send_to_HW(x,y+right,26,0); // right flame
                if (status != 3) break; 
	}
        else if (map[x][y+right] == -2 )
            break;
        right++;
    }

     while (up <= power) {
        if (map[x-up][y] == 0 || map[x-up][y] == 10 || map[x-up][y] == 20 || map[x-up][y] == 30|| map[x-up][y] > 40 || (1<=map[x-up][y] && map[x-up][y]<=6)) {
	     if (map[x-up][y] > 40)
                update_map(x-up, y, 0);
             if (up == power) 
                send_to_HW(x-up,y,30,0); // up flame
             else 	         
                send_to_HW(x-up,y,27,0); // vertical flame
        }
        else if (map[x-up][y] == -1) {
	         send_to_HW(x-up,y,27,0); // up flame
                 if (status != 3) break; 
	}
        else if (map[x-up][y] == -2 )
             break;
        up++;
    }

     while (down <= power) {
        if (map[x+down][y] == 0 || map[x+down][y] == 10 || map[x+down][y] == 20 || map[x+down][y] == 30|| map[x+down][y] > 40|| (1<=map[x+down][y] && map[x+down][y]<=6)) {
	     if (map[x+down][y] > 40)
                update_map(x+down, y, 0);
             if (down == power) 
                send_to_HW(x+down,y,31,0); // down flame
             else 	         
                send_to_HW(x+down,y,27,0); // vertical flame
        }
        else if (map[x+down][y] == -1) {
	         send_to_HW(x+down,y,27,0); // down flame
                 if (status != 3) break; 
	}
        else if (map[x+down][y] == -2) 
             break;
        down++;
     }

}

// game logic for making flames disappear, and add in grass/gift accordingly
void vanish(int power, int x, int y, int owner) {
     int left, right, up, down, status;
     left = right = up = down = 1;

     if (owner == 1) 
	status = man1.status;
     else
	status = man2.status;

     send_to_HW(x,y,0,0); // send grass to position x,y

     while (left <= power) {
	if (map[x][y-left] == 0 || map[x][y-left] == 10 || map[x][y-left] == 20 || map[x][y-left] == 30) 
	     send_to_HW(x,y-left,0,0);
        else if (map[x][y-left] == -1) {
             int item = create_gift();
	     send_to_HW(x,y-left,item,0); 
             
             if (item != 0)
                update_map(x, y-left, item+30); // gift is left
             else
                update_map(x, y-left, item);
		 
             if (status != 3) break; 
        }
        else if (map[x][y-left] == -2)
             break;
	else if (1<=map[x][y-left] && map[x][y-left]<=6) 
	     send_to_HW(x,y-left,2,0); 
        left++;
    }

     while (right <= power) {
	if (map[x][y+right] == 0 || map[x][y+right] == 10 || map[x][y+right] == 20 || map[x][y+right] == 30)
	      send_to_HW(x,y+right,0,0); 
        else if (map[x][y+right] == -1) {
	     int item = create_gift();
	     send_to_HW(x,y+right,item,0); 

             if (item != 0)
                 update_map(x, y+right, item+30); // gift is left
             else
                 update_map(x, y+right, item);

             if (status != 3) break; 
	}
        else if (map[x][y+right] == -2)
             break;
	else if (1<=map[x][y+right] && map[x][y+right]<=6)
	      send_to_HW(x,y+right,2,0); 
        right++;
    }

     while (up <= power) {
	if (map[x-up][y] == 0 || map[x-up][y] == 10 || map[x-up][y] == 20 || map[x-up][y] == 30)
	     send_to_HW(x-up,y,0,0);
        else if (map[x-up][y] == -1) {
	     int item = create_gift();
	     send_to_HW(x-up,y,item,0);

             if (item != 0)
                 update_map(x-up, y, item+30); // gift is left
             else
                 update_map(x-up, y, item);

             if (status != 3) break; 
	}
        else if (map[x-up][y] == -2)
             break;
	else if (1<=map[x-up][y] && map[x-up][y]<=6)
	      send_to_HW(x-up,y,2,0); 
        up++;
    }

     while (down <= power) {
	if (map[x+down][y] == 0 || map[x+down][y] == 10 || map[x+down][y] == 20 || map[x+down][y] == 30)
	     send_to_HW(x+down,y,0,0);
        else if (map[x+down][y] == -1) {
	     int item = create_gift();
             send_to_HW(x+down,y,item,0);

             if (item != 0)
                 update_map(x+down, y, item+30); // gift is left
             else
                 update_map(x+down, y , item);

             if (status != 3) break; 
	}
        else if (map[x+down][y] == -2)
             break;
	else if (1<=map[x+down][y] && map[x+down][y]<=6)
	     send_to_HW(x+down,y,2,0);
        down++;
     }
}

// game logic for generating a gift when a soft brick is destroyed
int create_gift() {
    int i, num;
    num = rand() % 100 + 1; // return num between 1 and 100

    if (num <= 60) {
        return 0; // grass, 60%
    }
    else if (num <= 63) {
        return 13; // skull, 3%
    }
    else if (num <= 78) {
        return 11; // +bomb, 15%
    }
    else if (num <= 93) {
        return 12; // +power, 15%
    }
    else if (num <= 96) {
        return 14; // ultra, 4%
    }
    else if (num <= 98) {
        return 15; // immunity, 4%
    }
    else 
        return 16; // stop, 3%
}

// game logic for generating a gift when the center brick is destroyed
int create_gift_center() {
    int i, num;
    num = rand() % 5 + 1; // return num between 1 and 5

    if (num == 1) {
        return 11; // +bomb, 12%
    }
    else if (num == 2) {
        return 12; // +power, 12%
    }
    else if (num == 3) {
        return 14; // ultra, 4%
    }
    else if (num == 4) {
        return 15; // immunity, 4%
    }
    else 
        return 16; // stop, 3%
}

// game logic for a character getting a gift
void get_gift(int x, int y, int man) {
    if (man == 1) {
        if (map[x][y] == 51) //addBomb
	    if (man1.numOfBombs < 8 )man1.numOfBombs++;
	
        if (map[x][y] == 52) {// addPower
	    if (man1.power < 6) man1.power++;
        }
	
        if (map[x][y] == 53) {// skull
            man1.status = rand() % 2 + 1;
            smap[0] = 8;
        }

	if (map[x][y] == 54) {// ultra
	    man1.status = 3;
	    smap[0] = 8;
	}

	if (map[x][y] == 55) {// immunity
	    man1.status = 4;
	    smap[0] = 8;
	}

	if (map[x][y] == 56) {// stop
	    int whoStops = rand() % 2 + 1;
	    if (whoStops == 1) {
	    	man2.status = 5;
	    	smap[1] = 3;
	    }
	    else {
	    	man1.status = 5;
	    	smap[0] = 3;
	    }
	}

        update_map(x, y, 10);
    }

    else { // man == 2
        if (map[x][y] == 61) //addBomb
	    if (man2.numOfBombs < 8 ) man2.numOfBombs++;

        if (map[x][y] == 62) {// addPower
	    if (man2.power < 6) man2.power++;
	    }

        if(map[x][y] == 63) { //skull
            man2.status = rand() % 2 + 1;
            smap[1] = 8;
        }

	if (map[x][y] == 64) {// ultra
	    man2.status = 3;
            smap[1] = 8;
	}

	if (map[x][y] == 65) {// immunity
	    man2.status = 4;
            smap[1] = 8;
	}

	if (map[x][y] == 66) {// stop
	    int whoStops = rand() % 2 + 1;
	    if (whoStops == 1) {
	    	man2.status = 5;
	    	smap[1] = 3;
	    }
	    else {
	    	man1.status = 5;
	    	smap[0] = 3;
	    }
	}

        update_map(x, y, 20);
    }
	
    send_to_HW(x,y,0,0);
}

// game logic for what happens when the game is over
void win(int winner) {
    int i,j,k;
    int winTimes = 50;
    send_to_HW(0,0,0,16256); // 11111110 000000  game over
    send_to_HW(0,0,0,16256); // 11111110 000000  game over
    send_to_HW(0,0,0,16256); // 11111110 000000  game over
    gameover = 1;
    if (winner == 1) {
         for (k = 0; k < 5; k++) {
            for (i=0;i<winTimes;i++) {
                write_segments(5); // 000101 -> man1 jumps
 		fprintf(stderr, "%s\n ", "man1 wins");
            }    
	    usleep(10);
            for (i=0;i<winTimes;i++) {
                write_segments(14); // 001110 -> man2 sits
            }
	    usleep(10);    
         }

    }

    if (winner == 2) {
         for (k = 0; k < 5; k++) {
            for (i=0;i<winTimes;i++) {
                write_segments(6); // 000110 -> man1 sits
 		fprintf(stderr, "%s\n ", "man2 wins");
            }
	    usleep(10);    
            for (i=0;i<winTimes;i++) {
                write_segments(13); // 001101 -> man2 jumps
            }
	    usleep(10); 
	}
    }

    if (winner == 3) { // draw
         for (k = 0; k < 5; k++) {
            for (i=0;i<winTimes;i++) {
                write_segments(6); // 000110 -> man1 sits
 		fprintf(stderr, "%s\n ", "draw game");
            }
	    usleep(10);    
            for (i=0;i<winTimes;i++) {
                write_segments(14); // 001101 -> man2 sits
            }
	    usleep(10);  
	}
    }

    sleep(5);
    init_map();
    init_bmap();
    init_bomberman();
    init_smap();
    gameover = 0;


    for (i=1; i<14; i++) {
         for (j=1; j<18; j++) {
 		send_to_HW(i,j,0,0);
	 }
    }


    for (i=0;i<20;i++) {
        write_segments(16320); // reset signal 11111111 000000
        fprintf(stderr, "%s\n ", "sending reset signal");
    }

}

int main()
{
	  vga_led_arg_t vla;
	  static const char filename[] = "/dev/vga_led";
	 // static unsigned int message[2] = {0x10, 0x10}; // initial position

	  printf("VGA LED Userspace program started\n");

	  if ( (vga_led_fd = open(filename, O_RDWR)) == -1) {
	    fprintf(stderr, "could not open %s\n", filename);
	    return -1;
	  }
	  
	  int i,j,k;
	  for (i=1; i<14; i++) {
             for (j=1; j<18; j++) {
		send_to_HW(i,j,0,0);
	     }
	  }
          for (k=0;k<20;k++) {
                 write_segments(16320); // reset signal 11111111 000000
	 	 fprintf(stderr, "%s\n ", "sending reset signal");
          }

	  init_map(); 
	  init_bmap();
          init_smap();
	  init_bomberman();

          srand( time(NULL) );

	  //open gamepad1
	  if((keyboard1 = openkeyboard(&endpoint_address_1,1)) == NULL) {
	      fprintf(stderr, "did not find gamepad1\n");
	      exit(1);
	  }
	  //open gamepad2

	  if((keyboard2 = openkeyboard(&endpoint_address_2,2)) == NULL) {
	      fprintf(stderr, "did not find gamepad2\n");
	      exit(1);
	  }
	  
	  pthread_t handler_thread_1 ;
	  pthread_create(&handler_thread_1, NULL, input1_thread, NULL);  
	  
	  pthread_t handler_thread_2;
	  pthread_create(&handler_thread_2, NULL, input2_thread, NULL);

	  pthread_t handler_thread_3;
	  pthread_create(&handler_thread_3, NULL, bomb_thread, NULL);
          
          pthread_t handler_thread_4;
          pthread_create(&handler_thread_4, NULL, status_thread, NULL);


	// test for sending controls to hardware, bypassing gamepad
	/*  
	  while(1) {
	        int i;
	        sleep(2);
	        for (i = 0; i < 10; i++) 
	                write_segments(1);
	        fprintf(stderr, "sent right (2)\n");
	     //   sleep(1/60);
	     //   write_segments(0);
	               
	        sleep(2);
	        for (i = 0; i < 10; i++)
	                write_segments(3);
	        fprintf(stderr, "sent down (4)\n");
	     //   sleep(1/60);
	     //   write_segments(0);

	        continue;
	  }
	*/

	// test for software game logic

	  while(1){
	  
	  sleep(5);
	  for(i=0; i<15; i++){
	      for(j=0; j<19; j++){
	        fprintf(stderr, "%d  ", map[i][j]);
	      }
	      fprintf(stderr, "\n");        
	  }
	  fprintf(stderr,"-----------------------------------------\n");
	  for(i=0; i<15; i++){
	      for(j=0; j<19; j++){
	        fprintf(stderr, "%d  ", bmap[i][j].time);
	      }
	      fprintf(stderr, "\n");
	  }
	fprintf(stderr,"-----------------------------------------\n");

	  continue;
	  
	}

	  while(1) {
	        continue;
	  }
	  printf("VGA LED Userspace program terminating\n");
	  return 0;
}
