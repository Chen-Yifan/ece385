library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- clock_divider takes the FPGA's Clk signal and divides it up by 512 such that
-- the FPGA's 50 MHz clock becomes a 100 kHz clock.

entity clock_divider is
	port(ClkIn  : in  std_logic;
		  Reset  : in  std_logic;
    	 ClkOut  : out  std_logic);
end clock_divider;

architecture Behavioral of clock_divider is

-- This signal says if the clock has been divided
-- It means that 512 cycles have passed.
signal divided : std_logic;
-- How many out of 512 updates have passed.
signal count : std_logic_vector(8 downto 0);

begin 

-- Do the clock division in the process.
divide : process(ClkIn, Reset)
begin
	if(Reset = '1') then
		divided <= '0';
		count <= "000000000";
	elsif (rising_edge(ClkIn)) then
		if(count = 511) then
			divided <= not divided;
			count <= "000000000";
		else
			divided <= divided;
			count <= count + 1;
		end if;
	end if;
end process;

ClkOut <= divided;

end Behavioral;
