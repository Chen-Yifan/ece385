---------------------------------------------------------------------------
--      PlayerState.vhd                                                  --
--      Matthew Grawe & Larry Resnik                                     --
--      Spring 2014 ECE 385 Final Project                                --
---------------------------------------------------------------------------
-- PlayerState controls the state of Bomberman.

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity PlayerState is
Port (  Clk : in std_logic;
        Reset : in std_logic;
        -- Whether or not Bomberman was hit by a bomb.
        GotHit : in std_logic;
        -- How fast Bomberman is moving this clock cycle. Used for animation.
        BombermanSpeedX : in std_logic_vector(9 downto 0);
        BombermanSpeedY : in std_logic_vector(9 downto 0);
        PlayerStateValue : out std_logic_vector(3 downto 0)
);
end PlayerState;

architecture Behavioral of PlayerState is

-- The FACE_* states say that Bomberman is facing some direction. The number is the animation ID.
-- DEAD means Bomberman was hit by a bomb.
-- REVIVE means Bomberman has recovered from a bomb explosion.
type cntrl_state is (FACE_DOWN0, FACE_DOWN1, FACE_LEFT0, FACE_LEFT1, FACE_RIGHT0, FACE_RIGHT1, FACE_UP0, FACE_UP1, DEAD, REVIVE);
signal state, next_state : cntrl_state;

signal AnimationTimer : std_logic_vector(32 downto 0);
-- In our states, we may recognize that we must reset the timer.
-- It will use this signal to do so.
signal ResetTimer : std_logic;

-- When the top bit of the timer defined by these variables goes high, the timer ends.
-- For example, ANIM_TEMP = 5 would tell the timer to restart when the timer gets to "[...]00010000".
constant ANIM_DEAD_TO_REVIVE : integer := 26;
constant ANIM_WALK : integer := 23;

begin

ControlRegister : process (Reset, Clk)
begin
    if Reset = '1' then
        state <= FACE_DOWN0;
    elsif rising_edge(Clk) then
        state <= next_state;
    end if;
end process;
    
-- Next State Assignment
GetNextState : process (state, GotHit, BombermanSpeedX, BombermanSpeedY, AnimationTimer)
begin
    ResetTimer <= '1';
    if state /= DEAD and GotHit = '1' then
        -- Regardless of what Bomberman's state is, getting hit by an explosion takes precedence.
        next_state <= DEAD;
    else
        case state is
            when FACE_DOWN0 =>
                -- Check if Bomberman's speed is non-zero. That means he's facing a new direction.
                -- If the speed is positive, the most significant bit (MSB) of the number is '0'.
                -- Likewise, negative speed has an MSB of '1'. These numbers are in two's complement notation.
                if    BombermanSpeedX /= "000000000" and BombermanSpeedX(9) = '0' then -- Going right.
                    next_state <= FACE_RIGHT0;
                elsif BombermanSpeedX /= "000000000" and BombermanSpeedX(9) = '1' then -- Going left.
                    next_state <= FACE_LEFT0;
                elsif BombermanSpeedY /= "000000000" and BombermanSpeedY(9) = '1' then -- Going up.
                    next_state <= FACE_UP0;
                elsif BombermanSpeedY /= "000000000" and BombermanSpeedY(9) = '0' then -- Going down.
                    -- We are already facing this direction, but we are moving as well.
                    -- Check if we have been moving long enough to change the sprite (show animation).
                    if AnimationTimer(ANIM_WALK) = '1' then -- We've been walking long enough to change the animation.
                        next_state <= FACE_DOWN1;
                        ResetTimer <= '1';
                    else
                        next_state <= FACE_DOWN0;
                        ResetTimer <= '0';
                    end if;
                else -- Stay in animation zero of this direction.
                    next_state <= FACE_DOWN0;
                end if;
            when FACE_DOWN1 =>
                if    BombermanSpeedX /= "000000000" and BombermanSpeedX(9) = '0' then -- Going right.
                    next_state <= FACE_RIGHT0;
                elsif BombermanSpeedX /= "000000000" and BombermanSpeedX(9) = '1' then -- Going left.
                    next_state <= FACE_LEFT0;
                elsif BombermanSpeedY /= "000000000" and BombermanSpeedY(9) = '1' then -- Going up.
                    next_state <= FACE_UP0;
                elsif BombermanSpeedY /= "000000000" and BombermanSpeedY(9) = '0' then -- Going down.
                    if AnimationTimer(ANIM_WALK) = '1' then -- We've been walking long enough to change the animation.
                        next_state <= FACE_DOWN0;
                        ResetTimer <= '1';
                    else
                        next_state <= FACE_DOWN1;
                        ResetTimer <= '0';
                    end if;
                else -- Stay in animation zero of this direction.
                    next_state <= FACE_DOWN0;
                end if;
            when FACE_UP0 =>
                if    BombermanSpeedX /= "000000000" and BombermanSpeedX(9) = '0' then -- Going right.
                    next_state <= FACE_RIGHT0;
                elsif BombermanSpeedX /= "000000000" and BombermanSpeedX(9) = '1' then -- Going left.
                    next_state <= FACE_LEFT0;
                elsif BombermanSpeedY /= "000000000" and BombermanSpeedY(9) = '1' then -- Going up.
                    if AnimationTimer(ANIM_WALK) = '1' then -- We've been walking long enough to change the animation.
                        next_state <= FACE_UP1;
                        ResetTimer <= '1';
                    else
                        next_state <= FACE_UP0;
                        ResetTimer <= '0';
                    end if;
                elsif BombermanSpeedY /= "000000000" and BombermanSpeedY(9) = '0' then -- Going down.
                    next_state <= FACE_DOWN0;
                else -- Stay in animation zero of this direction.
                    next_state <= FACE_UP0;
                end if;
            when FACE_UP1 =>
                if    BombermanSpeedX /= "000000000" and BombermanSpeedX(9) = '0' then -- Going right.
                    next_state <= FACE_RIGHT0;
                elsif BombermanSpeedX /= "000000000" and BombermanSpeedX(9) = '1' then -- Going left.
                    next_state <= FACE_LEFT0;
                elsif BombermanSpeedY /= "000000000" and BombermanSpeedY(9) = '1' then -- Going up.
                    if AnimationTimer(ANIM_WALK) = '1' then -- We've been walking long enough to change the animation.
                        next_state <= FACE_UP0;
                        ResetTimer <= '1';
                    else
                        next_state <= FACE_UP1;
                        ResetTimer <= '0';
                    end if;
                elsif BombermanSpeedY /= "000000000" and BombermanSpeedY(9) = '0' then -- Going down.
                    next_state <= FACE_DOWN0;
                else -- Stay in animation zero of this direction.
                    next_state <= FACE_UP0;
                end if;
            when FACE_LEFT0 =>
                if    BombermanSpeedX /= "000000000" and BombermanSpeedX(9) = '0' then -- Going right.
                    next_state <= FACE_RIGHT0;
                elsif BombermanSpeedX /= "000000000" and BombermanSpeedX(9) = '1' then -- Going left.
                    if AnimationTimer(ANIM_WALK) = '1' then -- We've been walking long enough to change the animation.
                        next_state <= FACE_LEFT1;
                        ResetTimer <= '1';
                    else
                        next_state <= FACE_LEFT0;
                        ResetTimer <= '0';
                    end if;
                elsif BombermanSpeedY /= "000000000" and BombermanSpeedY(9) = '1' then -- Going up.
                    next_state <= FACE_UP0;
                elsif BombermanSpeedY /= "000000000" and BombermanSpeedY(9) = '0' then -- Going down.
                    next_state <= FACE_DOWN0;
                else -- Stay in animation zero of this direction.
                    next_state <= FACE_LEFT0;
                end if;
            when FACE_LEFT1 =>
                if    BombermanSpeedX /= "000000000" and BombermanSpeedX(9) = '0' then -- Going right.
                    next_state <= FACE_RIGHT0;
                elsif BombermanSpeedX /= "000000000" and BombermanSpeedX(9) = '1' then -- Going left.
                    if AnimationTimer(ANIM_WALK) = '1' then -- We've been walking long enough to change the animation.
                        next_state <= FACE_LEFT0;
                        ResetTimer <= '1';
                    else
                        next_state <= FACE_LEFT1;
                        ResetTimer <= '0';
                    end if;
                elsif BombermanSpeedY /= "000000000" and BombermanSpeedY(9) = '1' then -- Going up.
                    next_state <= FACE_UP0;
                elsif BombermanSpeedY /= "000000000" and BombermanSpeedY(9) = '0' then -- Going down.
                    next_state <= FACE_DOWN0;
                else -- Stay in animation zero of this direction.
                    next_state <= FACE_LEFT0;
                end if;
            when FACE_RIGHT0 =>
                if    BombermanSpeedX /= "000000000" and BombermanSpeedX(9) = '0' then -- Going right.
                    if AnimationTimer(ANIM_WALK) = '1' then -- We've been walking long enough to change the animation.
                        next_state <= FACE_RIGHT1;
                        ResetTimer <= '1';
                    else
                        next_state <= FACE_RIGHT0;
                        ResetTimer <= '0';
                    end if;
                elsif BombermanSpeedX /= "000000000" and BombermanSpeedX(9) = '1' then -- Going left.
                    next_state <= FACE_LEFT0;
                elsif BombermanSpeedY /= "000000000" and BombermanSpeedY(9) = '1' then -- Going up.
                    next_state <= FACE_UP0;
                elsif BombermanSpeedY /= "000000000" and BombermanSpeedY(9) = '0' then -- Going down.
                    next_state <= FACE_DOWN0;
                else -- Stay in animation zero of this direction.
                    next_state <= FACE_RIGHT0;
                end if;
            when FACE_RIGHT1 =>
                if    BombermanSpeedX /= "000000000" and BombermanSpeedX(9) = '0' then -- Going right.
                    if AnimationTimer(ANIM_WALK) = '1' then -- We've been walking long enough to change the animation.
                        next_state <= FACE_RIGHT0;
                        ResetTimer <= '1';
                    else
                        next_state <= FACE_RIGHT1;
                        ResetTimer <= '0';
                    end if;
                elsif BombermanSpeedX /= "000000000" and BombermanSpeedX(9) = '1' then -- Going left.
                    next_state <= FACE_LEFT1;
                elsif BombermanSpeedY /= "000000000" and BombermanSpeedY(9) = '1' then -- Going up.
                    next_state <= FACE_UP0;
                elsif BombermanSpeedY /= "000000000" and BombermanSpeedY(9) = '0' then -- Going down.
                    next_state <= FACE_DOWN0;
                else -- Stay in animation zero of this direction.
                    next_state <= FACE_RIGHT0;
                end if;
            when REVIVE =>
                -- Bomberman has recovered from an explosion hit.
                -- Make him face downwards because the sprite transition is clean.
                next_state <= FACE_DOWN0;
            when DEAD =>
                ResetTimer <= '0';
                -- Do not allow Bomberman to act until he has waited long enough to recover from a hit.
                if AnimationTimer(ANIM_DEAD_TO_REVIVE) = '1' then
                    next_state <= REVIVE;
                    ResetTimer <= '1';
                else
                    next_state <= DEAD;
                end if;
            when others =>
                next_state <= DEAD;
        end case;
    end if;
end process;

SetOutputs : process (Clk, state)
begin
    -- Assign the state of Bomberman based on the direction he is facing.
    -- There is a meaning to the FACE_* codes.
    -- The higher two bits represent the direction he moves.
    -- 00, 01, 10, and 11 are respectively down, up, left, and right.
    -- The lowest bit represents if Bomberman's foot is stepping out or not.
    -- When '0', Bomberman may just be standing still.
	case state is
        when FACE_DOWN0 =>
            PlayerStateValue <= "0000";
        when FACE_DOWN1 =>
            PlayerStateValue <= "0001";
        when FACE_UP0 =>
            PlayerStateValue <= "0100";
        when FACE_UP1 =>
            PlayerStateValue <= "0101";
        when FACE_LEFT0 =>
            PlayerStateValue <= "1000";
        when FACE_LEFT1 =>
            PlayerStateValue <= "1001";
        when FACE_RIGHT0 =>
            PlayerStateValue <= "1100";
        when FACE_RIGHT1 =>
            PlayerStateValue <= "1101";
        when DEAD =>
            PlayerStateValue <= "1111";
        when REVIVE =>
            PlayerStateValue <= "0010";
        when others =>
            PlayerStateValue <= "0000";
	end case;
end process;

IncrementTimer : process (Clk, Reset, ResetTimer)
begin
    if Reset = '1' then
        AnimationTimer <= (others => '0');
    elsif rising_edge(Clk) then
        if ResetTimer = '1' then
            AnimationTimer <= (others => '0');
        else
            AnimationTimer <= AnimationTimer + '1';
        end if;
    end if;
end process;

end Behavioral;


