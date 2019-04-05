---------------------------------------------------------------------------
--      Level.vhd                                                        --
--      Matthew Grawe & Larry Resnik                                     --
--      Spring 2014 ECE 385 Final Project                                --
---------------------------------------------------------------------------
-- Level stores the map layout.
-- It outputs the entirety of the level in separate vectors
-- so that MapRowAccess components can access those vectors
-- at their own liesure without conflicting with each others' signals.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Level is
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
end Level;

architecture Behavioral of Level is

-- The number of bits used to differentiate tile types.
constant TILE_SIZE : integer := 4;
-- Bomberman GB had an 11x9 playfield where the outer edge was blocks.
constant MAP_ROWS : integer := 9;
-- For 9, we need 4 bit to store up to 16 unique numbers.
-- However, we need to have enough bits for all color distinctions as said by TILE_SIZE.
constant MAP_COL_BITS : integer := 11 * TILE_SIZE;

type map_array is array(0 to MAP_ROWS-1) of std_logic_vector(MAP_COL_BITS-1 downto 0);

-- The type of tile.
constant TILE_EMPTY : std_logic_vector := "0000";
constant TILE_BRICK : std_logic_vector := "0001";
constant TILE_BRICK_BROKEN : std_logic_vector := "0010";
constant TILE_EXP_CENTER : std_logic_vector := "0011";
constant TILE_EXP_UP : std_logic_vector := "0100";
constant TILE_EXP_DOWN : std_logic_vector := "0101";
constant TILE_EXP_LEFT : std_logic_vector := "0110";
constant TILE_EXP_RIGHT : std_logic_vector := "0111";
constant TILE_BLOCK : std_logic_vector := "1000";

-- The default level data. Read the tile type constants above for the meaning of each number.
constant DEFAULT_MAP_DATA : map_array := (
x"88888888888",
x"80000000008",
x"80808080808",
x"80000001118",
x"80808080808",
x"81100100008",
x"80808080808",
x"80001000108",
x"88888888888"
);

-- This is the actual map that gets affected during the course of the game.
signal EditableMapData : map_array;

-- Begin Behavioral
begin

-- We always output the tiles of our map in parallel lines.
Tiles0 <= EditableMapData(0);
Tiles1 <= EditableMapData(1);
Tiles2 <= EditableMapData(2);
Tiles3 <= EditableMapData(3);
Tiles4 <= EditableMapData(4);
Tiles5 <= EditableMapData(5);
Tiles6 <= EditableMapData(6);
Tiles7 <= EditableMapData(7);
Tiles8 <= EditableMapData(8);

-- During a clock edge, set the map to have the new tile values.
UpdateLevel : process(Clk, Reset, NewTiles0, NewTiles1, NewTiles2, NewTiles3, NewTiles4, NewTiles5, NewTiles6, NewTiles7, NewTiles8)
begin
    if Reset = '1' then
        EditableMapData(0) <= DEFAULT_MAP_DATA(0);
        EditableMapData(1) <= DEFAULT_MAP_DATA(1);
        EditableMapData(2) <= DEFAULT_MAP_DATA(2);
        EditableMapData(3) <= DEFAULT_MAP_DATA(3);
        EditableMapData(4) <= DEFAULT_MAP_DATA(4);
        EditableMapData(5) <= DEFAULT_MAP_DATA(5);
        EditableMapData(6) <= DEFAULT_MAP_DATA(6);
        EditableMapData(7) <= DEFAULT_MAP_DATA(7);
        EditableMapData(8) <= DEFAULT_MAP_DATA(8);
    elsif rising_edge(Clk) then
        EditableMapData(0) <= NewTiles0;
        EditableMapData(1) <= NewTiles1;
        EditableMapData(2) <= NewTiles2;
        EditableMapData(3) <= NewTiles3;
        EditableMapData(4) <= NewTiles4;
        EditableMapData(5) <= NewTiles5;
        EditableMapData(6) <= NewTiles6;
        EditableMapData(7) <= NewTiles7;
        EditableMapData(8) <= NewTiles8;
    end if;
end process;

end Behavioral;

