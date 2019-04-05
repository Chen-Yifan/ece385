---------------------------------------------------------------------------
--      Main.vhd                                                         --
--      Matthew Grawe & Larry Resnik                                     --
--      Spring 2014 ECE 385 Final Project                                --
--                                                                       -- 
--                                                                       --
--      The Main entity brings the entire game together, stitching       --
--      all of the functionality together into a cohesive final          --
--      product. Additionally, we handle tile randomization and          --
--      bomb reaction code, and exit panel handling here.                --
--                                                                       --
---------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Main is
    Port ( 
           CE, UB, LB, OE, WE     : out std_logic;
           ADDR                   : out std_logic_vector(17 downto 0);
           AUD_MCLK               : out std_logic;
           AUD_DACDAT             : out std_logic;
           I2C_SDAT               : out std_logic;
           I2C_SCLK               : out std_logic;
           RAM_DATA               : in  std_logic_vector(15 downto 0);
           AUD_BCLK               : in  std_logic;
           AUD_ADCDAT             : in  std_logic; 
           AUD_DACLRCK            : in  std_logic;
           AUD_ADCLRCK            : in  std_logic;
           TEST_SOUND             : in  std_logic;
           LEDProgressBar         : out std_logic_vector(10 downto 0);
           Clk : in std_logic;
           Reset : in std_logic;
           ps2data : in std_logic;
           ps2clk : in std_logic;
           Red   : out std_logic_vector(9 downto 0);
           Green : out std_logic_vector(9 downto 0);
           Blue  : out std_logic_vector(9 downto 0);
           VGA_clk : out std_logic; 
           sync : out std_logic;
           blank : out std_logic;
           vs : out std_logic;
           hs : out std_logic;
           KeyHexL : out std_logic_vector(6 downto 0);
           KeyHexU : out std_logic_vector(6 downto 0);
           HexOutLeft : out std_logic_vector(6 downto 0);
           HexOutRight : out std_logic_vector(6 downto 0));
end Main;

architecture Behavioral of Main is

component PlayerEntity is
Port(   Reset : in std_logic;
        Clk : in std_logic;
        frame_clk : in std_logic;
        KeyInput : in std_logic_vector(7 downto 0);
        MovementFlags : in std_logic_vector(3 downto 0);
        Tiles0 : in std_logic_vector(43 downto 0);
        Tiles1 : in std_logic_vector(43 downto 0);
        Tiles2 : in std_logic_vector(43 downto 0);
        Tiles3 : in std_logic_vector(43 downto 0);
        Tiles4 : in std_logic_vector(43 downto 0);
        Tiles5 : in std_logic_vector(43 downto 0);
        Tiles6 : in std_logic_vector(43 downto 0);
        Tiles7 : in std_logic_vector(43 downto 0);
        Tiles8 : in std_logic_vector(43 downto 0);
        BombermanX : out std_logic_vector(9 downto 0);
        BombermanY : out std_logic_vector(9 downto 0);
        BombermanW : out std_logic_vector(9 downto 0);
        BombermanH : out std_logic_vector(9 downto 0);
        BombermanS : out std_logic_vector(9 downto 0);
        BombermanSpeedX : out std_logic_vector(9 downto 0);
        BombermanSpeedY : out std_logic_vector(9 downto 0);
        GotHit : out std_logic;
        ResetBombermanPos : in std_logic;
        Debug : out std_logic_vector(7 downto 0));
end component;

component GameState is
Port (  Clk : in std_logic;
        Reset : in std_logic;
        PressedStart : in std_logic;
        TimeUp : in std_logic;
        CurrentState : out std_logic_vector(3 downto 0)
        );
end component;

component PlayerState is
Port (  Clk : in std_logic;
        Reset : in std_logic;
        GotHit : in std_logic;
        BombermanSpeedX : in std_logic_vector(9 downto 0);
        BombermanSpeedY : in std_logic_vector(9 downto 0);
        PlayerStateValue : out std_logic_vector(3 downto 0)
);
end component;

component VGAController is
    Port ( clk : in std_logic;
           reset : in std_logic;
           hs : out std_logic;
           vs : out std_logic;
           pixel_clk : out std_logic;
           blank : out std_logic;
           sync : out std_logic;
           DrawX : out std_logic_vector(9 downto 0);
           DrawY : out std_logic_vector(9 downto 0));
end component;

component Level is
Port(   Clk : in std_logic;
        Reset : in std_logic;
        NewTiles0 : in std_logic_vector(43 downto 0);
        NewTiles1 : in std_logic_vector(43 downto 0);
        NewTiles2 : in std_logic_vector(43 downto 0);
        NewTiles3 : in std_logic_vector(43 downto 0);
        NewTiles4 : in std_logic_vector(43 downto 0);
        NewTiles5 : in std_logic_vector(43 downto 0);
        NewTiles6 : in std_logic_vector(43 downto 0);
        NewTiles7 : in std_logic_vector(43 downto 0);
        NewTiles8 : in std_logic_vector(43 downto 0);
        Tiles0 : out std_logic_vector(43 downto 0);
        Tiles1 : out std_logic_vector(43 downto 0);
        Tiles2 : out std_logic_vector(43 downto 0);
        Tiles3 : out std_logic_vector(43 downto 0);
        Tiles4 : out std_logic_vector(43 downto 0);
        Tiles5 : out std_logic_vector(43 downto 0);
        Tiles6 : out std_logic_vector(43 downto 0);
        Tiles7 : out std_logic_vector(43 downto 0);
        Tiles8 : out std_logic_vector(43 downto 0));
end component Level;

component MapRowAccess is
Port(   Clk : in std_logic;
        Addr : in std_logic_vector(3 downto 0);
        Tiles0 : in std_logic_vector(43 downto 0);
        Tiles1 : in std_logic_vector(43 downto 0);
        Tiles2 : in std_logic_vector(43 downto 0);
        Tiles3 : in std_logic_vector(43 downto 0);
        Tiles4 : in std_logic_vector(43 downto 0);
        Tiles5 : in std_logic_vector(43 downto 0);
        Tiles6 : in std_logic_vector(43 downto 0);
        Tiles7 : in std_logic_vector(43 downto 0);
        Tiles8 : in std_logic_vector(43 downto 0);
        Row : out std_logic_vector(43 downto 0));
end component MapRowAccess;

component ColorMapper is
Port (  BombermanX : in std_logic_vector(9 downto 0);
        BombermanY : in std_logic_vector(9 downto 0);
        BombermanWidth : in std_logic_vector(9 downto 0);
        BombermanHeight : in std_logic_vector(9 downto 0);
        DrawX : in std_logic_vector(9 downto 0);
        DrawY : in std_logic_vector(9 downto 0);
        Bomberman_size : in std_logic_vector(9 downto 0);
        BombX : in std_logic_vector(9 downto 0);
        BombY : in std_logic_vector(9 downto 0);
        BombState : in std_logic_vector(2 downto 0);
        Tiles0 : in std_logic_vector(43 downto 0);
        Tiles1 : in std_logic_vector(43 downto 0);
        Tiles2 : in std_logic_vector(43 downto 0);
        Tiles3 : in std_logic_vector(43 downto 0);
        Tiles4 : in std_logic_vector(43 downto 0);
        Tiles5 : in std_logic_vector(43 downto 0);
        Tiles6 : in std_logic_vector(43 downto 0);
        Tiles7 : in std_logic_vector(43 downto 0);
        Tiles8 : in std_logic_vector(43 downto 0);
        GameStateValue : in std_logic_vector(3 downto 0);
        PlayerStateValue : in std_logic_vector(3 downto 0);
        progressBar : in std_logic_vector(10 downto 0);
        floorCounter : in std_logic_vector(10 downto 0);
        Clk   : in std_logic;
        Reset : in std_logic;
        Red   : out std_logic_vector(9 downto 0);
        Green : out std_logic_vector(9 downto 0);
        Blue  : out std_logic_vector(9 downto 0));
end component;

component clock_divider is
port(ClkIn  : in  std_logic;
     Reset  : in  std_logic;
     ClkOut  : out  std_logic);
end component;

component SignalSync is
Port (  Clk : in std_logic;
        PS2Clk : in std_logic;
        Reset : in std_logic;
        ps2ClkIsFallingEdge : out std_logic);
end component;

component DataFrame is
Port ( Reset : in std_logic;
       KeyIn : in std_logic;
       Clk : in std_logic;
       OnStart : out std_logic);
end component;

component KeyboardVhdl is
	Port (	CLK, RST, ps2Data, ps2Clk, NewKeyAck: in std_logic;
				keyCode : out std_logic_vector(7 downto 0);
				newKeyOut : out std_logic);
end component;

component HexDriver is
Port (  In0 : in std_logic_vector(3 downto 0);
        Out0 : out std_logic_vector(6 downto 0));
end component HexDriver;

component SOUND is
Port(
        CE, UB, LB, OE, WE :  out std_logic;
        ADDR               :  out std_logic_vector(17 downto 0);
        RAM_DATA           :  in  std_logic_vector(15 downto 0);
        --SWITCHES           :  in  std_logic_vector(17 downto 0);
        EXPLOSION_SOUND    :  in  std_logic;
        BOMB_PLACE_SOUND   :  in  std_logic;
        DEATH_SOUND        :  in  std_logic;
        CLK                :  in  std_logic;
        Reset              :  in  std_logic;
        AUD_MCLK           :  out std_logic;
        AUD_BCLK           :  in  std_logic;
        AUD_ADCDAT         :  in  std_logic;
        AUD_DACDAT         :  out std_logic;
        AUD_DACLRCK        :  in  std_logic;
        AUD_ADCLRCK        :  in  std_logic;
        I2C_SDAT           :  out std_logic;
        I2C_SCLK           :  out std_logic
        --LEDS               :  out std_logic_vector(17 downto 0)
    );
end component SOUND;

component bomb is
Port (  setX                 : in  std_logic_vector(9 downto 0);
        setY                 : in  std_logic_vector(9 downto 0);
        getX                 : out std_logic_vector(9 downto 0);
        getY                 : out std_logic_vector(9 downto 0);
        bomb_sound_flag      : out std_logic;
        explosion_sound_flag : out std_logic;
        Reset                : in  std_logic;
        set_fuse             : in  std_logic;
        bomb_state           : out std_logic_vector(2 downto 0);
        clk                  : in  std_logic;
        paused               : in  std_logic
        --LEDS                 : out  std_logic_vector(17 downto 0)
        );
end component bomb;


signal Reset_h, vsSig : std_logic;
signal DrawXSig, DrawYSig, BombermanXSig, BombermanYSig, BombermanWidthSig, BombermanHeightSig, BombermanSSig : std_logic_vector(9 downto 0);
-- After a successful keyboard data frame read (all 11 bits read), KeyInput is the read-in key press (parity included).
signal KeyInput : std_logic_vector(7 downto 0);
-- If the Data Frame has seen the STOP bit, OnStart will be HIGH.
signal OnStart : std_logic;
-- This is Clk divided by 512 such that the next edge transition happens on the 512th edge transition of Clk.
signal DividedClk : std_logic;
-- This is the forcefully delayed FPGA clock. From DividedClk, this clock goes through an edge transition when
-- both DividedClk and the keyboard clock synchronize an edge transition.
signal SyncedClk : std_logic;
-- When we see the "F0" start of the Breakcode sent by the keyboard, react to it.
-- Namely, we will keep the HexDisplay showing the original keycode sent.
signal OnBreakcode : std_logic;
-- Outputs that merely state the direction we move in.
signal MoveLeft, MoveRight, MoveUp, MoveDown : std_logic;
-- Signals that connect to the Level map.
signal Tiles0, Tiles1, Tiles2, Tiles3, Tiles4, Tiles5, Tiles6, Tiles7, Tiles8 : std_logic_vector(43 downto 0);
signal NewTiles0, NewTiles1, NewTiles2, NewTiles3, NewTiles4, NewTiles5, NewTiles6, NewTiles7, NewTiles8 : std_logic_vector(43 downto 0);
-- The booleans that define which direction we are moving in.
signal MovementFlags : std_logic_vector(3 downto 0);
-- Game state signals.
signal onExit, PressedStart, IsPaused : std_logic;
signal GameStateValue : std_logic_vector(3 downto 0);

-- Bomberman/Player oriented signals.
signal PlayerStateValue : std_logic_vector(3 downto 0);
signal BombermanSpeedX, BombermanSpeedY : std_logic_vector(9 downto 0);
signal ResetBombermanPos, GotHitSig : std_logic;

-- Signal(s) used only for debugging. Not essential for the running of the program.
signal BombermanDebugSig : std_logic_vector(7 downto 0);

-- Signals for music and sound effect handling.
signal RAM_DATASig                                             : std_logic_vector(15 downto 0);

-- To play a sound, raise these signals high for one clock cycle, then on the next clock cycle make them low.
signal EXPLOSION_SOUNDSig, BOMB_PLACE_SOUNDSig, DEATH_SOUNDSig : std_logic;

-- Signals used by the sound entity to interact with the RAM.
signal ADDRSig                                                      : std_logic_vector(17 downto 0);
signal AUD_BCLKSig, AUD_ADCDATSig, AUD_ADCLRCKSig, AUD_DACLRCKSig   : std_logic;
signal AUD_MCLKSig, AUD_DACDATSig, I2C_SDATSig, I2C_SCLKSig         : std_logic;
signal CESig, UBSig, LBSig, OESig, WESig                            : std_logic;

-- Demo signals used for the bomb.
signal setXSig : std_logic_vector(9 downto 0);
signal getXSig : std_logic_vector(9 downto 0);
signal setYSig : std_logic_vector(9 downto 0);
signal getYSig : std_logic_vector(9 downto 0);
signal bomb_sound_flagSig, explosion_sound_flagSig, set_fuseSig : std_logic;
signal bomb_stateSig : std_logic_vector(2 downto 0);
signal BombAddrRowAt, BombAddrRowBelow, BombAddrRowAbove : std_logic_vector(3 downto 0);
signal BombRowAt, BombRowBelow, BombRowAbove : std_logic_vector(43 downto 0);

-- CONSTANTS
-- The top of the map as according to the ColorMapper via Copy-Paste.
constant MAP_START_X : integer := 224;
constant MAP_START_Y : integer := 160;
-- Map sizes in terms of tiles according to the ColorMapper via Copy-Paste.
constant MAP_LEFT_TILE : integer := 14;
constant MAP_TOP_TILE : integer := 10;
constant MAP_RIGHT_TILE : integer := 25;
constant MAP_BOTTOM_TILE : integer := 19;

-- Where the exit is as according to the ColorMapper via Copy-Paste.
constant EXIT_X : integer := 368;
constant EXIT_Y : integer := 272;
-- Where the exit is in terms of tiles.
constant EXIT_X_TILE : integer := 23;
constant EXIT_Y_TILE : integer := 17;

-- The type of tile. Copy-paste from Level.vhd.
constant TILE_EMPTY : std_logic_vector := "0000";
constant TILE_BRICK : std_logic_vector := "0001";
constant TILE_BRICK_BROKEN : std_logic_vector := "0010";
constant TILE_EXP_CENTER : std_logic_vector := "0011";
constant TILE_EXP_UP : std_logic_vector := "0100";
constant TILE_EXP_DOWN : std_logic_vector := "0101";
constant TILE_EXP_LEFT : std_logic_vector := "0110";
constant TILE_EXP_RIGHT : std_logic_vector := "0111";
constant TILE_BLOCK : std_logic_vector := "1000";

-- Game states. Copy-pasted from GameState.vhd.
constant OUT_TITLE : std_logic_vector(3 downto 0) := x"0";
constant OUT_PLAYING : std_logic_vector(3 downto 0) := x"1";
constant OUT_PAUSE : std_logic_vector(3 downto 0) := x"2";
constant OUT_RENEW : std_logic_vector(3 downto 0) := x"3";

-- Signals used in the random number generator.
signal rand48             : std_logic_vector(47 downto 0);
signal reset_bricks       : std_logic;
type rand_stateType is (TURNON, RANDOMIZE_BRICKS, WAITING);
signal rand_state, rand_next_state : rand_stateType;

-- Signals used in floor management
signal floorCounter : std_logic_vector(10 downto 0);
signal exitWait : std_logic;

-- Signals used in the game timer.
-- 5 second 'ticker'
signal fiveSecondTicker : std_logic_vector(27 downto 0);
signal progressBar      : std_logic_vector(10 downto 0);
signal resetProgressBar : std_logic;
signal tick_ready       : std_logic;
signal pcount_enable    : std_logic;
signal timeupSig        : std_logic;
type progress_stateType is (WAITING, TICKING_1, TICKING_2, TICKING_3, TICKING_4, TICKING_5, TICKING_6, TICKING_7, TICKING_8, TICKING_9, TICKING_10, TICKING_11, TIMEUP);
signal progress_state, progress_next_state : progress_stateType;

-- Begin the behavioral.
begin

-- Attach the sound signals going out.
CE              <= CESig;
UB              <= UBSig;
LB              <= LBSig;
OE              <= OESig; 
WE              <= WESig;
ADDR            <= ADDRSig;       
AUD_MCLK        <= AUD_MCLKSig;   
AUD_DACDAT      <= AUD_DACDATSig; 
I2C_SDAT        <= I2C_SDATSig;  
I2C_SCLK        <= I2C_SCLKSig;

-- Sound signals coming IN 
RAM_DATASig     <= RAM_DATA;       
AUD_BCLKSig     <= AUD_BCLK;   
AUD_ADCDATSig   <= AUD_ADCDAT;      
AUD_DACLRCKSig  <= AUD_DACLRCK;    
AUD_ADCLRCKSig  <= AUD_ADCLRCK;
 
-- The push buttons are active low
Reset_h <= not Reset;

vgaSyncInstance : VGAController
   Port map(clk => clk,
            reset => Reset_h,
            hs => hs,
            vs => vsSig,
            pixel_clk => VGA_clk,
            blank => blank,
            sync => sync,
            DrawX => DrawXSig,
            DrawY => DrawYSig);

GameStateInstance : GameState
Port Map(   Clk => clk,
            Reset => Reset_h,
            PressedStart => PressedStart,
            TimeUp => timeupSig,
            CurrentState => GameStateValue
);

PlayerStateInstance : PlayerState
Port Map(   Clk => clk,
            Reset => Reset_h,
            GotHit => GotHitSig,
            BombermanSpeedX => BombermanSpeedX,
            BombermanSpeedY => BombermanSpeedY,
            PlayerStateValue => PlayerStateValue
);

PlayerEntityInstance : PlayerEntity
Port map(   Reset => Reset_h,
            Clk => clk,
            frame_clk => vsSig, -- Vertical Sync used as an "ad hoc" 60 Hz clock signal
            KeyInput => KeyInput,
            MovementFlags => MovementFlags,
            Tiles0 => Tiles0,
            Tiles1 => Tiles1,
            Tiles2 => Tiles2,
            Tiles3 => Tiles3,
            Tiles4 => Tiles4,
            Tiles5 => Tiles5,
            Tiles6 => Tiles6,
            Tiles7 => Tiles7,
            Tiles8 => Tiles8,
            BombermanX => BombermanXSig,  --   (This is why we registered it in the vga controller!)
            BombermanY => BombermanYSig,
            BombermanW => BombermanWidthSig,
            BombermanH => BombermanHeightSig,
            BombermanS => BombermanSSig,
            ResetBombermanPos => ResetBombermanPos,
            BombermanSpeedX => BombermanSpeedX,
            BombermanSpeedY => BombermanSpeedY,
            GotHit => GotHitSig,
            Debug => BombermanDebugSig);

LevelInstance : Level
Port Map(   Clk => clk,
            Reset => Reset_h,
            NewTiles0 => NewTiles0,
            NewTiles1 => NewTiles1,
            NewTiles2 => NewTiles2,
            NewTiles3 => NewTiles3,
            NewTiles4 => NewTiles4,
            NewTiles5 => NewTiles5,
            NewTiles6 => NewTiles6,
            NewTiles7 => NewTiles7,
            NewTiles8 => NewTiles8,
            Tiles0 => Tiles0,
            Tiles1 => Tiles1,
            Tiles2 => Tiles2,
            Tiles3 => Tiles3,
            Tiles4 => Tiles4,
            Tiles5 => Tiles5,
            Tiles6 => Tiles6,
            Tiles7 => Tiles7,
            Tiles8 => Tiles8);

MapRowAtBomb : MapRowAccess
Port Map(   Clk => clk,
            Addr => BombAddrRowAt,
            Tiles0 => Tiles0,
            Tiles1 => Tiles1,
            Tiles2 => Tiles2,
            Tiles3 => Tiles3,
            Tiles4 => Tiles4,
            Tiles5 => Tiles5,
            Tiles6 => Tiles6,
            Tiles7 => Tiles7,
            Tiles8 => Tiles8,
            Row => BombRowAt);

MapRowBelowBomb : MapRowAccess
Port Map(   Clk => clk,
            Addr => BombAddrRowBelow,
            Tiles0 => Tiles0,
            Tiles1 => Tiles1,
            Tiles2 => Tiles2,
            Tiles3 => Tiles3,
            Tiles4 => Tiles4,
            Tiles5 => Tiles5,
            Tiles6 => Tiles6,
            Tiles7 => Tiles7,
            Tiles8 => Tiles8,
            Row => BombRowBelow);

MapRowAboveBomb : MapRowAccess
Port Map(   Clk => clk,
            Addr => BombAddrRowAbove,
            Tiles0 => Tiles0,
            Tiles1 => Tiles1,
            Tiles2 => Tiles2,
            Tiles3 => Tiles3,
            Tiles4 => Tiles4,
            Tiles5 => Tiles5,
            Tiles6 => Tiles6,
            Tiles7 => Tiles7,
            Tiles8 => Tiles8,
            Row => BombRowAbove);

Color_instance : ColorMapper
   Port Map(BombermanX => BombermanXSig,
            BombermanY => BombermanYSig,
            BombermanWidth => BombermanWidthSig,
            BombermanHeight => BombermanHeightSig,
            DrawX => DrawXSig,
            DrawY => DrawYSig,
            Bomberman_size => BombermanSSig,
            BombX => getXSig,
            BombY => getYSig,
            BombState => bomb_stateSig,
            Tiles0 => Tiles0,
            Tiles1 => Tiles1,
            Tiles2 => Tiles2,
            Tiles3 => Tiles3,
            Tiles4 => Tiles4,
            Tiles5 => Tiles5,
            Tiles6 => Tiles6,
            Tiles7 => Tiles7,
            Tiles8 => Tiles8,
            GameStateValue => GameStateValue,
            PlayerStateValue => PlayerStateValue,
            progressBar => progressBar,
            floorCounter => floorCounter,
            Clk => clk,
            Reset => Reset_h,
            Red => Red,
            Green => Green,
            Blue => Blue);

clock_divider_instance : clock_divider
   Port Map(ClkIn => Clk,
    Reset => Reset_h,
        ClkOut => DividedClk);

SignalSync_instance : SignalSync
   Port Map(Clk => DividedClk,
            PS2Clk => ps2Clk,
            Reset => Reset_h,
            ps2ClkIsFallingEdge => SyncedClk);

KeyboardInstance : KeyboardVhdl
Port Map(   CLK => Clk,
            RST => Reset_h,
            ps2Data => ps2data,
            ps2Clk => ps2Clk,
            NewKeyAck => Reset_h,
            keyCode => KeyInput,
            newKeyOut => OnStart);

HexAU : HexDriver
   Port Map(In0 => BombermanXSig(7 downto 4),
            Out0 => KeyHexU);

HexAL : HexDriver
   Port Map(In0 => BombermanXSig(3 downto 0),
            Out0 => KeyHexL);

HexDebugLeft : HexDriver
   Port Map(In0 => BombermanYSig(7 downto 4),
            Out0 => HexOutLeft);

HexDebugRight : HexDriver
   Port Map(In0 => BombermanYSig(3 downto 0),
            Out0 => HexOutRight);

SOUNDInstance:  SOUND
Port Map(
        CE               => CESig,
        UB               => UBSig,
        LB               => LBSig,
        OE               => OESig, 
        WE               => WESig,
        ADDR             => ADDRSig,
        RAM_DATA         => RAM_DATASig,
        EXPLOSION_SOUND  => EXPLOSION_SOUNDSig,
        BOMB_PLACE_SOUND => BOMB_PLACE_SOUNDSig,
        DEATH_SOUND      => DEATH_SOUNDSig,
        CLK              => Clk,
        Reset            => Reset_h,
        AUD_MCLK         => AUD_MCLKSig,
        AUD_BCLK         => AUD_BCLKSig,
        AUD_ADCDAT       => AUD_ADCDATSig,
        AUD_DACDAT       => AUD_DACDATSig,
        AUD_DACLRCK      => AUD_DACLRCKSig,
        AUD_ADCLRCK      => AUD_ADCLRCKSig,
        I2C_SDAT         => I2C_SDATSig,
        I2C_SCLK         => I2C_SCLKSig
    );

Bomb1: bomb
Port Map(  setX                 => setXSig,
           setY                 => setYSig,
           getX                 => getXSig, 
           getY                 => getYSig,
           bomb_sound_flag      => BOMB_PLACE_SOUNDSig,
           explosion_sound_flag => EXPLOSION_SOUNDSig,
           Reset                => Reset_h,
           set_fuse             => set_fuseSig,
           bomb_state           => bomb_stateSig,
           clk                  => Clk,
           paused               => IsPaused
    );

-- Assign the vertical VGA signal. This line of code was given to us.
vs <= vsSig;

-- This process assigns KeyInput as soon as ScanRegister has been shifted the proper number (11) times.
RecognizeKeypress : process (Reset_h, SyncedClk, OnStart, PlayerStateValue)
begin
    if (Reset_h = '1') then
        MovementFlags <= x"0";
        set_fuseSig <= '0';
        PressedStart <= '0';
    elsif (rising_edge(SyncedClk)) then
        set_fuseSig <= '0';
        PressedStart <= '0';
        if OnStart = '1' then
            -- We are ready to read a key from the keyboard.
            if GameStateValue = OUT_PLAYING then
                if PlayerStateValue = "1111" then
                    -- Bomberman was downed by a bomb blast. Disable movement.
                    MovementFlags <= "0000";
                elsif KeyInput = "00011101" then
                    -- Key 'w' was pressed to move up.
                    MovementFlags <= "0010";
                elsif KeyInput = "00011011" then
                    -- Key 's' was pressed to move down.
                    MovementFlags <= "0100";
                elsif KeyInput = "00011100" then
                    -- Key 'a' was pressed to move left.
                    MovementFlags <= "1000";
                elsif KeyInput = "00100011" then
                    -- Key 'd' was pressed to move right.
                    MovementFlags <= "0001";
                elsif KeyInput = x"29" then
                    -- Key 'space' was pressed to lay a bomb.
                    -- Only lay a bomb when the bomb state is "000".
                    set_fuseSig <= not bomb_stateSig(2) and not bomb_stateSig(1) and not bomb_stateSig(0);
                end if;
            end if;
            if KeyInput = x"5A" then
                -- Key 'enter' was pressed to un/pause the game.
                PressedStart <= '1';
            end if;
        else
            MovementFlags <= x"0";
        end if;
    end if;
end process;

ReactToPosition : process(Reset_h, Clk, BombermanXSig, BombermanYSig, PlayerStateValue, GameStateValue)
begin
    if (Reset_h = '1') then
        onExit <= '0';
        DEATH_SOUNDSig <= '0';
        reset_bricks <= '0';
        ResetBombermanPos <= '1';
    elsif (rising_edge(Clk)) then
        onExit <= '0';
        DEATH_SOUNDSig <= '0';
        reset_bricks <= '0';
        ResetBombermanPos <= '0';

        -- Assign the position that the bomb is given. It is always able to calculated at any time.
        -- The position is the same as Bomberman's position except the lower bits are cut off.
        if BombermanXSig(3) = '0' then
            -- Bomberman's x-value is around the left-hand side of the tile.
            setXSig <= BombermanXSig(9 downto 4) & "0000";
        else
            -- Bomberman's x-value is around the right-hand side of the tile.
            -- Put the bomb one tile to Bomberman's right.
            setXSig <= (BombermanXSig(9 downto 4) & "0000") + "10000";
        end if;

        if BombermanYSig(3) = '0' then
            -- Bomberman's y-value is around the top of the tile.
            setYSig <= BombermanYSig(9 downto 4) & "0000";
        else
            -- Bomberman's y-value is around the bottom of the tile.
            -- Put the bomb one tile below Bomberman.
            setYSig <= (BombermanYSig(9 downto 4) & "0000") + "10000";
        end if;

        -- Check the tile-based coordinate of Bomberman. If it is equal to the Exit tile's position, onExit becomes true.
        if PlayerStateValue = "0010" or GameStateValue = OUT_TITLE then
            -- Bomberman is in the REVIVE state, so he's recovering from a bomb blast.
            ResetBombermanPos <= '1';
        elsif BombermanXSig(7 downto 4) = "0111" and BombermanYSig(7 downto 4) = "0001" then
            -- Bomberman is standing on the Exit tile.
            onExit <= '1';
            DEATH_SOUNDSig <= '1';
            reset_bricks <= '1';
            ResetBombermanPos <= '1';
        end if;
    end if;
end process;

-- Simply tells if the game is paused or not based on the game state.
SetPaused : process(GameStateValue)
begin
    if GameStateValue = OUT_PAUSE or GameStateValue = OUT_TITLE then
        IsPaused <= '1';
    else
        IsPaused <= '0';
    end if;
end process;

-- The bomb explosion needs to know about the rows above and below it in order to know what to blow up.
-- This process assigns which addresses of the level map to look at as soon as the bomb is relocated.
AssignBombRows : process(getXSig, getYSig)
-- Where the bomb really is in tile coordinates.
variable tileX, tileY : integer range 0 to 64;
begin
    tileY := conv_integer(conv_std_logic_vector(conv_integer(unsigned(getYSig)) - MAP_START_Y, 8)(7 downto 4));
    BombAddrRowAt <= conv_std_logic_vector(tileY, 4);
    BombAddrRowBelow <= conv_std_logic_vector(tileY + 1, 4);
    BombAddrRowAbove <= conv_std_logic_vector(tileY - 1, 4);
end process;

ReactToBomb : process(Clk, Reset_h, Tiles0, Tiles1, Tiles2, Tiles3, Tiles4, Tiles5, Tiles6, Tiles7, Tiles8, NewTiles0, NewTiles1, NewTiles2,NewTiles3,NewTiles4,NewTiles5,NewTiles6,NewTiles7,NewTiles8)
-- Where the bomb really is in tile coordinates.
variable tileX, tileY : integer range 0 to 64;
-- Multiply the tileX by the number of bits in a tile to get the tile offset.
variable offsettedX : integer range 0 to 64;
variable currentTile : std_logic_vector(3 downto 0);
variable newTilesAt, newTilesAbove, newTilesBelow : std_logic_vector(43 downto 0);
begin

    -- By default, just set the NewTiles to what they originally were.
    if Reset_h = '1' then
        -- Nothing needs to be done.
        NewTiles0 <= Tiles0; --x"88888888888";
        NewTiles1 <= Tiles1;
        NewTiles2 <= Tiles2;
        NewTiles3 <= Tiles3;
        NewTiles4 <= Tiles4;
        NewTiles5 <= Tiles5;
        NewTiles6 <= Tiles6;
        NewTiles7 <= Tiles7;
        NewTiles8 <= Tiles8; --x"88888888888";
    elsif rising_edge(Clk) then
        NewTiles0 <= x"88888888888";
        NewTiles1 <= NewTiles1;
        NewTiles2 <= NewTiles2;
        NewTiles3 <= NewTiles3;
        NewTiles4 <= NewTiles4;
        NewTiles5 <= NewTiles5;
        NewTiles6 <= NewTiles6;
        NewTiles7 <= NewTiles7;
        NewTiles8 <= x"88888888888";
        -- React to a bomb explosion by setting all bricks to broken bricks.
         if rand_state = RANDOMIZE_BRICKS then
                NewTiles0 <= Tiles0;
                NewTiles1 <= x"8" & "000" & rand48(35) & "000" & rand48(34) & "000" & rand48(33) & "000" & rand48(32) & "000" & rand48(31) & "000" & rand48(30) & "000" & rand48(29) & "0000" & "0000" & x"8"; 
                NewTiles2 <= x"8" & "000" & rand48(36) & x"8" & "000" & rand48(37) & x"8" & "000" & rand48(38) & x"80808"; 
                NewTiles3 <= x"8" & "000" & rand48(26) & "000" & rand48(25) & "000" & rand48(24) & "000" & rand48(23) & "000" & rand48(22) & "000" & rand48(21) & "000" & rand48(20) & "000" & rand48(19) & "0000" & x"8"; --rand48(26 downto 18);
                NewTiles4 <= x"8" & "000" & rand48(39) & x"8" & "000" & rand48(40) & x"8" & "000" & rand48(41) & x"8" & "000" & rand48(42)& x"808";
                NewTiles5 <= x"8" & "000" & rand48(17) & "000" & rand48(16) & "000" & rand48(15) & "000" & rand48(14) & "000" & rand48(13) & "000" & rand48(12) & "000" & rand48(11) & "000" & rand48(10) & "000" & rand48(9) & x"8";--rand48(17 downto 9);
                NewTiles6 <= x"8" & "000" & rand48(43) & x"8" & "000" & rand48(44) & x"8" & "000" & rand48(45) & x"8" & "000" & rand48(46)& x"8" & "000" & rand48(47) & x"8";
                NewTiles7 <= x"8" & "000" & "0"  & "000" & rand48(7) & "000" & rand48(6) & "000" & rand48(5) & "000" & rand48(4) & "000" & rand48(3) & "000" & rand48(2) & "000" & rand48(1) & "000" & rand48(0) & x"8";--rand48(8 downto 0);
                NewTiles8 <= Tiles8;
        elsif bomb_stateSig = "010" then
            -- The bomb is in the exploding state. Break all bricks.
            -- Turn all non-bricks into explosion tiles.
            tileY := conv_integer(conv_std_logic_vector(conv_integer(unsigned(getYSig)) - MAP_START_Y, 8)(7 downto 4));
            -- Assign all of the to-be-edited rows based on the bomb's position.
            -- This is more or less the exact same thing MapRowAccess does.
            case tileY is
                when 1 =>
                    newTilesAbove := Tiles0;
                    newTilesAt := Tiles1;
                    newTilesBelow := Tiles2;
                when 2 =>
                    newTilesAbove := Tiles1;
                    newTilesAt := Tiles2;
                    newTilesBelow := Tiles3;
                when 3 =>
                    newTilesAbove := Tiles2;
                    newTilesAt := Tiles3;
                    newTilesBelow := Tiles4;
                when 4 =>
                    newTilesAbove := Tiles3;
                    newTilesAt := Tiles4;
                    newTilesBelow := Tiles5;
                when 5 =>
                    newTilesAbove := Tiles4;
                    newTilesAt := Tiles5;
                    newTilesBelow := Tiles6;
                when 6 =>
                    newTilesAbove := Tiles5;
                    newTilesAt := Tiles6;
                    newTilesBelow := Tiles7;
                when 7 =>
                    newTilesAbove := Tiles6;
                    newTilesAt := Tiles7;
                    newTilesBelow := Tiles8;
                when others =>
                    newTilesAbove := Tiles0;
                    newTilesAt := Tiles0;
                    newTilesBelow := Tiles0;
            end case;

            tileX := conv_integer(conv_std_logic_vector(conv_integer(unsigned(getXSig)) - MAP_START_X, 8)(7 downto 4));
            offsettedX := tileX + tileX + tileX + tileX;

            -- This tile is the tile the bomb was on.
            currentTile := newTilesAt(offsettedX + 3 downto offsettedX);
            newTilesAt(offsettedX + 3 downto offsettedX) := TILE_EXP_CENTER;

            -- This tile is to the right of the bomb.
            currentTile := newTilesAt(offsettedX + 7 downto offsettedX + 4);
            if newTilesAt(offsettedX + 7 downto offsettedX + 4) = TILE_BRICK then
                newTilesAt(offsettedX + 7 downto offsettedX + 4) := TILE_BRICK_BROKEN;
            elsif newTilesAt(offsettedX + 7 downto offsettedX + 4) = TILE_EMPTY then
                newTilesAt(offsettedX + 7 downto offsettedX + 4) := TILE_EXP_RIGHT;
            end if;

            -- This tile is to the left of the bomb.
            currentTile := newTilesAt(offsettedX - 1 downto offsettedX - 4);
            if newTilesAt(offsettedX - 1 downto offsettedX - 4) = TILE_BRICK then
                newTilesAt(offsettedX - 1 downto offsettedX - 4) := TILE_BRICK_BROKEN;
            elsif newTilesAt(offsettedX - 1 downto offsettedX - 4) = TILE_EMPTY then
                newTilesAt(offsettedX - 1 downto offsettedX - 4) := TILE_EXP_LEFT;
            end if;

            -- This tile is above the bomb.
            currentTile := newTilesAbove(offsettedX + 3 downto offsettedX);
            if newTilesAbove(offsettedX + 3 downto offsettedX) = TILE_BRICK then
                newTilesAbove(offsettedX + 3 downto offsettedX) := TILE_BRICK_BROKEN;
            elsif newTilesAbove(offsettedX + 3 downto offsettedX) = TILE_EMPTY then
                newTilesAbove(offsettedX + 3 downto offsettedX) := TILE_EXP_UP;
            end if;

            -- This tile is below the bomb.
            currentTile := newTilesBelow(offsettedX + 3 downto offsettedX);
            if newTilesBelow(offsettedX + 3 downto offsettedX) = TILE_BRICK then
                newTilesBelow(offsettedX + 3 downto offsettedX) := TILE_BRICK_BROKEN;
            elsif newTilesBelow(offsettedX + 3 downto offsettedX) = TILE_EMPTY then
                newTilesBelow(offsettedX + 3 downto offsettedX) := TILE_EXP_DOWN;
            end if;

            -- We have made our changes to the map, so write them out.
            case tileY is
                when 1 =>
                    NewTiles0 <= newTilesAbove;
                    NewTiles1 <= newTilesAt;
                    NewTiles2 <= newTilesBelow;
                when 2 =>
                    NewTiles1 <= newTilesAbove;
                    NewTiles2 <= newTilesAt;
                    NewTiles3 <= newTilesBelow;
                when 3 =>
                    NewTiles2 <= newTilesAbove;
                    NewTiles3 <= newTilesAt;
                    NewTiles4 <= newTilesBelow;
                when 4 =>
                    NewTiles3 <= newTilesAbove;
                    NewTiles4 <= newTilesAt;
                    NewTiles5 <= newTilesBelow;
                when 5 =>
                    NewTiles4 <= newTilesAbove;
                    NewTiles5 <= newTilesAt;
                    NewTiles6 <= newTilesBelow;
                when 6 =>
                    NewTiles5 <= newTilesAbove;
                    NewTiles6 <= newTilesAt;
                    NewTiles7 <= newTilesBelow;
                when 7 =>
                    NewTiles6 <= newTilesAbove;
                    NewTiles7 <= newTilesAt;
                    NewTiles8 <= newTilesBelow;
                when others =>
                    -- Assign nothing.
            end case;
        elsif bomb_stateSig = "000" then
            -- The bomb has finished exploding.
            -- Change all bomb explosion and broken brick tiles to empty tiles.

            -- This is done in code the following way:
            -- Block tiles remain the same due to them being coded as "1000".
            -- Brick tiles remain the same due to them being coded as "0001".
            -- All other tiles become empty tiles: "0000".
            -- All tiles that we know are blocks are ignored here, so there's 51 potential brick tiles.
            -- With "T" as NewTiles# we are working on the general format of the code is as follows.
            -- T(HIGH downto LOW) <= T(HIGH) & "00" and ( T(HIGH - 1 downto LOW) == "001" );
            NewTiles1(7 downto 4) <= NewTiles1(7) & "00" & (not NewTiles1(6) and not NewTiles1(5) and NewTiles1(4));
            NewTiles1(11 downto 8) <= NewTiles1(11) & "00" & (not NewTiles1(10) and not NewTiles1(9) and NewTiles1(8));
            NewTiles1(15 downto 12) <= NewTiles1(15) & "00" & (not NewTiles1(14) and not NewTiles1(13) and NewTiles1(12));
            NewTiles1(19 downto 16) <= NewTiles1(19) & "00" & (not NewTiles1(18) and not NewTiles1(17) and NewTiles1(16));
            NewTiles1(23 downto 20) <= NewTiles1(23) & "00" & (not NewTiles1(22) and not NewTiles1(21) and NewTiles1(20));
            NewTiles1(27 downto 24) <= NewTiles1(27) & "00" & (not NewTiles1(26) and not NewTiles1(25) and NewTiles1(24));
            NewTiles1(31 downto 28) <= NewTiles1(31) & "00" & (not NewTiles1(30) and not NewTiles1(29) and NewTiles1(28));
            NewTiles1(35 downto 32) <= NewTiles1(35) & "00" & (not NewTiles1(34) and not NewTiles1(33) and NewTiles1(32));
            NewTiles1(39 downto 36) <= NewTiles1(39) & "00" & (not NewTiles1(38) and not NewTiles1(37) and NewTiles1(36));
            NewTiles2(7 downto 4) <= NewTiles2(7) & "00" & (not NewTiles2(6) and not NewTiles2(5) and NewTiles2(4));
            NewTiles2(15 downto 12) <= NewTiles2(15) & "00" & (not NewTiles2(14) and not NewTiles2(13) and NewTiles2(12));
            NewTiles2(23 downto 20) <= NewTiles2(23) & "00" & (not NewTiles2(22) and not NewTiles2(21) and NewTiles2(20));
            NewTiles2(31 downto 28) <= NewTiles2(31) & "00" & (not NewTiles2(30) and not NewTiles2(29) and NewTiles2(28));
            NewTiles2(39 downto 36) <= NewTiles2(39) & "00" & (not NewTiles2(38) and not NewTiles2(37) and NewTiles2(36));
            NewTiles3(7 downto 4) <= NewTiles3(7) & "00" & (not NewTiles3(6) and not NewTiles3(5) and NewTiles3(4));
            NewTiles3(11 downto 8) <= NewTiles3(11) & "00" & (not NewTiles3(10) and not NewTiles3(9) and NewTiles3(8));
            NewTiles3(15 downto 12) <= NewTiles3(15) & "00" & (not NewTiles3(14) and not NewTiles3(13) and NewTiles3(12));
            NewTiles3(19 downto 16) <= NewTiles3(19) & "00" & (not NewTiles3(18) and not NewTiles3(17) and NewTiles3(16));
            NewTiles3(23 downto 20) <= NewTiles3(23) & "00" & (not NewTiles3(22) and not NewTiles3(21) and NewTiles3(20));
            NewTiles3(27 downto 24) <= NewTiles3(27) & "00" & (not NewTiles3(26) and not NewTiles3(25) and NewTiles3(24));
            NewTiles3(31 downto 28) <= NewTiles3(31) & "00" & (not NewTiles3(30) and not NewTiles3(29) and NewTiles3(28));
            NewTiles3(35 downto 32) <= NewTiles3(35) & "00" & (not NewTiles3(34) and not NewTiles3(33) and NewTiles3(32));
            NewTiles3(39 downto 36) <= NewTiles3(39) & "00" & (not NewTiles3(38) and not NewTiles3(37) and NewTiles3(36));
            NewTiles4(7 downto 4) <= NewTiles4(7) & "00" & (not NewTiles4(6) and not NewTiles4(5) and NewTiles4(4));
            NewTiles4(15 downto 12) <= NewTiles4(15) & "00" & (not NewTiles4(14) and not NewTiles4(13) and NewTiles4(12));
            NewTiles4(23 downto 20) <= NewTiles4(23) & "00" & (not NewTiles4(22) and not NewTiles4(21) and NewTiles4(20));
            NewTiles4(31 downto 28) <= NewTiles4(31) & "00" & (not NewTiles4(30) and not NewTiles4(29) and NewTiles4(28));
            NewTiles4(39 downto 36) <= NewTiles4(39) & "00" & (not NewTiles4(38) and not NewTiles4(37) and NewTiles4(36));
            NewTiles5(7 downto 4) <= NewTiles5(7) & "00" & (not NewTiles5(6) and not NewTiles5(5) and NewTiles5(4));
            NewTiles5(11 downto 8) <= NewTiles5(11) & "00" & (not NewTiles5(10) and not NewTiles5(9) and NewTiles5(8));
            NewTiles5(15 downto 12) <= NewTiles5(15) & "00" & (not NewTiles5(14) and not NewTiles5(13) and NewTiles5(12));
            NewTiles5(19 downto 16) <= NewTiles5(19) & "00" & (not NewTiles5(18) and not NewTiles5(17) and NewTiles5(16));
            NewTiles5(23 downto 20) <= NewTiles5(23) & "00" & (not NewTiles5(22) and not NewTiles5(21) and NewTiles5(20));
            NewTiles5(27 downto 24) <= NewTiles5(27) & "00" & (not NewTiles5(26) and not NewTiles5(25) and NewTiles5(24));
            NewTiles5(31 downto 28) <= NewTiles5(31) & "00" & (not NewTiles5(30) and not NewTiles5(29) and NewTiles5(28));
            NewTiles5(35 downto 32) <= NewTiles5(35) & "00" & (not NewTiles5(34) and not NewTiles5(33) and NewTiles5(32));
            NewTiles5(39 downto 36) <= NewTiles5(39) & "00" & (not NewTiles5(38) and not NewTiles5(37) and NewTiles5(36));
            NewTiles6(7 downto 4) <= NewTiles6(7) & "00" & (not NewTiles6(6) and not NewTiles6(5) and NewTiles6(4));
            NewTiles6(15 downto 12) <= NewTiles6(15) & "00" & (not NewTiles6(14) and not NewTiles6(13) and NewTiles6(12));
            NewTiles6(23 downto 20) <= NewTiles6(23) & "00" & (not NewTiles6(22) and not NewTiles6(21) and NewTiles6(20));
            NewTiles6(31 downto 28) <= NewTiles6(31) & "00" & (not NewTiles6(30) and not NewTiles6(29) and NewTiles6(28));
            NewTiles6(39 downto 36) <= NewTiles6(39) & "00" & (not NewTiles6(38) and not NewTiles6(37) and NewTiles6(36));
            NewTiles7(7 downto 4) <= NewTiles7(7) & "00" & (not NewTiles7(6) and not NewTiles7(5) and NewTiles7(4));
            NewTiles7(11 downto 8) <= NewTiles7(11) & "00" & (not NewTiles7(10) and not NewTiles7(9) and NewTiles7(8));
            NewTiles7(15 downto 12) <= NewTiles7(15) & "00" & (not NewTiles7(14) and not NewTiles7(13) and NewTiles7(12));
            NewTiles7(19 downto 16) <= NewTiles7(19) & "00" & (not NewTiles7(18) and not NewTiles7(17) and NewTiles7(16));
            NewTiles7(23 downto 20) <= NewTiles7(23) & "00" & (not NewTiles7(22) and not NewTiles7(21) and NewTiles7(20));
            NewTiles7(27 downto 24) <= NewTiles7(27) & "00" & (not NewTiles7(26) and not NewTiles7(25) and NewTiles7(24));
            NewTiles7(31 downto 28) <= NewTiles7(31) & "00" & (not NewTiles7(30) and not NewTiles7(29) and NewTiles7(28));
            NewTiles7(35 downto 32) <= NewTiles7(35) & "00" & (not NewTiles7(34) and not NewTiles7(33) and NewTiles7(32));
            NewTiles7(39 downto 36) <= NewTiles7(39) & "00" & (not NewTiles7(38) and not NewTiles7(37) and NewTiles7(36));            
        end if;
    end if;
end process;

-- the process updaterand48 updates the 48 length random signal used to randomize the placement of bricks.

-- Originally, we chose to use gold code theory to generate our random numbers. However,
-- this was causing some timing issues since we needed to use so many different randomly
-- generated numbers (one for each floor tile). 

-- Instead, we chose a simpler approach: the combination of a shift register and a counter.
-- Since it takes a variable amount of time to clear the level, combining this fact with 
-- the fact that incrementing and continuously shifting a register will generate a fairly
-- pseudorandom bit pattern whenever the user hits the exit panel.

updaterand48 : process(Clk, Reset_h)
begin
    if(Reset_h = '1') then
        rand48  <= "000101100010100101111000100101011110011010101000"; -- 'pseudorandom' starting value
     elsif(rising_edge(Clk)) then
        rand48 <= (rand48(47) & rand48(46 downto 0)) + 100; -- 100counter combined with shift register
    end if;
end process;

-- simple process to advance the state of the brick randomizer.
randbrick_reg : process (Reset_h, Clk)
	begin
		if (Reset_h = '1') then
			rand_state <= TURNON;
		elsif (rising_edge(Clk)) then
			rand_state <= rand_next_state;
		end if;
end process;

-- state mapper for the brick randomizer.
get_next_state_rand : process (rand_state, reset_bricks)
begin
	case rand_state is
		when TURNON   =>
            rand_next_state <= RANDOMIZE_BRICKS; -- randomize the bricks on turnon.
        when RANDOMIZE_BRICKS   =>
            rand_next_state <= WAITING; -- immediatley go to the waiting state after we are in randomize_bricks for one clock cycle.
		when WAITING =>
            if (reset_bricks = '1') then -- only randomize the bricks when the signal reset_bricks is high.
                rand_next_state <= RANDOMIZE_BRICKS;
            else
                rand_next_state <= WAITING; -- Otherwise, keep waiting.
            end if;
		end case;
end process;

-- The time remaining bar is essentially a direct sprite-to-vector mapping. The timer
-- exists for 60 seconds. Every 5 seconds, we make the next '1' become a '0' in an
-- 11 it std_vector (progressBar) which causes the associated tile sprite to go away.
-- In this manner, we observe the effect of a progress bar.

get_next_state_progress : process (Clk, progress_state, resetProgressBar, tick_ready)
begin    
	case progress_state is
		when WAITING   =>
            if(resetProgressBar = '1') then
                progress_next_state <= WAITING;
            else
                progress_next_state <= TICKING_1;
            end if;
        when TICKING_1   =>
                if(tick_ready = '1') then -- only advance to the next tick state when the five second timer expires each time.
                    progress_next_state <= TICKING_2;
                else
                    progress_next_state <= TICKING_1;
                end if;
        when TICKING_2   =>
                if(tick_ready = '1') then
                    progress_next_state <= TICKING_3;
                else
                    progress_next_state <= TICKING_2;
                end if;
        when TICKING_3   =>
                if(tick_ready = '1') then
                    progress_next_state <= TICKING_4;
                else
                    progress_next_state <= TICKING_3;
                end if;
        when TICKING_4   =>
                if(tick_ready = '1') then
                    progress_next_state <= TICKING_5;
                else
                    progress_next_state <= TICKING_4;
                end if;
        when TICKING_5   =>
                if(tick_ready = '1') then
                    progress_next_state <= TICKING_6;
                else
                    progress_next_state <= TICKING_5;
                end if;
        when TICKING_6   =>
                if(tick_ready = '1') then
                    progress_next_state <= TICKING_7;
                else
                    progress_next_state <= TICKING_6;
                end if;
        when TICKING_7   =>
                if(tick_ready = '1') then
                    progress_next_state <= TICKING_8;
                else
                    progress_next_state <= TICKING_7;
                end if;
        when TICKING_8   =>
                if(tick_ready = '1') then
                    progress_next_state <= TICKING_9;
                else
                    progress_next_state <= TICKING_8;
                end if;
        when TICKING_9   =>
                if(tick_ready = '1') then
                    progress_next_state <= TICKING_10;
                else
                    progress_next_state <= TICKING_9;
                end if;
        when TICKING_10   =>
                if(tick_ready = '1') then
                    progress_next_state <= TICKING_11;
                else
                    progress_next_state <= TICKING_10;
                end if;
        when TICKING_11   =>
                if(tick_ready = '1') then
                    progress_next_state <= TIMEUP;
                else
                    progress_next_state <= TICKING_11;
                end if;       
		when TIMEUP    => -- when the timer expires, we only want to start the timer again when resetProgressBar is low.
            if(resetProgressBar = '1') then
                progress_next_state <= TICKING_1;
            else
                progress_next_state <= TIMEUP;
            end if;         
		end case;
end process;

-- state advancer process for the progress bar state machine
progress_state_reg : process (Reset_h, Clk)
	begin
		if (Reset_h = '1') then
			progress_state <= WAITING;
		elsif (rising_edge(Clk)) then
			progress_state <= progress_next_state;
		end if;
end process;

-- this process basically monitors the five second ticker, and sets the tick_ready flag (used in the state mapping)
-- to high whenever the timer expires. This causes the progress bar state machine to advance in state.
monitor_progress_ready : process(Reset_h, Clk, fiveSecondTicker)
begin
    if (Reset_h = '1') then
        tick_ready <= '0';
    elsif (rising_edge(Clk)) then
        if fiveSecondTicker = "1111111111111111111111111111" then
            tick_ready <= '1';
        else
            tick_ready <= '0';
        end if;
    end if;
end process;

-- this is the five second counter that we utilize to make one of the
-- 11 progress 'blocks' that are on the screen go away. The code
-- is straightforward.

pcounter : process(Clk, Reset_h, pcount_enable, GameStateValue)
begin
    if (Reset_h = '1') then
        fiveSecondTicker <= "0000000000000000000000000000";          
    elsif (rising_edge(Clk)) then
        if pcount_enable = '1' then
            if GameStateValue = OUT_PLAYING then
                fiveSecondTicker <= fiveSecondTicker + '1';
            else
                fiveSecondTicker <= fiveSecondTicker;
            end if;
        else
            fiveSecondTicker <= "0000000000000000000000000000";
        end if;
    end if;
end process;

-- the pbar process checks the state of the progress bar state machine
-- and assigns the progressBar the appropriate number of 1s and 0s 
-- needed to display the correct amount of time remaining.

pbar : process(Clk, Reset_h, progress_state)
begin
    if (Reset_h = '1') then
        progressBar <= "11111111111"; -- start with 'all tiles displayed' -- we have a full timer bar!
        pcount_enable <= '1';
        timeupSig <= '0';
    elsif (rising_edge(Clk)) then
    
        timeupSig <= '0';
        pcount_enable <= '1';
        
        case progress_state is
            when WAITING   =>
                pcount_enable <= '0';
                progressBar <= "11111111111"; -- each time, shift in a zero.
            when TICKING_1   =>
                progressBar <= "01111111111"; -- this will make the timer sprites dissapear one at a time, every 5 seconds.
            when TICKING_2   =>
                progressBar <= "00111111111";
            when TICKING_3   =>
                progressBar <= "00011111111";
            when TICKING_4   =>
                progressBar <= "00001111111";
            when TICKING_5   =>
                progressBar <= "00000111111";
            when TICKING_6   =>
                progressBar <= "00000011111";
            when TICKING_7   =>
                progressBar <= "00000001111";
            when TICKING_8   =>
                progressBar <= "00000000111";
            when TICKING_9   =>
                progressBar <= "00000000011";
            when TICKING_10  =>
                progressBar <= "00000000001";
            when TICKING_11  =>
                progressBar <= "00000000000";
            when TIMEUP      =>
                progressBar <= "00000000000";
                pcount_enable <= '0';
                timeupSig <= '1';
         end case;
     end if;
end process;

-- the floor counter process checks the onExit variable, which goes high when bomberman
-- reaches the exit tile. Since onExit can be high for more than one clock cycle, we
-- utilize an exitWait variable to make sure that we only increment the counter exactly
-- one time. floorCounter is also looked at inside of ColorMapper, where the correct number
-- of gems are drawn on the screen.

updateFloorCounter : process(Clk, Reset_h, floorCounter, GameStateValue, exitWait, onExit)
begin
    if Reset_h = '1' then
        floorCounter <= "00000000000";
        exitWait <= '0';
        resetProgressBar <= '1';
    elsif rising_edge(Clk) then
        resetProgressBar <= '0';
        if GameStateValue = OUT_RENEW then
            floorCounter <= "00000000000";
            resetProgressBar <= '1';
        elsif onExit = '1' and exitWait = '0' then
            floorCounter <= floorCounter(9 downto 0) & "1";
            exitWait <= '1';
        elsif onExit = '1' and exitWait = '1' then
            floorCounter <= floorCounter;
        else
            exitWait <= '0';
            floorCounter <= floorCounter;
        end if;
    end if;
end process;

--resetProgressBar <= '0'; -- remove this eventually
LEDProgressBar <= progressBar;

end Behavioral;
