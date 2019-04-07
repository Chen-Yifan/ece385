typedef struct Bomberman{
    int numOfBombs;
    int power;
    int status; // 0=nothing, 1=reverse, 2=...
    int special;
}bomberman;

typedef struct Bomb{
    int power;
    int time;
    int owner;
}bomb;

