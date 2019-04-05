---------------------------------------------------------------------------
--      ColorMapper.vhd                                                  --
--      Matthew Grawe & Larry Resnik                                     --
--      Spring 2014 ECE 385 Final Project                                --
---------------------------------------------------------------------------
-- ColorMapper takes a pixel coordinate and decides what color to assign to it.
-- It is the "paint" function of ordinary programs in that it is the only
-- part of the code that knows how to actually draw anything.
--
-- Original by Stephen Kempf 03/01/2006
-- Modified by David Kesler 07/16/2008
-- This variant by Larry Resnik 05/01/2014
-- For use in University of Illinois ECE Department, ECE 385 Lab 9

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ColorMapper is
Port (  BombermanX : in std_logic_vector(9 downto 0);
        BombermanY : in std_logic_vector(9 downto 0);
        BombermanWidth : in std_logic_vector(9 downto 0);
        BombermanHeight : in std_logic_vector(9 downto 0);
        -- Currently, we do not use the Speed for anything.
        BombermanSpeedX : in std_logic_vector(9 downto 0);
        BombermanSpeedY : in std_logic_vector(9 downto 0);
        -- DrawX/Y is where the VGAController wants us to render.
        DrawX : in std_logic_vector(9 downto 0);
        DrawY : in std_logic_vector(9 downto 0);
        Bomberman_size : in std_logic_vector(9 downto 0);
        -- BombX/Y is where our only Bomb is.
        BombX : in std_logic_vector(9 downto 0);
        BombY : in std_logic_vector(9 downto 0);
        BombState : in std_logic_vector(2 downto 0);
        -- Send the whole map to the ColorMapper.
        Tiles0 : in std_logic_vector(43 downto 0);
        Tiles1 : in std_logic_vector(43 downto 0);
        Tiles2 : in std_logic_vector(43 downto 0);
        Tiles3 : in std_logic_vector(43 downto 0);
        Tiles4 : in std_logic_vector(43 downto 0);
        Tiles5 : in std_logic_vector(43 downto 0);
        Tiles6 : in std_logic_vector(43 downto 0);
        Tiles7 : in std_logic_vector(43 downto 0);
        Tiles8 : in std_logic_vector(43 downto 0);
        GameStateValue : in std_logic_vector(3 downto 0);
        PlayerStateValue : in std_logic_vector(3 downto 0);
        -- Progress bar is the game timer. When it runs out, the game is over.
        progressBar : in std_logic_vector(10 downto 0);
        -- Floor Counter is the token counter. When Bomberman reaches an exit, it increments.
        floorCounter : in std_logic_vector(10 downto 0);
        -- The colors to assign the pixel. Based on ColorTable's output.
        Red   :  out std_logic_vector(9 downto 0);
        Green :  out std_logic_vector(9 downto 0);
        Blue  :  out std_logic_vector(9 downto 0);
        Clk   :  in std_logic;
        Reset :  in std_logic
        );
end ColorMapper;

architecture Behavioral of ColorMapper is

-- Determine the extremities of the map. Center it using a division by two, but re-align it to modulus 16.
-- The alignment to 16 allows us to easily keep tile/object rendering and logic aligned.
-- That is because all sprites are 16x16 in size.
-- (ScreenWidth - ImageWidth * NumTileCols) / 2 = (640 - 16 * 11) / 2 = 232
-- int(232 / 16) = 14, so that is our best number to work with to be aligned by tiles.
-- MAP_START_X = 14 * 16 = 224
-- MAP_END_X = MAP_START_X + NumTiles * TileWidth = 224 + 11 * 16 = 400
constant MAP_START_X : integer := 224;
constant MAP_END_X : integer := 400;

-- (ScreenHeight - ImageHeight * NumTileRows) / 2 = (480 - 16 * 9) / 2 = 168
-- int(168 / 16) = 10
-- 10 * 16 = 160 which is the best alignment we can get to the tiles.
-- 160 + 9 * 16 = 304
constant MAP_START_Y : integer := 160;
constant MAP_END_Y : integer := 304;

-- Where the exit is. It's the end point pixels minus a tile. 400 - 32 = 368, 304 - 32 = 272
constant EXIT_X : integer := 368;
constant EXIT_Y : integer := 272;
-- Where the exit is in terms of tiles. Simply the pixel values divided by 16.
constant EXIT_X_TILE : integer := 23;
constant EXIT_Y_TILE : integer := 17;

-- The number of "tiles" the map is offsetted from the monitor. Used to make tile coordinates code offsets work.
-- The calculation is simply the extremity of the map divided by 16.
constant MAP_LEFT_TILE : integer := 14;
constant MAP_TOP_TILE : integer := 10;
constant MAP_RIGHT_TILE : integer := 25;
constant MAP_BOTTOM_TILE : integer := 19;

component MapRowAccess is
Port(   Clk : in std_logic;
        Addr : in std_logic_vector(3 downto 0);
        Tiles0 : in std_logic_vector(43 downto 0);
        Tiles1 : in std_logic_vector(43 downto 0);
        Tiles2 : in std_logic_vector(43 downto 0);
        Tiles3 : in std_logic_vector(43 downto 0);
        Tiles4 : in std_logic_vector(43 downto 0);
        Tiles5 : in std_logic_vector(43 downto 0);
        Tiles6 : in std_logic_vector(43 downto 0);
        Tiles7 : in std_logic_vector(43 downto 0);
        Tiles8 : in std_logic_vector(43 downto 0);
        Row : out std_logic_vector(43 downto 0));
end component MapRowAccess;

component ColorTable is
Port (  Color : in std_logic_vector(1 downto 0);
        Red   : out std_logic_vector(9 downto 0);
        Green : out std_logic_vector(9 downto 0);
        Blue  : out std_logic_vector(9 downto 0));
end component ColorTable;

component SpriteTable is
Port (  Clk : in std_logic;
        SpriteID : in std_logic_vector(4 downto 0);
        Addr : in std_logic_vector(15 downto 0);
        HorizontalColors : out std_logic_vector(31 downto 0));
end component SpriteTable;

component MassiveSprites is
Port (  Clk : in std_logic;
        Addr : in std_logic_vector(7 downto 0);
        TitleHorizontalColors : out std_logic_vector(319 downto 0);
        PauseHorizontalColors : out std_logic_vector(319 downto 0));
end component MassiveSprites;

-- SIGNALS
-- When one of these flags are on, that thing must be drawn.
signal drawBomberman, drawTiles, drawExit, drawBomb1, drawMassiveSprite, drawProgress, drawFloorCounter : std_logic;
-- The color index of what we want to use. Converted by ColorTable to an RGB value.
signal ColorSig : std_logic_vector(1 downto 0);
-- If we assign a color, this is the mapped color from ColorTable.
signal RedMapped, GreenMapped, BlueMapped : std_logic_vector(9 downto 0);
-- Signals that connect to the Sprite Table.
signal SpriteIDSig : std_logic_vector(4 downto 0);
signal SpriteHorizAddr : std_logic_vector(15 downto 0);
signal HorizontalColorsSig : std_logic_vector(31 downto 0);
-- Which row of a sprite is being rendered by the VGA. It is the VGA y-value modulus 16.
signal MapRenderAddr : std_logic_vector(3 downto 0);
-- The row in the map which must be rendered. Which row is selected is based on the VGA y-value.
signal MapRenderRow    : std_logic_vector(43 downto 0);

-- Massive Sprites signals. Not used if a MassiveSprites instance is not created.
signal MassiveSpriteHorizAddr : std_logic_vector(7 downto 0);
signal TitleHorizontalColorsSig, PauseHorizontalColorsSig : std_logic_vector(319 downto 0);

-- CONSTANTS
-- The type of tile.
-- Copy-pasted from Level.vhd
constant TILE_EMPTY : std_logic_vector := "0000";
constant TILE_BRICK : std_logic_vector := "0001";
constant TILE_BRICK_BROKEN : std_logic_vector := "0010";
constant TILE_EXP_CENTER : std_logic_vector := "0011";
constant TILE_EXP_UP : std_logic_vector := "0100";
constant TILE_EXP_DOWN : std_logic_vector := "0101";
constant TILE_EXP_LEFT : std_logic_vector := "0110";
constant TILE_EXP_RIGHT : std_logic_vector := "0111";
constant TILE_BLOCK : std_logic_vector := "1000";

-- Game state constants. Copy-pasted from GameState.vhd.
constant OUT_TITLE : std_logic_vector(3 downto 0) := x"0";
constant OUT_PLAYING : std_logic_vector(3 downto 0) := x"1";
constant OUT_PAUSE : std_logic_vector(3 downto 0) := x"2";
constant OUT_RENEW : std_logic_vector(3 downto 0) := x"3";

-- Begin Behavioral
begin

ColorTableInstance : ColorTable
Port Map(   Color => ColorSig,
            Red => RedMapped,
            Green => GreenMapped,
            Blue => BlueMapped);

SpriteTableInstance : SpriteTable
Port Map(   Clk => Clk,
            SpriteID => SpriteIDSig,
            Addr => SpriteHorizAddr,
            HorizontalColors => HorizontalColorsSig);

--MassiveSpritesInstance : MassiveSprites
--Port Map(   Clk => Clk,
--            Addr => MassiveSpriteHorizAddr,
--            TitleHorizontalColors => TitleHorizontalColorsSig,
--            PauseHorizontalColors => PauseHorizontalColorsSig);

-- Which row of tiles we are rendering.
RenderRowAccess : MapRowAccess
Port Map(   Clk => Clk,
            Addr => MapRenderAddr,
            Tiles0 => Tiles0,
            Tiles1 => Tiles1,
            Tiles2 => Tiles2,
            Tiles3 => Tiles3,
            Tiles4 => Tiles4,
            Tiles5 => Tiles5,
            Tiles6 => Tiles6,
            Tiles7 => Tiles7,
            Tiles8 => Tiles8,
            Row => MapRenderRow);
            
drawTilesProcess : process (DrawX, DrawY)
begin
    -- Check if we are within the bounds of the tile map.
    -- This warns us to draw tiles such as blocks, bricks, and explosions.
    if DrawX >= MAP_START_X and DrawX < MAP_END_X and DrawY >= MAP_START_Y and DrawY < MAP_END_Y then
        drawTiles <= '1';
        -- Select which row of tiles the VGA pixel is on. Calculate it as follows:
        -- MapRow = (VGA_Y - MAP_START_Y) / 16
        -- A division by 16 is the same thing as a right shift by 4, so drop the lowest 4 bits.
        MapRenderAddr <= conv_std_logic_vector(conv_integer(unsigned(DrawY)) - MAP_START_Y, 22)(7 downto 4);
    else
        drawTiles <= '0';
        MapRenderAddr <= x"0";
    end if;
end process;

drawProgressBarProcess : process (DrawX, DrawY)
begin
    -- Check if we are within 16 pixels below the tile map to draw the progress bar.
    if DrawX >= MAP_START_X and DrawX < MAP_END_X and DrawY >= MAP_END_Y and DrawY < MAP_END_Y + 16 then
        drawProgress <= '1';
    else
        drawProgress <= '0';
    end if;
end process;

drawFloorCounterProcess : process (DrawX, DrawY)
begin
    -- Check if we are within 16 pixels above the tile map to draw the floor counter bar.
    if DrawX >= MAP_START_X and DrawX < MAP_END_X and DrawY >= MAP_START_Y - 16 and DrawY < MAP_START_Y then
        drawFloorCounter <= '1';
    else
        drawFloorCounter <= '0';
    end if;
end process;

drawBombermanProcess : process (BombermanX, BombermanY, BombermanWidth, BombermanHeight, DrawX, DrawY, Bomberman_size)
begin
    -- Check if the VGA pixel is on Bomberman's sprite.
    if ((DrawX >= BombermanX) and (DrawX < (BombermanX + BombermanWidth - 0)) and (DrawY >= BombermanY) and (DrawY < (BombermanY + BombermanHeight - 0))) then
        drawBomberman <= '1';
    else
        drawBomberman <= '0';
    end if;
end process drawBombermanProcess;

drawExitProcess : process (DrawX, DrawY, BombermanWidth, BombermanHeight)
begin
    -- Check if the VGA pixel is on the Exit panel.
    if (DrawX >= EXIT_X) and (DrawX < (EXIT_X + conv_integer(BombermanWidth))) and (DrawY >= EXIT_Y) and (DrawY < (EXIT_Y + conv_integer(BombermanHeight))) then
        drawExit <= '1';
    else
        drawExit <= '0';
    end if;
end process drawExitProcess;

-- 001 for TICKING, 010 for EXPLODING
drawBomb1Process: process(BombX, BombY, BombermanWidth, BombermanHeight, DrawX, DrawY, BombState)
begin
    -- Check if the VGA pixel is on the bomb AND the bomb has its fuse lit.
    if BombState = "001" then -- ticking or exploding, then draw the bomb on the screen.
        if ((DrawX >= BombX) and (DrawX <= (BombX + BombermanWidth - 1)) and (DrawY >= BombY) and (DrawY <= (BombY + BombermanHeight - 1))) then
            drawBomb1 <= '1';
        else
            drawBomb1 <= '0';
        end if;
    else
        drawBomb1 <= '0';
    end if;
end process drawBomb1Process;

drawMassiveSpriteProcess : process (DrawX, DrawY)
begin
    -- Check if we are within the massive sprite's boundaries.
    -- Each massive sprite is 160x144 in dimension.
    if (DrawX >= MAP_START_X) and (DrawX < (MAP_START_X + 160)) and (DrawY >= MAP_START_Y) and (DrawY < (MAP_START_Y + 144)) then
        drawMassiveSprite <= '1';
    else
        drawMassiveSprite <= '0';
    end if;
end process drawMassiveSpriteProcess;

-- Assign a color to the pixel that the VGA controller is focusing.
-- This function must be able to render anything and everything.
RGB_Display : process (drawFloorCounter, drawProgress, drawMassiveSprite, drawExit, drawTiles, drawBomberman, drawBomb1, DrawX, DrawY, PlayerStateValue, BombermanX, BombermanY, BombX, BombY, RedMapped, GreenMapped, BlueMapped, HorizontalColorsSig, MapRenderRow, GameStateValue, TitleHorizontalColorsSig, PauseHorizontalColorsSig, progressBar, floorCounter)
-- The color to draw this pixel. Will be given to ColorTable.
-- All color bits are two bits wide, so it is PrePixelColorBits * 2.
variable PixelColorBits : integer range 0 to 639;
-- The offset within a sprite to determine which bit to get the pixel's color from.
variable PrePixelColorBits : integer range 0 to 639;
variable TileType : std_logic_vector(3 downto 0);
variable spriteX, spriteXTimes2 : integer range 0 to 511;
begin
    ColorSig <= "00";
    SpriteIDSig <= (others => '0');
    SpriteHorizAddr <= (others => '0');
    MassiveSpriteHorizAddr <= (others => '0');

    -- Default to drawing a white scenery.
    Red   <= (others => '1');
    Green <= (others => '1');
    Blue  <= (others => '1');

--    if GameStateValue = OUT_TITLE or GameStateValue = OUT_PAUSE then
--        -- Draw the title screen.
--        if drawMassiveSprite = '1' then
--            -- We did not draw an object, so render the map. Figure out what tile to render on this pixel.
--            -- By now, we already have the map row assigned and the proper map row outputted in MapRenderRow,
--            -- so we need to get the tile defined in the column we want.
--            PrePixelColorBits := conv_integer(conv_std_logic_vector(conv_integer(unsigned(DrawX)) - MAP_START_X, 22)(7 downto 4));
--            -- Uncomment this line to draw all tiles in forwards order.
--            --PrePixelColorBits := MAP_RIGHT_TILE -  conv_integer(unsigned(DrawX(7 downto 4))) - 1;
--
--            -- We have the X-value, but multiply it by four because there's four bits per tile.
--            PixelColorBits := PrePixelColorBits + PrePixelColorBits + PrePixelColorBits + PrePixelColorBits;
--            MassiveSpriteHorizAddr <= conv_std_logic_vector((conv_integer(unsigned(DrawY)) - MAP_START_Y), 8);
--            spriteX := conv_integer(unsigned(DrawX)) - MAP_START_X;
--            spriteXTimes2 := spriteX + spriteX;
--            if GameStateValue = OUT_TITLE or GameStateValue = OUT_RENEW then
--                -- Draw the title screen.
--                ColorSig <= TitleHorizontalColorsSig(spriteXTimes2+1 downto spriteXTimes2);
--            else
--                -- Draw the pause screen.
--                ColorSig <= PauseHorizontalColorsSig(spriteXTimes2+1 downto spriteXTimes2);
--            end if;
--
--            Red <= RedMapped;
--            Green <= GreenMapped;
--            Blue <= BlueMapped;
--        end if;
--    elsif (drawBomberman = '1') then
    if (drawBomberman = '1') then
        -- We are on the sprite, so select the correct color.
        SpriteHorizAddr <= conv_std_logic_vector((conv_integer(unsigned(DrawY)) - conv_integer(unsigned(BombermanY))), 16);
        -- Choose Bomberman's sprite based on his state.
        case PlayerStateValue is
            when "0000" => -- FACE_DOWN0
                SpriteIDSig <= "01101";
            when "0001" => -- FACE_DOWN1
                SpriteIDSig <= "10001";
            when "0100" => -- FACE_UP0
                SpriteIDSig <= "01110";
            when "0101" => -- FACE_UP1
                SpriteIDSig <= "10010";
            when "1000" => -- FACE_LEFT0
                SpriteIDSig <= "01111";
            when "1001" => -- FACE_LEFT1
                SpriteIDSig <= "10011";
            when "1100" => -- FACE_RIGHT0
                SpriteIDSig <= "10000";
            when "1101" => -- FACE_RIGHT1
                SpriteIDSig <= "10100";
            when "1111" => -- DEAD
                SpriteIDSig <= "00011";
            when others =>
                SpriteIDSig <= "00011";
        end case;
        PrePixelColorBits := conv_integer(BombermanX) - conv_integer(DrawX) - 1;
        -- There are two bits per color, so we must double the value of our index.
        PixelColorBits := PrePixelColorBits + PrePixelColorBits;
        -- The HorizontalColorsSig is 32 bits wide, but we want just 2 of those bits.
        -- That is, HorizontalColorsSig is composed of 16 colors but we only want one color.
        ColorSig <= HorizontalColorsSig(PixelColorBits+1 downto PixelColorBits);
        -- Assign the colors to be what the ColorMapper decides.
        Red <= RedMapped;
        Green <= GreenMapped;
        Blue <= BlueMapped;
    elsif drawBomb1 = '1' then
        SpriteHorizAddr <= conv_std_logic_vector((conv_integer(unsigned(DrawY)) - conv_integer(unsigned(BombY))), 16);
        SpriteIDSig <= "00100";
        PrePixelColorBits := conv_integer(BombX) - conv_integer(DrawX)-1;
        PixelColorBits := PrePixelColorBits + PrePixelColorBits;
        ColorSig <= HorizontalColorsSig(PixelColorBits+1 downto PixelColorBits);
        Red <= RedMapped;
        Green <= GreenMapped;
        Blue <= BlueMapped;
    elsif drawExit = '1' then
        SpriteHorizAddr <= conv_std_logic_vector((conv_integer(unsigned(DrawY)) - EXIT_Y), 16);
        SpriteIDSig <= "01100";
        PrePixelColorBits := EXIT_Y - conv_integer(DrawX)-1;
        PixelColorBits := PrePixelColorBits + PrePixelColorBits;
        ColorSig <= HorizontalColorsSig(PixelColorBits+1 downto PixelColorBits);
        Red <= RedMapped;
        Green <= GreenMapped;
        Blue <= BlueMapped;
    elsif drawTiles = '1' then
        -- We did not draw an object, so render the map. Figure out what tile to render on this pixel.
        -- By now, we already have the map row assigned and the proper map row outputted in MapRenderRow,
        -- so we need to get the tile defined in the column we want.
        -- A division by 16 is the same thing as a right shift by 4, so drop the lowest 4 bits.
        PrePixelColorBits := conv_integer(conv_std_logic_vector(conv_integer(unsigned(DrawX)) - MAP_START_X, 22)(7 downto 4));
        -- Uncomment this line to draw all tiles in forwards order without being flipped horizontally.
        --PrePixelColorBits := MAP_RIGHT_TILE -  conv_integer(unsigned(DrawX(7 downto 4))) - 1;

        PixelColorBits := PrePixelColorBits + PrePixelColorBits + PrePixelColorBits + PrePixelColorBits;
        TileType := MapRenderRow(PixelColorBits+3 downto PixelColorBits);
        -- The y-location within the tile the VGA pixel is at is simply the pixel's y-value modulus 16.
        -- This works because the entire map is aligned to 16 pixels!
        SpriteHorizAddr <= "000000000000" & DrawY(3 downto 0);
        spriteX := conv_integer(unsigned(DrawX(3 downto 0)));
        spriteXTimes2 := spriteX + spriteX;
        ColorSig <= HorizontalColorsSig(spriteXTimes2+1 downto spriteXTimes2);

        case TileType is
            when TILE_EMPTY =>
                SpriteIDSig <= "00101";
            when TILE_BLOCK =>
                SpriteIDSig <= "00001";
            when TILE_BRICK =>
                SpriteIDSig <= "00010";
            when TILE_BRICK_BROKEN =>
                SpriteIDSig <= "00110";
            when TILE_EXP_CENTER =>
                SpriteIDSig <= "00111";
            when TILE_EXP_LEFT =>
                SpriteIDSig <= "01000";
            when TILE_EXP_RIGHT =>
                SpriteIDSig <= "01001";
            when TILE_EXP_DOWN =>
                SpriteIDSig <= "01010";
            when TILE_EXP_UP =>
                SpriteIDSig <= "01011";
            when others =>
                SpriteIDSig <= "00000";
        end case;
        
        Red <= RedMapped;
        Green <= GreenMapped;
        Blue <= BlueMapped;
    elsif drawProgress = '1' then
        -- Render the progress bar. It is a bunch of clock symbols indicating the leftover time.
        -- Note that PrePixelColorBits ALSO holds the offset in the progressBar to draw.
        PrePixelColorBits := conv_integer(conv_std_logic_vector(conv_integer(unsigned(DrawX)) - MAP_START_X, 22)(7 downto 4));
        -- Walk through the array and draw an icon for it whenever that bit is high.
        if progressBar(PrePixelColorBits) = '0' then
            SpriteIDSig <= "00000";
        else
            SpriteIDSig <= "10101";
        end if;
        SpriteHorizAddr <= "000000000000" & DrawY(3 downto 0);
        spriteX := conv_integer(unsigned(DrawX(3 downto 0)));
        spriteXTimes2 := spriteX + spriteX;
        ColorSig <= HorizontalColorsSig(spriteXTimes2+1 downto spriteXTimes2);
        Red <= RedMapped;
        Green <= GreenMapped;
        Blue <= BlueMapped;
    elsif drawFloorCounter = '1' then
        -- Render the floor counter bar. It is a bunch of gems indicating how many floors were cleared.
        -- Note that PrePixelColorBits ALSO holds the offset in the floorCounter to draw.
        PrePixelColorBits := conv_integer(conv_std_logic_vector(conv_integer(unsigned(DrawX)) - MAP_START_X, 22)(7 downto 4));
        if floorCounter(PrePixelColorBits) = '0' then
            SpriteIDSig <= "00000";
        else
            SpriteIDSig <= "10110";
        end if;
        SpriteHorizAddr <= "000000000000" & DrawY(3 downto 0);
        spriteX := conv_integer(unsigned(DrawX(3 downto 0)));
        spriteXTimes2 := spriteX + spriteX;
        ColorSig <= HorizontalColorsSig(spriteXTimes2+1 downto spriteXTimes2);
        Red <= RedMapped;
        Green <= GreenMapped;
        Blue <= BlueMapped;
    end if;
end process RGB_Display;

end Behavioral;

