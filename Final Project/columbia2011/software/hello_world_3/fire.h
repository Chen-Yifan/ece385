#ifndef FIRE_H_
#define FIRE_H_
#include <stdio.h>
#include <io.h>
#include <system.h>
#include <time.h>
struct fire{
    int px;
    int py;
    int timer;
    struct fire *next,*prev; 
};

int insert_fire(int,int);
int delect_fire(struct fire);
int countdown_fire();
extern void set_tile(int x,int y,int thing); 

#endif /*FIRE_H_*/
