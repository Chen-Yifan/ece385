
#include "bomb.h"
#include "fire.h"
#define CONCRETE 63
extern int control_array[15][20];

extern struct game{
  int step;
  int start_time;
  int current_time;
}g;

struct bomb *first = NULL;
struct bomb *last  = NULL;

enum tile {EMPTY  ,BOMB  ,FIRE   ,BRICK   ,
           POWERUP,BOMBUP,SPEEDUP,TBD1    ,
           TBD2   ,TBD3  ,TBD4   ,TBD5    ,
           TBD6   ,TBD7  ,TBD8   ,EXPLODING};
           
enum player {player1, player2, player3, player4};
                                        
int insert_bomb(int x,int y, int power,int player){
  struct bomb *b;
  b = (struct bomb*)malloc(sizeof(struct bomb));
  b->px=x;
  b->py=y;
  b->power=power;
  b->timer= g.current_time + 300;
  b->player = player;
  if(first == NULL){
     first = last = b;
     b->prev = NULL;  
  } else{
     b->prev = last;
     last->next = b;
     last = b;  
  }
  b->next = NULL;
  return 0;
}

int delect_bomb(struct bomb b){
  struct bomb *temp;
  temp = first;
  while(temp!=NULL){
      if(temp->px == b.px && temp->py == b.py){
        if(temp->prev==NULL) first = temp->next;
        else temp->prev->next = temp->next;
        if(temp->next==NULL) last = temp->prev;
        else temp->next->prev = temp->prev;
        free(temp);             
      break;
      }        
      temp = temp->next;
  } 
  return 0;
}

int countdown_bomb(){
  struct bomb *temp;
  temp = first;
  int i,j;
  
  for(i = 0; i < 200 ; i++){
  if(temp!=NULL){
      if(temp->timer < g.current_time ) explosion_bomb(*temp);
      temp = temp ->next;
    }
  }
  for(i = 0 ; i < 15 ; i++){
     for(j = 0 ; j < 20 ; j++){
       if(control_array[i][j] == EXPLODING ){
          set_tile(j,i,FIRE);
          insert_fire(j,i);
       }  
     }
  }   
  return 0;
}

int find_explo_bomb(int x, int y){
    struct bomb *temp; 
    temp = first;
    
    while(temp!=NULL){ 
      if(temp->px == x && temp->py == y){
        return explosion_bomb(*temp);        
      }
      temp = temp->next;      
    }
   
    return 0;
}

int explosion_bomb(struct bomb b){
   int j;
   int seed;
   int rstop = 1;
   int lstop = 1;
   int ustop = 1;
   int dstop = 1;
   
 explo_sound();
   
   srand((b.px*b.py)%(b.px+b.py));
   
   control_array[b.py][b.px] = EXPLODING;   
   
   
   for(j = 1; j <= b.power; j ++){
       ///////////////////////Left////////////////////
       if(lstop){
       //////////////////////Empty///////////////////
       if(control_array[b.py][b.px-j] == EMPTY){
           set_tile(b.px-j,b.py,FIRE);
           insert_fire(b.px-j,b.py);
       ///////////////////////Bomb///////////////////             
       } else if(control_array[b.py][b.px-j] == BOMB){
           find_explo_bomb(b.px-j,b.py);
           lstop = 0;           
       //////////////////////Prev Bomb///////////////    
       } else if(control_array[b.py][b.px-j] == EXPLODING){
           lstop = 0;    
       } else {
       /////////////////////Other Thing///////////// 
              if( control_array[b.py][b.px-j] != CONCRETE){
                 if( control_array[b.py][b.px-j] == BRICK){                    
                    seed = rand()%4+4;
                    if(seed >= 7) seed = EMPTY;              
                    set_tile(b.px-j,b.py,seed);
                 }                       
              } 
              lstop = 0;
         }                     
       }
       
       
       
       ///////////////////////right////////////////////
       if(rstop){
       //////////////////////Empty///////////////////
       if(control_array[b.py][b.px+j] == EMPTY){
            set_tile(b.px+j,b.py,FIRE);
            insert_fire(b.px+j,b.py);  
       //////////////////////Bomb////////////////////     
       }else if(control_array[b.py][b.px+j] == BOMB){
           find_explo_bomb(b.px+j,b.py);
           rstop = 0;
       //////////////////////Prev Bomb///////////////     
       }else if(control_array[b.py][b.px+j] == EXPLODING){
           rstop = 0; 
       }else{
       /////////////////////Other Thing////////////// 
             if( control_array[b.py][b.px+j] != CONCRETE){
                 if( control_array[b.py][b.px+j] == BRICK){   
                    seed = rand()%4+4;
                    if(seed >= 7) seed = 0;              
                    set_tile(b.px+j,b.py,seed);                                
                 }              
              }
              rstop = 0;             
           }
        }
        
        
       ////////////////////////////down///////////////// 
        if(dstop){
        if(control_array[b.py+j][b.px] == 0){
             set_tile(b.px , b.py+j ,FIRE);
             insert_fire(b.px,b.py+j);      
        }else if(control_array[b.py+j][b.px] == 1){
           find_explo_bomb(b.px,b.py+j);
           dstop = 0;
        } else if(control_array[b.py+j][b.px] == EXPLODING){
           dstop = 0; 
        }else{
             if( control_array[b.py+j][b.px] != CONCRETE){
                 if( control_array[b.py+j][b.px] == BRICK){   
                    seed = rand()%4+4;
                    if(seed >= 7) seed = 0;            
                    set_tile(b.px,b.py+j,seed);
                 }                             
             }
            dstop = 0;
          }
        }          
       ////////////////////////////up/////////////////
       if(ustop){
        if(control_array[b.py-j][b.px] == 0){ 
           set_tile(b.px , b.py-j ,FIRE);
           insert_fire(b.px,b.py-j);      
        } else if(control_array[b.py-j][b.px] == 1){
           find_explo_bomb(b.px,b.py-j);
           ustop = 0;
        } else if(control_array[b.py][b.px+j] == EXPLODING){
           ustop = 0;           
        }else{
            if( control_array[b.py-j][b.px] != 15){
                 if( control_array[b.py-j][b.px] == 3){   
                    seed = rand()%4+4;
                    if(seed >= 7) seed = 0;            
                    set_tile(b.px,b.py-j,seed);
                 }                   
            }
           ustop = 0;
        } 
       }   
   }

   delect_bomb(b);
   return 0;
}

int checkbomb(int player){
  struct bomb *temp;
  temp = first;
  while(temp!=NULL){
         if(temp->player == player2){ 
         player--;
         if(player==0) return 0;
         }
         temp = temp->next;    
  }    
  return 1;
}

void print_bomb(){
   struct bomb *temp;
   temp = first;
   printf("\n====================Bombs=====================\n");
   while(temp!=NULL){ 
   printf("px %d py %d power %d timer %d\n",
          temp->px,temp->py,temp->power,temp->timer);
   temp = temp->next; 
   }  
}