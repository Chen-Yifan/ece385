---------------------------------------------------------------------------
--      SpriteTable.vhd                                                  --
--      Matthew Grawe & Larry Resnik                                     --
--      Spring 2014 ECE 385 Final Project                                --
---------------------------------------------------------------------------
-- SpriteTable stores all 16x16 sprites.
-- You can only access one row of a sprite's pixels at a time.
-- Use Addr to choose one of the 16 rows in a sprite to output on a clock cycle.
-- Use SpriteID to choose which sprite's row to output on a clock cycle.
-- All rows store pixel values as they would be mapped by ColorTable.
-- Based on the font.rom given to us from the ECE 385 course webpage.
-- This entity can only output one row of pixels at a time, so ColorMapper
-- must know how to choose which sprite to render ahead of time.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity SpriteTable is
Port (  Clk : in std_logic;
        -- Which of all of the sprites to select.
        SpriteID : in std_logic_vector(4 downto 0);
        -- Which of the 16 rows of the sprite to output.
        -- The size of Addr is based on NUM_SPRITES * 16.
        Addr : in std_logic_vector(15 downto 0);
        -- The pixels of the requested address.
        -- 32 bits because each image is 16x16 and each color is 2 bits.
        HorizontalColors : out std_logic_vector(31 downto 0));
end SpriteTable;

architecture Behavioral of SpriteTable is

constant NUM_SPRITES : integer := 23;
constant PIXELS_PER_COLUMN : integer := 16;
-- The number of lines in the ROM.
constant ADDRESSES : integer := NUM_SPRITES * PIXELS_PER_COLUMN;
-- Number of bits needed to represent a pixel color.
constant PIXEL_SIZE : integer := 2;
-- Number of bits needed to represent a row of pixel colors.
-- It equals the size of a pixel color times the number of pixels in a row.
constant ROW_PIXELS : integer := PIXEL_SIZE * 16;
type rom_type is array(0 to ADDRESSES-1) of std_logic_vector(ROW_PIXELS-1 downto 0);

constant ROM: rom_type := (
-- Type: Empty tile. ID 0
x"ffffffff",
x"ffffffff",
x"ffffffff",
x"ffffffff",
x"ffffffff",
x"ffffffff",
x"ffffffff",
x"ffffffff",
x"ffffffff",
x"ffffffff",
x"ffffffff",
x"ffffffff",
x"ffffffff",
x"ffffffff",
x"ffffffff",
x"ffffffff",

-- Type: Block tile (indestructible). ID 1
x"80000002",
x"2a6aaaa8",
x"2a555554",
x"2a4001a8",
x"154001a8",
x"2aaaa9a8",
x"2aaaa9a8",
x"00000000",
x"2aa2a928",
x"2a929524",
x"25525524",
x"00000000",
x"28aa8aa8",
x"24954954",
x"14554554",
x"80000002",

-- Type: Brick tile (destructible). ID 2
x"aa8002aa",
x"aa1a54aa",
x"aa2a952a",
x"a86a954a",
x"a86a958a",
x"a26aa58a",
x"866aa68a",
x"8a9aa692",
x"8a99a654",
x"1a9a5554",
x"1a9aa954",
x"1aaaaa54",
x"16aaaa54",
x"855a9554",
x"a0155502",
x"aa8000aa",

-- Type: Bomberman dazzed. ID 3
x"ffffffff",
x"ffc003ff",
x"ff0000ff",
x"ff1554ff",
x"f000000f",
x"c0000003",
x"f02a880f",
x"fc62a93f",
x"fc95540f",
x"f12aa853",
x"f0000253",
x"f141480f",
x"f151514f",
x"fc52854f",
x"ff01453f",
x"fffc00ff",

-- Type: Bomb animation 0. ID 4
x"a6569556",
x"5a8022a9",
x"6800a02a",
x"60a0800a",
x"42800001",
x"82800001",
x"0a000000",
x"0a000000",
x"00000000",
x"00000000",
x"00000000",
x"40000002",
x"40000001",
x"a0000005",
x"a800002a",
x"aa80029a",

-- Type: Floor. ID 5
x"a656a656",
x"5aa95aa9",
x"6aaa6aaa",
x"6aaa6aaa",
x"56a956a9",
x"a555a555",
x"aa6aaa6a",
x"aa9aaa9a",
x"a656a656",
x"5aa95aa9",
x"6aaa6aaa",
x"6aaa6aaa",
x"56a956a9",
x"a555a555",
x"aa6aaa6a",
x"aa9aaa9a",

-- Type: Broken Brick. ID 6
x"aa8002aa",
x"aa1a54aa",
x"aa2a952a",
x"aaaaaaaa",
x"a86a958a",
x"a26aa58a",
x"866aa68a",
x"aaaaaaaa",
x"aaaaaaaa",
x"aaaaaaaa",
x"1a9aa954",
x"1aaaaa54",
x"aaaaaaaa",
x"855a9554",
x"a0155502",
x"aa8000aa",

-- Type: Bomb Explosion Center. ID 7
x"0255558f",
x"2a555a80",
x"a995556a",
x"99555569",
x"55555555",
x"55555555",
x"55555555",
x"55555555",
x"55555555",
x"55555555",
x"55555555",
x"95555555",
x"a5555556",
x"aa555556",
x"0a9556a0",
x"c295558c",

-- Type: Bomb Explosion Left. ID 8
x"3ccf30cc",
x"22000300",
x"a8aa0023",
x"9a69a0a0",
x"55556a83",
x"555556a0",
x"55555583",
x"555555a3",
x"555555a0",
x"55555583",
x"55555600",
x"95695a8f",
x"aaaaa283",
x"a08a228f",
x"00000003",
x"cf3cf3f0",

-- Type: Bomb Explosion Right. ID 9
x"33c33ccf",
x"00302200",
x"c202a8aa",
x"32aa9a69",
x"f2a55555",
x"c2955555",
x"0a555555",
x"c2555555",
x"0a555555",
x"ca555555",
x"3a955555",
x"00a59569",
x"caaaaaaa",
x"300aa08a",
x"c0c00000",
x"0f33cf3c",

-- Type: Bomb Explosion Bottom. ID 10
x"c95555a0",
x"ca5556a3",
x"0a555683",
x"c95555a0",
x"22555583",
x"ca555583",
x"e95555a0",
x"0a5556a3",
x"0a5555a0",
x"ca555583",
x"3a955600",
x"00a55a8f",
x"caaaa283",
x"300a228f",
x"c0c00003",
x"0f33f3f0",

-- Type: Bomb Explosion Top. ID 11
x"33c330cc",
x"00300300",
x"c2020023",
x"32aaa0a0",
x"f2a56a83",
x"c29556a0",
x"0a555583",
x"c25555a3",
x"c95555a0",
x"ca5556a3",
x"0a555683",
x"c95555a0",
x"22555583",
x"ca555583",
x"e95555a0",
x"0a5556a3",

-- Type: Exit Tile. ID 12
x"ffffffff",
x"ffffffff",
x"ffffffff",
x"c0cf3303",
x"cfcf33cf",
x"cfcf33cf",
x"cff0f3cf",
x"c0f0f3cf",
x"cff0f3cf",
x"cfcf33cf",
x"cfcf33cf",
x"c0cf33cf",
x"ffffffff",
x"ffffffff",
x"ffffffff",
x"ffffffff",

-- Type: Bomberman Facing Down Animation 0. ID 13
x"ffc003ff",
x"ff0000ff",
x"ff1554ff",
x"f000000f",
x"c0000003",
x"f022880f",
x"fc62893f",
x"fc95563f",
x"ff2aa8ff",
x"ff0000ff",
x"fc81423f",
x"f10aa04f",
x"f001400f",
x"ff0820ff",
x"fc54153f",
x"fc03c03f",

-- Type: Bomberman Facing Up Animation 0. ID 14
x"ffc003ff",
x"ff0550ff",
x"ff0000ff",
x"f040010f",
x"c0155403",
x"f000000f",
x"fc00003f",
x"fc95563f",
x"ff2aa8ff",
x"ff0000ff",
x"fc81423f",
x"f20aa08f",
x"f0c1430f",
x"ff0820ff",
x"fc54153f",
x"fc03c03f",

-- Type: Bomberman Facing Left Animation 0. ID 15
x"fff03fff",
x"ffc000ff",
x"ffc000ff",
x"c014003f",
x"f0015500",
x"fc000003",
x"fc88003f",
x"fc55aa3f",
x"ff2aa0ff",
x"ffc008ff",
x"fff148ff",
x"ffc214ff",
x"ffc114ff",
x"ff1003ff",
x"ff0054ff",
x"fffc00ff",

-- Type: Bomberman Facing Right Animation 0. ID 16
x"fffc0fff",
x"ff0003ff",
x"ff0003ff",
x"fc001403",
x"0055400f",
x"c000003f",
x"fc00223f",
x"fcaa553f",
x"ff0aa8ff",
x"ff2003ff",
x"ff214fff",
x"ff1483ff",
x"ff1443ff",
x"ffc004ff",
x"ff1500ff",
x"ff003fff",

-- Type: Bomberman Facing Down Animation 1. ID 17
x"ffc003ff",
x"ff0000ff",
x"ff1554ff",
x"f000000f",
x"c0000003",
x"f022880f",
x"fc62893f",
x"fc95563f",
x"ff2aa8ff",
x"fc80023f",
x"f201413f",
x"f10aa03f",
x"f00143ff",
x"ff1424ff",
x"ff03153f",
x"ffffc03f",

-- Type: Bomberman Facing Up Animation 1. ID 18
x"ffc003ff",
x"ff0550ff",
x"ff0000ff",
x"f040010f",
x"c0155403",
x"f000000f",
x"fc00003f",
x"fc95563f",
x"ff2aa8ff",
x"fc80023f",
x"fc41408f",
x"fc0aa04f",
x"ffc1400f",
x"ff0814ff",
x"fc54c3ff",
x"fc03ffff",

-- Type: Bomberman Facing Left Animation 1. ID 19
x"fff03fff",
x"ffc000ff",
x"ffc000ff",
x"c014003f",
x"f0015500",
x"fc000003",
x"fc8800ff",
x"fc55a0ff",
x"ff2a800f",
x"fc000a53",
x"fc045053",
x"fff0a10f",
x"fff2413f",
x"ff08313f",
x"fc54fc3f",
x"fc00ffff",

-- Type: Bomberman Facing Right Animation 1. ID 20
x"fffc0fff",
x"ff0003ff",
x"ff0003ff",
x"fc001403",
x"0055400f",
x"c000003f",
x"ff00223f",
x"ff0a553f",
x"f002a8ff",
x"c5a0003f",
x"c505103f",
x"f04a0fff",
x"fc418fff",
x"fc4c20ff",
x"fc3f153f",
x"ffff003f",

-- Type: Clock. ID 21
x"aa0000aa",
x"aa0000aa",
x"a0aa0a0a",
x"a0aa0a0a",
x"0aaa0aa0",
x"0aaa0aa0",
x"0aaa0aa0",
x"0aaa0aa0",
x"0000aaa0",
x"0000aaa0",
x"0aaaaaa0",
x"0aaaaaa0",
x"a0aaaa0a",
x"a0aaaa0a",
x"aa0000aa",
x"aa0000aa",

-- Type: Gem. ID 22
x"aaaaaaaa",
x"aa8002aa",
x"a82aa82a",
x"80aaaa02",
x"192aa8a4",
x"2a8002a8",
x"2a4662a8",
x"0919a9a0",
x"1065aa04",
x"84155422",
x"a100128a",
x"a8415a2a",
x"a90150aa",
x"a40001aa",
x"9555556a",
x"a9555aaa"
);

-- Begin Behavioral
begin

-- Assigns the row of pixels to the requested sprite's row.
SetColors : process (Clk, SpriteID, Addr)
begin
    if rising_edge(Clk) then
        -- The address to examine is Addr + SpriteID * 16 because each sprite is 16 pixels/rows apart.
        HorizontalColors <= ROM(to_integer(unsigned(Addr))+(to_integer(unsigned(SpriteID))*16));
    end if;
end process;

end Behavioral;

