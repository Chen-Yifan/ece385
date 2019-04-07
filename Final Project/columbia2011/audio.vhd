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

entity audio is 
        port (
              -- inputs:
                 signal AUD_ADCDAT : IN STD_LOGIC;
                 signal chipselect : IN STD_LOGIC;
                 signal clk : IN STD_LOGIC;
                 signal data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                 signal reset_n : IN STD_LOGIC;
                 signal test_mode : IN STD_LOGIC;
                 signal write : IN STD_LOGIC;
                 signal writedata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

              -- outputs:
                 signal AUD_ADCLRCK : OUT STD_LOGIC;
                 signal AUD_BCLK : INOUT STD_LOGIC;
                 signal AUD_DACDAT : OUT STD_LOGIC;
                 signal AUD_DACLRCK : OUT STD_LOGIC;
                 signal audio_request : OUT STD_LOGIC
              );
end entity audio;


architecture europa of audio is
component de2_wm8731_audio is 
           port (
                 -- inputs:
                    signal AUD_ADCDAT : IN STD_LOGIC;
                    signal chipselect : IN STD_LOGIC;
                    signal clk : IN STD_LOGIC;
                    signal data : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
                    signal reset_n : IN STD_LOGIC;
                    signal test_mode : IN STD_LOGIC;
                    signal write : IN STD_LOGIC;
                    signal writedata : IN STD_LOGIC_VECTOR (15 DOWNTO 0);

                 -- outputs:
                    signal AUD_ADCLRCK : OUT STD_LOGIC;
                    signal AUD_BCLK : INOUT STD_LOGIC;
                    signal AUD_DACDAT : OUT STD_LOGIC;
                    signal AUD_DACLRCK : OUT STD_LOGIC;
                    signal audio_request : OUT STD_LOGIC
                 );
end component de2_wm8731_audio;

                signal internal_AUD_ADCLRCK :  STD_LOGIC;
                signal internal_AUD_DACDAT :  STD_LOGIC;
                signal internal_AUD_DACLRCK :  STD_LOGIC;
                signal internal_audio_request :  STD_LOGIC;

begin

  --the_de2_wm8731_audio, which is an e_instance
  the_de2_wm8731_audio : de2_wm8731_audio
    port map(
      AUD_ADCLRCK => internal_AUD_ADCLRCK,
      AUD_BCLK => AUD_BCLK,
      AUD_DACDAT => internal_AUD_DACDAT,
      AUD_DACLRCK => internal_AUD_DACLRCK,
      audio_request => internal_audio_request,
      AUD_ADCDAT => AUD_ADCDAT,
      chipselect => chipselect,
      clk => clk,
      data => data,
      reset_n => reset_n,
      test_mode => test_mode,
      write => write,
      writedata => writedata
    );


  --vhdl renameroo for output signals
  AUD_ADCLRCK <= internal_AUD_ADCLRCK;
  --vhdl renameroo for output signals
  AUD_DACDAT <= internal_AUD_DACDAT;
  --vhdl renameroo for output signals
  AUD_DACLRCK <= internal_AUD_DACLRCK;
  --vhdl renameroo for output signals
  audio_request <= internal_audio_request;

end europa;

