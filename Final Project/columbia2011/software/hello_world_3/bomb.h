#ifndef BOMB_H_
#define BOMB_H_
#include <stdio.h>
#include <io.h>
#include <system.h>
#include <time.h>

struct bomb{
    int px;
    int py;
    int power;
    int timer;
    int player;
    struct bomb *next,*prev; 
};

int insert_bomb(int,int,int,int);
int delect_bomb(struct bomb);
int explosion_bomb(struct bomb);
int countdown_bomb();
int find_explo_bomb(int,int);
int checkbomb(int);
void print_bomb();
extern void set_tile(int x,int y,int thing); 
                     

#endif /*BOMB_H_*/
