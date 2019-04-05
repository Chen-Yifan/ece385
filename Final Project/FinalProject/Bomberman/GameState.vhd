---------------------------------------------------------------------------
--      GameState.vhd                                                    --
--      Matthew Grawe & Larry Resnik                                     --
--      Spring 2014 ECE 385 Final Project                                --
---------------------------------------------------------------------------
-- GameState controls the flow of logic in the game.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity GameState is
Port (  Clk : in std_logic;
        Reset : in std_logic;
        -- Signal saying the pause button was pressed.
        PressedStart : in std_logic;
        TimeUp : in std_logic;
        -- The state of the game we claim to be in. It follows the constants "OUT_*", not "state".
        CurrentState : out std_logic_vector(3 downto 0)
        );
end GameState;

architecture Behavioral of GameState is

type cntrl_state is (TITLE, TITLE_UNWAIT, PLAYING, RENEW, PAUSE, PAUSE_POLLING, UNPAUSE);
signal state, next_state : cntrl_state;

-- Game state constants as the top level entity would see them.
constant OUT_TITLE : std_logic_vector(3 downto 0) := x"0";
constant OUT_PLAYING : std_logic_vector(3 downto 0) := x"1";
constant OUT_PAUSE : std_logic_vector(3 downto 0) := x"2";
constant OUT_RENEW : std_logic_vector(3 downto 0) := x"3";

begin

ControlRegister : process (Reset, Clk)
begin
    if Reset = '1' then
        state <= TITLE;
    elsif falling_edge(Clk) then
        state <= next_state;
    end if;
end process;
    
-- Next State Assignment
GetNextState : process (state, PressedStart, TimeUp)
begin
	case state is
        when TITLE =>
            -- Wait for the pause key to be pressed.
            if PressedStart = '1' then
                next_state <= TITLE_UNWAIT;
            else
                next_state <= TITLE;
            end if;
        when TITLE_UNWAIT =>
            -- Wait for the pause key to be released.
            if PressedStart = '1' then
                next_state <= TITLE_UNWAIT;
            else
                next_state <= RENEW;
            end if;
        when RENEW =>
            next_state <= PLAYING;
        when PLAYING =>
            if PressedStart = '1' then
                next_state <= PAUSE;
            elsif TimeUp = '1' then
                next_state <= TITLE;
            else
                next_state <= PLAYING;
            end if;
        when PAUSE =>
            -- We were put into the pause screen.
            -- Wait for the pause key to be released.
            if PressedStart = '1' then
                next_state <= PAUSE;
            else
                next_state <= PAUSE_POLLING;
            end if;
        when PAUSE_POLLING =>
            -- We are in the pause screen.
            -- Wait for the pause key to be pressed again for an unpause.
            if PressedStart = '1' then
                next_state <= UNPAUSE;
            else
                next_state <= PAUSE_POLLING;
            end if;
        when UNPAUSE =>
            -- We are in the pause screen.
            -- Wait for the pause key to be released to play the game.
            if PressedStart = '1' then
                next_state <= UNPAUSE;
            else
                next_state <= PLAYING;
            end if;
        when others =>
            next_state <= TITLE;
    end case;
end process;

SetOutputs : process (Clk, state)
begin
    -- Defaults
    CurrentState <= x"0";
    
	case state is
        when TITLE =>
            CurrentState <= OUT_TITLE;
        when TITLE_UNWAIT =>
            CurrentState <= OUT_TITLE;
        when RENEW =>
            CurrentState <= OUT_RENEW;
        when PLAYING =>
            CurrentState <= OUT_PLAYING;
        when PAUSE =>
            CurrentState <= OUT_PAUSE;
        when PAUSE_POLLING =>
            CurrentState <= OUT_PAUSE;
        when UNPAUSE =>
            CurrentState <= OUT_PAUSE;
        when others =>
            CurrentState <= OUT_TITLE;
	end case;
end process;

end Behavioral;

