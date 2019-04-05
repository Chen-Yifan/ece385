---------------------------------------------------------------------------
--      bomb.vhd                                                         --
--      Matthew Grawe & Larry Resnik                                     --
--      Spring 2014 ECE 385 Final Project                                --
--                                                                       -- 
--                                                                       --
--      The bomb entity handles the processing of the bomb state.        --
--      (Ticking, Exploding, dead states, position, and sound            --
--      scheduling functionality.                                        --
---------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity bomb is
Port (  setX                 : in  std_logic_vector(9 downto 0);
        setY                 : in  std_logic_vector(9 downto 0);
        getX                 : out std_logic_vector(9 downto 0);
        getY                 : out std_logic_vector(9 downto 0);
        
        -- output sound flags that feed into the sound entity for sound playback
        bomb_sound_flag      : out std_logic;
        explosion_sound_flag : out std_logic;
        Reset                : in  std_logic;
        
        -- setting the fuse triggers the bomb's explosion process (TICKING -> EXPLODING -> DEAD)
        set_fuse             : in  std_logic;
        bomb_state           : out std_logic_vector(2 downto 0); -- 000 for DEAD, 001 for TICKING, 010 for EXPLODING
        clk                  : in  std_logic;
        paused               : in  std_logic -- used to hold the timers when pause is pressed
        --LEDS                 : out  std_logic_vector(17 downto 0)
        );
end bomb;

architecture Behavioral of bomb is

signal set_fuseSig : std_logic;
signal bomb_timer                         : std_logic_vector(26 downto 0);
signal bomb_ticking, bomb_reset, bomb_sound_flagSig                : std_logic;
signal explosion_ticking, explosion_reset, explosion_sound_flagSig : std_logic;
signal explosion_timer                    : std_logic_vector(25 downto 0);
signal xSig, ySig                         : std_logic_vector(21 downto 0);

-- control state for the bomb's state machine
type cntrl_state is (BOMB_TICKING_A, BOMB_TICKING_B, BOMB_EXPLODING_A, BOMB_EXPLODING_B, BOMB_DONE_EXPLODING, BOMB_DEAD);
signal state, next_state : cntrl_state;

begin

set_fuseSig          <= set_fuse;
bomb_sound_flag      <= bomb_sound_flagSig;
explosion_sound_flag <= explosion_sound_flagSig;

--LEDS(0) <= set_fuseSig;
--LEDS(1) <= bomb_ticking;
--LEDS(2) <= explosion_ticking;
--LEDS(3) <= bomb_reset;
--LEDS(4) <= bomb_sound_flagSig;
--LEDS(5) <= explosion_sound_flagSig;

-- state advancer process
	control_reg : process (Reset, Clk, paused)
	begin
		if (Reset = '1') then
			state <= BOMB_DEAD;
		elsif (rising_edge(Clk) and paused = '0') then
			state <= next_state;
		end if;
	end process;
    
-- Next State Assignment
get_next_state : process (state, bomb_timer, explosion_timer, set_fuseSig)
begin
	case state is
		when BOMB_TICKING_A   => -- We need to use 2 states for ticking because of the way that sound effects are handled (sound flag must go high, then low)
            next_state <= BOMB_TICKING_B;
        when BOMB_TICKING_B   =>
            if(bomb_timer = "111111111111111111111111111") then -- this essentially keeps the state the same until the appropriate timer expires.
                next_state <= BOMB_EXPLODING_A;
            else
                next_state <= BOMB_TICKING_B;
            end if;
		when BOMB_EXPLODING_A => -- same idea as above
            next_state <= BOMB_EXPLODING_B;
        when BOMB_EXPLODING_B =>
            if(explosion_timer = "11111111111111111111111111") then
                next_state <= BOMB_DEAD;
            else
                next_state <= BOMB_EXPLODING_B;
            end if;
        when BOMB_DONE_EXPLODING => -- this is used to 
            next_state <= BOMB_DEAD;
		when BOMB_DEAD        =>
            if(set_fuseSig = '1') then
                next_state <= BOMB_TICKING_A;
            else
                next_state <= BOMB_DEAD;
            end if;
		end case;
end process;

get_cntrl_out : process (Clk, state)
begin
    
    -- defaults
    bomb_reset              <= '0';
    bomb_ticking            <= '0';
    bomb_sound_flagSig      <= '0';
    
    explosion_reset         <= '0';
    explosion_ticking       <= '0';
    explosion_sound_flagSig <= '0';
    
	case state is
		when BOMB_TICKING_A   =>
            bomb_state <= "001";
            bomb_ticking <= '1';
            bomb_sound_flagSig <= '1';
        when BOMB_TICKING_B   =>
            bomb_ticking <= '1';
            bomb_state <= "001";
            bomb_sound_flagSig <= '0';
		when BOMB_EXPLODING_A =>
            explosion_ticking <= '1';
            explosion_sound_flagSig <= '1';
            --bomb_sound_flagSig <= '1';
            bomb_state <= "010";
        when BOMB_EXPLODING_B =>
            explosion_ticking <= '1';
            explosion_sound_flagSig <= '0';
            --bomb_sound_flagSig <= '0';
            bomb_state <= "010";
        when BOMB_DONE_EXPLODING =>
            bomb_state <= "011"; -- signifies the completion of the explosion process.
		when BOMB_DEAD        =>
            bomb_state <= "000";
            bomb_reset <= '1';
	end case;
end process;

-- bombticker basically maintains a counter used to fill the gap between bomb placement and bomb explosion.
bombticker : process(Clk, Reset, bomb_timer, bomb_ticking, bomb_reset, paused)
begin
    if (Reset = '1') then
        bomb_timer <= "000000000000000000000000000";
	elsif (rising_edge(Clk) and paused = '0') then
        if(bomb_ticking = '1') then
            bomb_timer <= bomb_timer + 1;
        else
            bomb_timer <= bomb_timer;
        end if;
            
        if(bomb_reset = '1') then
            bomb_timer <= "000000000000000000000000000";
        end if;
	end if;
end process;

-- explosinticker maintains a counter used to fill the gap between the beginning and the end of the explosion.
explosionticker: process(Clk, Reset, explosion_timer, explosion_ticking, paused)
begin
    if (Reset = '1') then
        explosion_timer <= "00000000000000000000000000";
	elsif (rising_edge(Clk) and paused = '0') then
        if(explosion_ticking = '1') then
            explosion_timer <= explosion_timer + 1;
        else
            explosion_timer <= explosion_timer;
        end if;           
        if(explosion_reset = '1') then
            explosion_timer <= "00000000000000000000000000";
        end if;        
        
	end if;
end process;

-- when bomberman places a bomb, we need to place the bomb near him -- to do this, we need to maintain a
-- position vector. This code is relatively self explanatory.
SetCoordinates : process(Clk, Reset, setX, setY, set_fuse)
begin
    if (Reset = '1') then
        getX <= "0000000000";
        getY <= "0000000000";
    elsif (rising_edge(Clk)) then
        if(set_fuse = '1' and state = BOMB_DEAD) then
            getX <= setX;
            getY <= setY;
        end if;
    end if;
end process;

end Behavioral;
