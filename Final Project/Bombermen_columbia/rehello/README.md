# bomberman

software representations
-------------------------
man1:10
man2:20
bomb:1,2,3,4,5,6,
hardbrick:-2
grass:0
softbrick:-1


movement
------------------------
left:4 (usb)---1 (verilog)
right:8---2
up:1---3
down:2----4
win: ---5
loss: ---6

A:1(usb)
B:2
X:4
Y:8

software to hardware 
-------------------------
need addr*64 + 32 + item
bomb = 2
grass = 0 

center flame = 25
horizontal flame = 26
vertical flame = 27
left flame = 28
right flame = 29
up flame = 30
down flame = 31
 
gifts
-------------------------
addBomb: 41
addPower: 42

ultra: 44, status:3
immunity: 45, status:4
stop: 46, status:5

include all of below in skull: 43
~reverse: status:1 
~constipation: status :2





