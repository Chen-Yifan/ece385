--Legal Notice: (C)2007 Altera Corporation. All rights reserved.  Your
--use of Altera Corporation's design tools, logic functions and other
--software and tools, and its AMPP partner logic functions, and any
--output files any of the foregoing (including device programming or
--simulation files), and any associated documentation or information are
--expressly subject to the terms and conditions of the Altera Program
--License Subscription Agreement or other applicable license agreement,
--including, without limitation, that your use is for the sole purpose
--of programming logic devices manufactured by Altera and sold by Altera
--or its authorized distributors.  Please refer to the applicable
--agreement for further details.


-- turn off superfluous VHDL processor warnings 
-- altera message_level Level1 
-- altera message_off 10034 10035 10036 10037 10230 10240 10030 

library altera;
use altera.altera_europa_support_lib.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ps2 is 
        port (
              -- inputs:
                 signal PS2_Clk : IN STD_LOGIC;
                 signal PS2_Data : IN STD_LOGIC;
                 signal avs_s1_address : IN STD_LOGIC;
                 signal avs_s1_chipselect : IN STD_LOGIC;
                 signal avs_s1_clk : IN STD_LOGIC;
                 signal avs_s1_read : IN STD_LOGIC;
                 signal avs_s1_reset : IN STD_LOGIC;

              -- outputs:
                 signal avs_s1_readdata : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
              );
end entity ps2;


architecture europa of ps2 is
component de2_ps2 is 
           port (
                 -- inputs:
                    signal PS2_Clk : IN STD_LOGIC;
                    signal PS2_Data : IN STD_LOGIC;
                    signal avs_s1_address : IN STD_LOGIC;
                    signal avs_s1_chipselect : IN STD_LOGIC;
                    signal avs_s1_clk : IN STD_LOGIC;
                    signal avs_s1_read : IN STD_LOGIC;
                    signal avs_s1_reset : IN STD_LOGIC;

                 -- outputs:
                    signal avs_s1_readdata : OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
                 );
end component de2_ps2;

                signal internal_avs_s1_readdata :  STD_LOGIC_VECTOR (7 DOWNTO 0);

begin

  --the_de2_ps2, which is an e_instance
  the_de2_ps2 : de2_ps2
    port map(
      avs_s1_readdata => internal_avs_s1_readdata,
      PS2_Clk => PS2_Clk,
      PS2_Data => PS2_Data,
      avs_s1_address => avs_s1_address,
      avs_s1_chipselect => avs_s1_chipselect,
      avs_s1_clk => avs_s1_clk,
      avs_s1_read => avs_s1_read,
      avs_s1_reset => avs_s1_reset
    );


  --vhdl renameroo for output signals
  avs_s1_readdata <= internal_avs_s1_readdata;

end europa;

