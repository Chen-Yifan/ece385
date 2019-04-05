library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- This entity syncronizes the slower PS/2's keyboard clock with the faster FPGA clock.
-- It takes both clock signals as inputs, but outputs what the PS/2 keyboard's clock is
-- only when the FPGA's clock has gone through a rising edge.

entity SignalSync is
Port (  Clk : in std_logic;
        PS2Clk : in std_logic;
        Reset : in std_logic;
        ps2ClkIsFallingEdge : out std_logic);
end SignalSync;

architecture Behavioral of SignalSync is

component d_ff is
    port(
    D, clk, reset: in std_logic;
    Q : out std_logic);
end component;

-- Between both D-Flip Flops we will make, this is the output of the first one.
signal StoredPS2Clk : std_logic;
-- This signal is the output of the second D-Flip Flop.
signal ClkChange : std_logic;

-- Begin the behavioral.
begin

-- DFF1
ps2clk_reader: d_ff
port map(
    D => PS2Clk,
    clk => Clk,
    reset => Reset,
    Q => StoredPS2Clk);

-- DFF2
clk_reader: d_ff
port map(
    D => StoredPS2Clk,
    clk => Clk,
    reset => Reset,
    Q => ClkChange);

-- This process uses combinational logic to see if the PS/2 keyboard clock
-- has experienced a falling edge or not.
SignalSyncProcess : process (Clk, Reset, StoredPS2Clk, ClkChange)
begin
    if (Reset = '1') then
        ps2ClkIsFallingEdge <= '0';
    elsif (rising_edge(Clk)) then
        ps2ClkIsFallingEdge <= ClkChange and not StoredPS2Clk;
    end if;
end process;

end Behavioral;

