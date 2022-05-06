--LIBRARY IEEE;
--USE IEEE.STD_LOGIC_1164.all;
--USE  IEEE.STD_LOGIC_ARITH.all;
--USE  IEEE.STD_LOGIC_UNSIGNED.all;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

-- Entity declaration
-- 		Defines the interface to the entity

ENTITY VGA_Test IS


	PORT
	(
-- 	Note: It is easier to identify individual ports and change their order
--	or types when their declarations are on separate lines.
--	This also helps the readability of your code.

    -- Clocks
    
    CLOCK_50	: IN STD_LOGIC;  -- 50 MHz
 
    -- Buttons 
    
    KEY 		: IN STD_LOGIC_VECTOR (3 downto 0);         -- Push buttons

    -- Input switches
    
    SW 			: IN STD_LOGIC_VECTOR (17 downto 0);         -- DPDT switches

    -- VGA output
    
    VGA_BLANK_N : out std_logic;            -- BLANK
    VGA_CLK 	 : out std_logic;            -- Clock
    VGA_HS 		 : out std_logic;            -- H_SYNC
    VGA_SYNC_N  : out std_logic;            -- SYNC
    VGA_VS 		 : out std_logic;            -- V_SYNC
    VGA_R 		 : out unsigned(7 downto 0); -- Red[7:0]
    VGA_G 		 : out unsigned(7 downto 0); -- Green[7:0]
    VGA_B 		 : out unsigned(7 downto 0); -- Blue[7:0]

    -- PS2 Stuff
	PS2_CLK : inout std_logic;     -- Clock
	PS2_DAT : inout std_logic;    -- Data

	--LEDs
	LEDG : out std_logic_vector(8 downto 0);       -- Green LEDs (active high)
	LEDR : out std_logic_vector(17 downto 0)      -- Red LEDs (active high)


	);
END VGA_Test;


-- Architecture body 
-- 		Describes the functionality or internal implementation of the entity

ARCHITECTURE structural OF VGA_Test IS

COMPONENT VGA_SYNC_module

	PORT(	clock_50Mhz, red, green, blue		: IN	STD_LOGIC;
			red_out, green_out, blue_out, horiz_sync_out, 
			vert_sync_out, video_on, pixel_clock	: OUT	STD_LOGIC;
			pixel_row, pixel_column: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));

END COMPONENT;

component cursor
	port (
		cursor_x : out unsigned(10 downto 0);
		cursor_y : out unsigned(10 downto 0);
		clk				:	IN			STD_LOGIC;								--system clock input
		reset_n			:	IN			STD_LOGIC;								--active low asynchronous reset
		ps2_clk			:	INOUT		STD_LOGIC;								--clock signal from PS2 mouse
		ps2_data			:	INOUT		STD_LOGIC;
		left_click	: OUT STD_LOGIC;
		right_click	: OUT STD_LOGIC;
		middle_click : OUT STD_LOGIC;
		Left_sqrt : out STD_LOGIC_VECTOR (255 downto 0);
		Right_sqrt: out STD_LOGIC_VECTOR (255 downto 0)
	);
end component;

--component state_selector
	--PORT(pixel_row, pixel_column		: IN std_logic_vector(9 DOWNTO 0);
     --   Red,Green,Blue: OUT std_logic;
       -- Vert_sync, Switch	: IN std_logic;
	--	ScaleButton, XButton,Ybutton		: IN std_logic;
	--	Window_X, Window_Y, Window_Z : IN integer;
	--	Window_X_out, Window_Y_out, Window_Z_out : out integer
		--scroll_row : in integer
	--	);

--end component;

signal red_int : std_logic;
signal blue_int : std_logic;
signal green_int : std_logic;
SIGNAL video_on_int : STD_LOGIC; 
SIGNAL pixel_clock_int : STD_LOGIC;
SIGNAL pixel_row_int :STD_LOGIC_VECTOR(9 DOWNTO 0); 
SIGNAL pixel_column_int :STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL VGA_R_int : std_logic; 
SIGNAL VGA_G_int : std_logic; 
SIGNAL VGA_B_int : std_logic; 

--mouse stuff
signal cursor_x : unsigned(10 downto 0);
signal cursor_y : unsigned(10 downto 0);
signal size : unsigned(9 downto 0);

--signal clk				:	IN			STD_LOGIC;								--system clock input
--signal reset_n			:	IN			STD_LOGIC;								--active low asynchronous reset
--signal ps2_clk			:	INOUT		STD_LOGIC;								--clock signal from PS2 mouse
--signal ps2_data			:	INOUT		STD_LOGIC;
signal mouse_data_new : STD_LOGIC;
signal left_click	: STD_LOGIC;
signal right_click	: STD_LOGIC;
signal middle_click : STD_LOGIC;

signal Right_sqrt : STD_LOGIC_VECTOR (255 downto 0);

signal Left_sqrt : STD_LOGIC_VECTOR (255 downto 0);


--window stuff
SIGNAL vert_sync_int : STD_LOGIC;
SIGNAL horiz_sync_int : STD_LOGIC; 
Signal window_X_int : integer := -200;
Signal Window_Y_int : integer := -130;
Signal Window_Z_int : integer := 0;
Signal window_X_out_int : integer;
Signal Window_Y_out_int : integer;
Signal Window_Z_out_int : integer;
signal scroll_row_int : integer := 0;

--not needed rn
signal switch : STD_LOGIC;
signal ScaleButton : std_logic;
signal XButton : std_logic;
signal Ybutton : std_logic;

type drag_state_type is (drag, no_drag);
signal drag_state: drag_state_type := no_drag;

BEGIN

	VGA_R(6 DOWNTO 0) <= "0000000";
	VGA_G(6 DOWNTO 0) <= "0000000";
	VGA_B(6 DOWNTO 0) <= "0000000";
	VGA_R(7) <= VGA_R_int;
	VGA_B(7) <= VGA_B_int;
	VGA_G(7) <= VGA_G_int;
	VGA_VS <= vert_sync_int;
	VGA_HS <= horiz_sync_int;
	size <= to_unsigned(3, 10);

	--for testing
	LEDG(8) <= left_click;
	LEDR(17) <= right_click;
	LEDR(16) <= middle_click;

	U1: VGA_SYNC_module PORT MAP
		(clock_50Mhz		=>	CLOCK_50,
		 red					=>	red_int,
		 green				=>	green_int,	
		 blue					=>	blue_int,
		 red_out				=>	VGA_R_int,
		 green_out			=>	VGA_G_int,
		 blue_out			=>	VGA_B_int,
		 horiz_sync_out	=>	horiz_sync_int,
		 vert_sync_out		=>	vert_sync_int,
		 video_on			=>	VGA_BLANK_N,
		 pixel_clock		=>	VGA_CLK,
		 pixel_row			=>	pixel_row_int,
		 pixel_column		=>	pixel_column_int
		);

	mouse1: cursor port map (
		cursor_x => cursor_x,
		cursor_y => cursor_y,
		clk => CLOCK_50,
		reset_n => SW(17),
		ps2_clk => PS2_CLK,
		ps2_data => PS2_DAT,
		left_click => left_click,
		right_click => right_click,
		middle_click => middle_click,
		Right_sqrt => Right_sqrt,
		Left_sqrt => Left_sqrt
		);

	RGB_Display: Process (cursor_x, cursor_y, pixel_column_int, pixel_row_int, Size)
	BEGIN
	 IF (cursor_x <= unsigned(pixel_column_int) + Size) AND
	 	(cursor_x + Size >= '0' & unsigned(pixel_column_int)) AND
	 	(cursor_y <= unsigned(pixel_row_int) + Size) AND
	 	(cursor_y + Size >= '0' & unsigned(pixel_row_int)) THEN
	 		red_int <= '1';
	 		green_int <= '0';
	 		blue_int <= '0';
	Else
			red_int <= '0';
	 		green_int <= '0';
	 		blue_int <= '0';

	END IF;
	
	IF (Left_sqrt(1) = '1') then 
		LEDG(0) <= '1';
	
	elsif(Left_sqrt(1) = '0') then
		LEDR(0) <= '1';
	
	End IF;
	

	
	END process RGB_Display;

END structural;

