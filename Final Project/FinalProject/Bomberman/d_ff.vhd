library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity d_ff is
	port(D, clk, reset: in std_logic;
	Q : out std_logic);
end d_ff;

architecture behavioral of d_ff is
begin
	operate_dff: process(reset, clk)
		begin
			if (reset = '1') then
				Q <= '0';
			elsif (rising_edge(clk)) then
				Q <= D;
			end if;
	end process;
end behavioral;
