---------------------------------------------------------------------------
--      MapRowAccess.vhd                                                 --
--      Matthew Grawe & Larry Resnik                                     --
--      Spring 2014 ECE 385 Final Project                                --
---------------------------------------------------------------------------
-- MapRowAccess allows something to access the map on a per-row basis.
-- By having many MapRowAccess components,
-- many things can look at and edit the map concurrently.
-- Do not make multiple Level instances because they will make duplicate maps!
-- Do make multiple MapRowAccess instances because they merely copy and redirect the map's values.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity MapRowAccess is
Port(   Clk : in std_logic;
        -- The address is 4 bits long because there's 9 rows of tiles. 4 bits represents a row number up to 15.
        Addr : in std_logic_vector(3 downto 0);
        -- The tile rows are 44 bits long because there's 11 tiles made of 4 bits each.
        Tiles0 : in std_logic_vector(43 downto 0);
        Tiles1 : in std_logic_vector(43 downto 0);
        Tiles2 : in std_logic_vector(43 downto 0);
        Tiles3 : in std_logic_vector(43 downto 0);
        Tiles4 : in std_logic_vector(43 downto 0);
        Tiles5 : in std_logic_vector(43 downto 0);
        Tiles6 : in std_logic_vector(43 downto 0);
        Tiles7 : in std_logic_vector(43 downto 0);
        Tiles8 : in std_logic_vector(43 downto 0);
        -- The requested row of Tiles# where # is Addr.
        Row : out std_logic_vector(43 downto 0));
end MapRowAccess;

architecture Behavioral of MapRowAccess is

-- Begin Behavioral
begin

SetSelectedRow : process (Clk, Addr, Tiles0, Tiles1, Tiles2, Tiles3, Tiles4, Tiles5, Tiles6, Tiles7, Tiles8)
begin
    if rising_edge(Clk) then
        case Addr is
            when x"0" =>
                Row <= Tiles0;
            when x"1" =>
                Row <= Tiles1;
            when x"2" =>
                Row <= Tiles2;
            when x"3" =>
                Row <= Tiles3;
            when x"4" =>
                Row <= Tiles4;
            when x"5" =>
                Row <= Tiles5;
            when x"6" =>
                Row <= Tiles6;
            when x"7" =>
                Row <= Tiles7;
            when x"8" =>
                Row <= Tiles8;
            when others =>
                Row <= Tiles0;
        end case;
    end if;
end process;

end Behavioral;

