---------------------------------------------------------------------------
--      PlayerEntity.vhd                                                 --
--      Matthew Grawe & Larry Resnik                                     --
--      Spring 2014 ECE 385 Final Project                                --
---------------------------------------------------------------------------
-- PlayerEntity controls the movement of Bomberman. That is all.
-- Bomberman stores his size, speed, position, etc. in units of pixels (not tiles).
-- The speed is outputted for the purpose of animating his motion.
-- If Bomberman tries to move in two directions at once, he will be forcefully stopped.
--
-- Based on Ball.vhd by Viral Mehta, Spring 2005
-- Modified by Stephen Kempf 03/01/2006, 03/12/2007
-- This variant by Larry Resnik 05/01/2014
-- For use in University of Illinois ECE Department, ECE 385 Lab 9

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PlayerEntity is
Port (  Reset : in std_logic;
        Clk : in std_logic;
        frame_clk : in std_logic;
        KeyInput : in std_logic_vector(7 downto 0);
        MovementFlags : in std_logic_vector(3 downto 0);
        -- Send the whole map to the object handler.
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
        -- Whether or not we were hit by a bomb blast.
        GotHit : out std_logic;
        ResetBombermanPos: in std_logic;
        Debug : out std_logic_vector(7 downto 0));
end PlayerEntity;

architecture Behavioral of PlayerEntity is

-- SIGNALS
signal BombermanPosX, BombermanPosY, BombermanMotionX, BombermanMotionY : std_logic_vector(9 downto 0);
signal BombermanSize : std_logic_vector(9 downto 0);
-- Where Bomberman is in the map.
-- We only see his row of tiles, and the rows above and below him.
signal MapRowAddrAbove, MapRowAddrBelow, MapRowAddrAt : std_logic_vector(3 downto 0);
-- Signals update on the end of a clock edge, but sometimes
-- we need to see two rows ahead for proper detection/reaction.
-- I do not think these signals are worth keeping and doubt their effectiveness.
signal MapRowAddrAboveTwice, MapRowAddrBelowTwice : std_logic_vector(3 downto 0);
-- The actual tiles as returned by the MapRowAddr* signals.
signal MapRowTilesAbove, MapRowTilesAt, MapRowTilesBelow : std_logic_vector(43 downto 0);
signal MapRowTilesAboveTwice, MapRowTilesBelowTwice : std_logic_vector(43 downto 0);
-- Debug signal for looking inside of processes. Hence the name "inner".
signal DebugInner : std_logic_vector(7 downto 0);

--CONSTANTS
constant Bomberman_X_Center : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(320, 10);  --Center position on the X axis
constant Bomberman_Y_Center : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(240, 10);  --Center position on the Y axis

constant Bomberman_X_Min    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(0, 10);  --Leftmost point on the X axis
constant Bomberman_X_Max    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(639, 10);  --Rightmost point on the X axis
constant Bomberman_Y_Min    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(0, 10);   --Topmost point on the Y axis
constant Bomberman_Y_Max    : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(479, 10);  --Bottommost point on the Y axis
                              
constant Bomberman_X_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(1, 10);  --Step size on the X axis
constant Bomberman_Y_Step   : std_logic_vector(9 downto 0) := CONV_STD_LOGIC_VECTOR(1, 10);  --Step size on the Y axis

-- The type of tile. Copy-pasted from Level.vhd.
constant TILE_EMPTY : std_logic_vector := x"0";
constant TILE_BLOCK : std_logic_vector := x"1";
constant TILE_BRICK : std_logic_vector := x"F";

-- The top of the map as according to the ColorMapper via Copy-Paste.
constant MAP_START_X : integer := 224;
constant MAP_END_X : integer := 400;
constant MAP_START_Y : integer := 160;
constant MAP_END_Y : integer := 304;
-- The tile sized variants of the map size constants above. Also Copy-Pasted.
constant MAP_LEFT_TILE : integer := 14;
constant MAP_TOP_TILE : integer := 10;
constant MAP_RIGHT_TILE : integer := 25;
constant MAP_BOTTOM_TILE : integer := 19;

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

begin

BombermanSize <= CONV_STD_LOGIC_VECTOR(16, 10); -- assigns the value 4 as a 10-digit binary number, ie "0000000100"
BombermanW <= BombermanSize;
BombermanH <= BombermanSize;

-------------------------------------------------

MapRowAbove : MapRowAccess
Port Map(   Clk => Clk,
            Addr => MapRowAddrAbove,
            Tiles0 => Tiles0,
            Tiles1 => Tiles1,
            Tiles2 => Tiles2,
            Tiles3 => Tiles3,
            Tiles4 => Tiles4,
            Tiles5 => Tiles5,
            Tiles6 => Tiles6,
            Tiles7 => Tiles7,
            Tiles8 => Tiles8,
            Row => MapRowTilesAbove);

MapRowAt : MapRowAccess
Port Map(   Clk => Clk,
            Addr => MapRowAddrAt,
            Tiles0 => Tiles0,
            Tiles1 => Tiles1,
            Tiles2 => Tiles2,
            Tiles3 => Tiles3,
            Tiles4 => Tiles4,
            Tiles5 => Tiles5,
            Tiles6 => Tiles6,
            Tiles7 => Tiles7,
            Tiles8 => Tiles8,
            Row => MapRowTilesAt);

MapRowBelow : MapRowAccess
Port Map(   Clk => Clk,
            Addr => MapRowAddrBelow,
            Tiles0 => Tiles0,
            Tiles1 => Tiles1,
            Tiles2 => Tiles2,
            Tiles3 => Tiles3,
            Tiles4 => Tiles4,
            Tiles5 => Tiles5,
            Tiles6 => Tiles6,
            Tiles7 => Tiles7,
            Tiles8 => Tiles8,
            Row => MapRowTilesBelow);

MapRowBelowTwice : MapRowAccess
Port Map(   Clk => Clk,
            Addr => MapRowAddrBelowTwice,
            Tiles0 => Tiles0,
            Tiles1 => Tiles1,
            Tiles2 => Tiles2,
            Tiles3 => Tiles3,
            Tiles4 => Tiles4,
            Tiles5 => Tiles5,
            Tiles6 => Tiles6,
            Tiles7 => Tiles7,
            Tiles8 => Tiles8,
            Row => MapRowTilesBelowTwice);

MapRowAboveTwice : MapRowAccess
Port Map(   Clk => Clk,
            Addr => MapRowAddrAboveTwice,
            Tiles0 => Tiles0,
            Tiles1 => Tiles1,
            Tiles2 => Tiles2,
            Tiles3 => Tiles3,
            Tiles4 => Tiles4,
            Tiles5 => Tiles5,
            Tiles6 => Tiles6,
            Tiles7 => Tiles7,
            Tiles8 => Tiles8,
            Row => MapRowTilesAboveTwice);

-- Based on Bomberman's position, choose the proper rows of tiles to examine.
ReadMapRow: process(BombermanPosX, BombermanPosY)
-- Where Bomberman really is in tile coordinates.
variable tileY : integer range 0 to 64;
begin
    -- The tile Bomberman is on is defined by his pixel coordinates translated to map coordinates,
    -- then divided by the size of each tile. The formula goes as such:
    -- (BombermanPosY - MAP_START_Y) / 16
    -- A division by 16 is the same thing as a right shift by 4, so drop the lowest 4 bits.
    tileY := conv_integer(conv_std_logic_vector(conv_integer(unsigned(BombermanPosY)) - MAP_START_Y, 8)(7 downto 4));
    -- This is the row Bomberman is on.
    MapRowAddrAt <= conv_std_logic_vector(tileY, 4);
    -- This is the row above Bomberman.
    MapRowAddrAbove <= conv_std_logic_vector(tileY - 1, 4);
    -- This is the row below Bomberman.
    MapRowAddrBelow <= conv_std_logic_vector(tileY + 1, 4);
    MapRowAddrAboveTwice <= conv_std_logic_vector(tileY - 2, 4);
    MapRowAddrBelowTwice <= conv_std_logic_vector(tileY + 2, 4);
end process ReadMapRow;

Debug <= DebugInner;

MovePlayer: process(Reset, frame_clk, BombermanSize, KeyInput)
-- Where Bomberman really is in tile coordinates.
variable tileX, tileY : integer range 0 to 64;
-- Multiply the tileX by the number of bits in a tile to get the tile offset.
variable offsettedX : integer range 0 to 64;
-- towardsTile is where Bomberman is walking towards. It's assigned based on MovementFlags.
-- lowerTile is the tile below Bomberman. Since his origin is the upper-left of his sprite, this looks at
--    the tile that would be at his lower-left corner. We must check it when moving left/right.
-- sideTile is the tile to Bomberman's right. We must check it when moving up/down.
--    It has the same functional importance as lowerTile, but the variable names keep their
--    role more apparent.
-- All of these tiles only store the tile type (empty, brick, or block).
variable towardsTile, lowerTile, sideTile : std_logic_vector(3 downto 0);
-- If we can move along the tile defined by Bomberman's upper-left, is the other tile Bomberman is in
-- able to moved on? This variable says we must check for that.
variable checkOther : boolean;
begin
    if (Reset = '1') then   --Asynchronous Reset
        BombermanMotionX <= "0000000000";
        BombermanMotionY <= "0000000000";
        -- Set the player to start out at the origin (upper-left) exactly on tile (1, 1)
        BombermanPosX <= conv_std_logic_vector(MAP_START_X + 16, 10);
        BombermanPosY <= conv_std_logic_vector(MAP_START_Y + 16, 10);
        BombermanSpeedX <= "0000000000";
        BombermanSpeedY <= "0000000000";
        GotHit <= '0';
        DebugInner <= x"00";

    elsif (rising_edge(frame_clk)) then
        -- Determine the tile that Bomberman is on. Note that this code appears to normal,
        -- but any and all horizontal movement code is REVERSED when shown onscreen.
        tileX := conv_integer(conv_std_logic_vector(conv_integer(unsigned(BombermanPosX)) - MAP_START_X, 8)(7 downto 4));
        tileY := conv_integer(conv_std_logic_vector(conv_integer(unsigned(BombermanPosY)) - MAP_START_Y, 8)(7 downto 4));
        -- We have the X-value, but multiply it by four because there's four bits per tile.
        offsettedX := tileX + tileX + tileX + tileX;
        checkOther := false;

        -- Check if we were hit by an explosion.
        -- Technically, this should be in a process of its own.
        -- (We only check the tile at Bomberman's upper-left).
        if (MapRowTilesAt(offsettedX + 3 downto offsettedX) = "0011") or (MapRowTilesAt(offsettedX + 2) = '1') then
            GotHit <= '1';
        else
            GotHit <= '0';
        end if;

        -- In the Debug signal, put the the tile value we are on.
        DebugInner <= conv_std_logic_vector(tileY, 8);

        -- React to presses of the keyboard.
        if MovementFlags(2) = '1' then
            -- Key 'S' means move DOWN.
            -- Look at the tiles located at Bomberman's lower-left pixel and lower-right pixel.
            if BombermanPosY(3 downto 0) /= x"F" then
                -- There's no issue with the tiles below us.
                towardsTile := MapRowTilesBelow(offsettedX + 3 downto offsettedX);
                sideTile := MapRowTilesBelow(offsettedX + 7 downto offsettedX + 4);
            else
                -- The tiles "below" us are wrong because of the delay in signals on a clock cycle.
                -- Use our doubly-below referenced tiles to make up for the delay.
                towardsTile := MapRowTilesBelow(offsettedX + 3 downto offsettedX);
                sideTile := MapRowTilesBelowTwice(offsettedX + 7 downto offsettedX + 4);
            end if;

            -- Check if either of the tiles would stop him.
            if towardsTile = TILE_EMPTY then
                -- The tile to Bomberman's lower-left is empty. Check the other tile.
                BombermanMotionY <= Bomberman_Y_Step;
                checkOther := BombermanPosX(3 downto 0) /= x"E";
            elsif conv_std_logic_vector(conv_integer(unsigned(BombermanPosY)) + conv_integer(unsigned(Bomberman_Y_Step)), 8)(3 downto 0) + 0 <= conv_integer(unsigned(BombermanPosY(3 downto 0))) then
                -- The tile to Bomberman's lower-left is not empty, but we have the room to walk towards it.
                -- Check the other tile.
                BombermanMotionY <= Bomberman_Y_Step;
                checkOther := true;
            else
                -- The tile to Bomberman's lower-left is not empty. Stop moving.
                BombermanMotionY <= "0000000000";
            end if;
            
            -- Check if we need to check the lower-right tile for collisions.
            -- Only look if Bomberman is not exactly within his tile.
            -- That is, Bomberman's a tad to the right of where his origin tile is. He's in two tiles.
            if checkOther and not (BombermanPosX(3 downto 0) = x"0" or BombermanPosX(3 downto 0) = x"1") then
                if sideTile = TILE_EMPTY then
                    -- The tile at Bomberman's lower-right is walkable.
                    -- Both tiles to Bomberman's left are walkable, so move.
                    BombermanMotionY <= Bomberman_Y_Step;
                else
                    -- The tile to Bomberman's lower-left is walkable, but not the lower-right tile.
                    BombermanMotionY <= "0000000000";
                end if;
            end if;

        elsif MovementFlags(1) = '1' then
            -- Key 'W' means move UP.
            towardsTile := MapRowTilesAbove(offsettedX + 3 downto offsettedX);
            sideTile := MapRowTilesAbove(offsettedX + 7 downto offsettedX + 4);
            -- Check the upper-left tile.
            if towardsTile = TILE_EMPTY then
                -- The next tile is empty. Set the motion to the Step speed using 2's complement notation.
                BombermanMotionY <= not(Bomberman_Y_Step) + '1';
                checkOther := true;
            elsif conv_std_logic_vector(conv_integer(unsigned(BombermanPosY)) - conv_integer(unsigned(Bomberman_Y_Step)), 8)(3 downto 0) - 1 <= conv_integer(unsigned(BombermanPosY(3 downto 0))) then
                BombermanMotionY <= not(Bomberman_Y_Step) + '1';
                checkOther := true;
            else
                BombermanMotionY <= "0000000000";
            end if;

            -- Check the upper-right tile if needed.
            if checkOther and not (BombermanPosX(3 downto 0) = x"0" or BombermanPosX(3 downto 0) = x"1") then
                if sideTile = TILE_EMPTY then
                    BombermanMotionY <= not(Bomberman_Y_Step) + '1';
                elsif conv_std_logic_vector(conv_integer(unsigned(BombermanPosY)) - conv_integer(unsigned(Bomberman_Y_Step)), 8)(3 downto 0) - 1 <= conv_integer(unsigned(BombermanPosY(3 downto 0))) then
                    BombermanMotionY <= not(Bomberman_Y_Step) + '1';
                else
                    BombermanMotionY <= "0000000000";
                end if;
            end if;

        elsif MovementFlags(3) = '1' then
            -- Key 'A' means move LEFT.
            towardsTile := MapRowTilesAt(offsettedX - 1 downto offsettedX - 4);
            lowerTile := MapRowTilesBelow(offsettedX - 1 downto offsettedX - 4);
            -- Check the tile at Bomberman's upper-left.
            if towardsTile = TILE_EMPTY then
                BombermanMotionX <= not(Bomberman_X_Step) + '1';
                checkOther := true;
            elsif conv_std_logic_vector(conv_integer(unsigned(BombermanPosX)) - conv_integer(unsigned(Bomberman_X_Step)), 8)(3 downto 0) - 1 <= conv_integer(unsigned(BombermanPosX(3 downto 0))) then
                BombermanMotionX <= not(Bomberman_X_Step) + '1';
                checkOther := true;
            else
                BombermanMotionX <= "0000000000";
            end if;

            -- Check the tile at Bomberman's lower-left.
            if checkOther and not (BombermanPosY(3 downto 0) = x"0" or BombermanPosY(3 downto 0) = x"1") then
                if lowerTile = TILE_EMPTY then
                    BombermanMotionX <= not(Bomberman_X_Step) + '1';
                elsif conv_std_logic_vector(conv_integer(unsigned(BombermanPosX)) - conv_integer(unsigned(Bomberman_X_Step)), 8)(3 downto 0) - 1 <= conv_integer(unsigned(BombermanPosX(3 downto 0))) then
                    BombermanMotionX <= not(Bomberman_X_Step) + '1';
                else
                    BombermanMotionX <= "0000000000";
                end if;
            end if;

        elsif MovementFlags(0) = '1' then
            -- Key 'D' means move RIGHT.
            towardsTile := MapRowTilesAt(offsettedX + 7 downto offsettedX + 4);
            sideTile := MapRowTilesBelow(offsettedX + 7 downto offsettedX + 4);
            DebugInner <= x"00";
            -- Check the tile at Bomberman's upper-right.
            if towardsTile = TILE_EMPTY then
                BombermanMotionX <= Bomberman_X_Step;
                checkOther := true;
                DebugInner(3 downto 0) <= x"1";
            elsif conv_std_logic_vector(conv_integer(unsigned(BombermanPosX)) + conv_integer(unsigned(Bomberman_X_Step)), 8)(3 downto 0) + 1 <= conv_integer(unsigned(BombermanPosX(3 downto 0))) then
                BombermanMotionX <= Bomberman_X_Step;
                checkOther := true;
                DebugInner(3 downto 0) <= x"2";
            else
                BombermanMotionX <= "0000000000";
                DebugInner(3 downto 0) <= x"3";
            end if;

            -- Check the tile at Bomberman's lower-right.
            if checkOther and not (BombermanPosY(3 downto 0) = x"0" or BombermanPosY(3 downto 0) = x"1") then
                if sideTile = TILE_EMPTY then
                    BombermanMotionX <= Bomberman_X_Step;
                    DebugInner(7 downto 4) <= x"1";
                elsif conv_std_logic_vector(conv_integer(unsigned(BombermanPosX)) + conv_integer(unsigned(Bomberman_X_Step)), 8)(3 downto 0) + 1 <= conv_integer(unsigned(BombermanPosX(3 downto 0))) then
                    BombermanMotionX <= Bomberman_X_Step;
                    DebugInner(7 downto 4) <= x"2";
                else
                    BombermanMotionX <= "0000000000";
                    DebugInner(7 downto 4) <= x"3";
                end if;
            end if;

        else
            -- We aren't even moving.
            BombermanMotionX <= "0000000000";
            BombermanMotionY <= "0000000000";
        end if;

        -- Disable buggy movement caused by multiple key presses.
        if (BombermanMotionX /= "0000000000" and BombermanMotionY /= "0000000000") then
            BombermanMotionX <= "0000000000";
            BombermanMotionY <= "0000000000";
        end if;

        -- Unconditionally add Bomberman's position to the calculated speed of this clock cycle.
        BombermanPosY <= BombermanPosY + BombermanMotionY;
        BombermanPosX <= BombermanPosX + BombermanMotionX;
        
        -- If we need to reset Bomberman's position, undo everything from before and reset the position.
        if ResetBombermanPos = '1' then
            BombermanPosX <= conv_std_logic_vector(MAP_START_X + 16, 10);
            BombermanPosY <= conv_std_logic_vector(MAP_START_Y + 16, 10);
        end if;

        -- Output the calculated speed of Bomberman.
        BombermanSpeedX <= BombermanMotionX;
        BombermanSpeedY <= BombermanMotionY;
    end if;
  
end process MovePlayer;

BombermanX <= BombermanPosX;
BombermanY <= BombermanPosY;
BombermanS <= BombermanSize;

end Behavioral;
