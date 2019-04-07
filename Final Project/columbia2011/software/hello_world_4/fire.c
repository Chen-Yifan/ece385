#ifndef FIRE_C_
#define FIRE_C_

#include "fire.h"
extern struct game{
  int step;
  int start_time;
  int current_time;
}g;

enum tile {EMPTY  ,BOMB  ,FIRE   ,BRICK   ,
           POWERUP,BOMBUP,SPEEDUP,TBD1    ,
           TBD2   ,TBD3  ,TBD4   ,TBD5    ,
           TBD6   ,TBD7  ,TBD8   ,CONCRETE,
           EXPLODING};
extern int control_array[15][20];

struct fire *ffirst = NULL;
struct fire *flast  = NULL;

int insert_fire(int x,int y){
  struct fire *f;
  f = (struct fire*)malloc(sizeof(struct fire));
  f->px=x;
  f->py=y;  
  f->timer= g.current_time + 100;
  
  if(ffirst == NULL){
     ffirst =  flast = f;
     f->prev = NULL;  
  } else{
     f->prev = flast;
     flast->next = f;
     flast = f;  
  }
  f->next = NULL;
  
  return 0;

}
int delect_fire(struct fire f){
    struct fire *temp;
    temp = ffirst;
    while(temp!=NULL){
      if(temp->px == f.px && temp->py == f.py){
        set_tile(f.px,f.py,EMPTY);
        if(temp->prev==NULL) ffirst = temp->next;
        else temp->prev->next = temp->next;
        if(temp->next==NULL) flast = temp->prev;
        else temp->next->prev = temp->prev;
        free(temp);             
      break;
      }        
      temp = temp->next;        
    }   
    return 0;
}
int countdown_fire(){
    struct fire *temp;
    int i ;
    temp = ffirst;
    for(i = 0; i < 200 ; i++){
    if(temp!=NULL){
      if(temp->timer<g.current_time) delect_fire(*temp);
      temp = temp ->next;
      }
    }
    return 0; 
}
#endif /*FIRE_C_*/
