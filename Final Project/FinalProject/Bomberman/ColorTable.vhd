---------------------------------------------------------------------------
--      ColorTable.vhd                                                   --
--      Matthew Grawe & Larry Resnik                                     --
--      Spring 2014 ECE 385 Final Project                                --
---------------------------------------------------------------------------
-- ColorTable takes a 2 bit encoding and assigns it an RGB mapping.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ColorTable is
Port (  Color : in std_logic_vector(1 downto 0);
        Red   : out std_logic_vector(9 downto 0);
        Green : out std_logic_vector(9 downto 0);
        Blue  : out std_logic_vector(9 downto 0));
end ColorTable;

architecture Behavioral of ColorTable is

-- Begin Behavioral
begin

SetColor : process (Color)
begin
    case Color is
        when "00" =>
            -- Render black.
            Red <= "0000000000";
            Green <= "0000000000";
            Blue <= "0000000000";
        when "01" =>
            -- Render dark gray.
            Red <= "0111111111";
            Green <= "0111111111";
            Blue <= "0111111111";
        when "10" =>
            -- Render white.
            Red <= "1111111111";
            Green <= "1111111111";
            Blue <= "1111111111";
        when "11" =>
            -- Render white.
            Red <= "1111111111";
            Green <= "1111111111";
            Blue <= "1111111111";
    end case;
end process;

end Behavioral;

