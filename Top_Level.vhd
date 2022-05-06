-------------------------------------------------------------------------------
--
-- Project					: VGA_Ball
-- File name				: VGA_Ball.vhd
-- Title						: VGA Moving Ball 
-- Description				:  
--								: 
-- Design library			: N/A
-- Analysis Dependency	: VGA_SYNC.vhd
-- Simulator(s)			: ModelSim-Altera version 6.1g
-- Initialization			: none
-- Notes						: This model is designed for synthesis
--								: Compile with VHDL'93
--
-------------------------------------------------------------------------------
--
-- Revisions
--			Date		Author			Revision		Comments
--		3/11/2008		W.H.Robinson	Rev A			Creation
--		3/13/2012		W.H.Robinson	Rev B			Update for DE2-115 Board
--
--			
-------------------------------------------------------------------------------

-- Always specify the IEEE library in your design


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.all;
USE ieee.std_logic_unsigned.ALL;
USE work.minesweeper_pkg.ALL;

-- Entity declaration
-- 		Defines the interface to the entity

ENTITY Top_Level IS


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
    VGA_R 		 : out unsigned(7 downto 0); -- Red[9:0]
    VGA_G 		 : out unsigned(7 downto 0); -- Green[9:0]
    VGA_B 		 : out unsigned(7 downto 0); -- Blue[9:0]
	 
	PS2_CLK : inout std_logic;     -- Clock
	PS2_DAT : inout std_logic    -- Data

	);
END Top_Level;


-- Architecture body 
-- 		Describes the functionality or internal implementation of the entity

ARCHITECTURE structural OF Top_Level IS

COMPONENT VGA_SYNC_module

	PORT(	clock_50Mhz, red, green, blue		: IN	STD_LOGIC;
			red_out, green_out, blue_out, horiz_sync_out, 
			vert_sync_out, video_on, pixel_clock	: OUT	STD_LOGIC;
			pixel_row, pixel_column: OUT STD_LOGIC_VECTOR(9 DOWNTO 0));

END COMPONENT;


COMPONENT artdesign
	PORT(pixel_row, pixel_col		: IN std_logic_vector(9 DOWNTO 0);
        Red,Green,Blue 				: OUT std_logic;
		  flagged_array				: IN STD_LOGIC_VECTOR(255 downto 0);
		  revealed_array				: IN STD_LOGIC_VECTOR(255 downto 0);
		  cursor_x, cursor_y			: IN unsigned(10 DOWNTO 0);
		  game_status 					: in tile_status_array;
		  Vert_sync	: IN std_logic);
		  
END COMPONENT;

COMPONENT game_state
	PORT (
		clk : in std_logic;
		reset : in std_logic;
		bomb_in : in std_logic_vector(255 downto 0);
		left_clicked : in std_logic_vector(255 downto 0);
		right_clicked : in std_logic_vector(255 downto 0);
		game_status : out tile_status_array;
		game_revealed : out std_logic_vector(255 downto 0);
		game_flagged : out std_logic_vector(255 downto 0);
		game_over : out std_logic
		
	);
END COMPONENT;

COMPONENT bomb_generator
	PORT (
		clk, reset, enable: in std_logic;
		permutation : out std_logic_vector(255 downto 0)
	);
END COMPONENT;

COMPONENT cursor
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
END COMPONENT;

SIGNAL red_int : STD_LOGIC;
SIGNAL green_int : STD_LOGIC;
SIGNAL blue_int : STD_LOGIC;
SIGNAL video_on_int : STD_LOGIC;
SIGNAL vert_sync_int : STD_LOGIC;
SIGNAL horiz_sync_int : STD_LOGIC; 
SIGNAL pixel_clock_int : STD_LOGIC;
SIGNAL pixel_row_int :STD_LOGIC_VECTOR(9 DOWNTO 0); 
SIGNAL pixel_column_int :STD_LOGIC_VECTOR(9 DOWNTO 0); 
SIGNAL flagged_array_int : STD_LOGIC_VECTOR(255 DOWNTO 0);
SIGNAL revealed_array_int : STD_LOGIC_VECTOR(255 DOWNTO 0);
SIGNAL game_status_int : tile_status_array;
SIGNAL game_over_int : std_logic;
SIGNAL bomb_in_int, left_clicked_int, right_clicked_int : STD_LOGIC_VECTOR(255 DOWNTO 0);
SIGNAL cursor_x_int, cursor_y_int : unsigned(10 DOWNTO 0);
SIGNAL left_click_int, middle_click_int, right_click_int : STD_LOGIC;


BEGIN

	VGA_R(6 DOWNTO 0) <= "0000000";
	VGA_G(6 DOWNTO 0) <= "0000000";
	VGA_B(6 DOWNTO 0) <= "0000000";

	VGA_HS <= horiz_sync_int;
	VGA_VS <= vert_sync_int;


	U1: VGA_SYNC_module PORT MAP
		(clock_50Mhz		=>	CLOCK_50,
		 red					=>	red_int,
		 green				=>	green_int,	
		 blue					=>	blue_int,
		 red_out				=>	VGA_R(7),
		 green_out			=>	VGA_G(7),
		 blue_out			=>	VGA_B(7),
		 horiz_sync_out	=>	horiz_sync_int,
		 vert_sync_out		=>	vert_sync_int,
		 video_on			=>	VGA_BLANK_N,
		 pixel_clock		=>	VGA_CLK,
		 pixel_row			=>	pixel_row_int,
		 pixel_column		=>	pixel_column_int
		);
		
	U2: artdesign PORT MAP
		(pixel_row		=> pixel_row_int,
		 pixel_col		=> pixel_column_int,
		 Red				=> red_int,
		 Green			=> green_int,
		 Blue				=> blue_int,
		 flagged_array => flagged_array_int,
		 revealed_array => revealed_array_int,
		 cursor_x		=> cursor_x_int,
		 cursor_y		=> cursor_y_int,
		 game_status  => game_status_int,
		 vert_sync		=> vert_sync_int
		);
		 

	U3: game_state PORT MAP
		( clk				  => CLOCK_50,
			reset 				=> SW(1),
			bomb_in 				=> bomb_in_int,
			left_clicked 		=> left_clicked_int,
			right_clicked 		=> right_clicked_int,
			game_status 		=> game_status_int,
			game_revealed 		=> revealed_array_int,
			game_flagged 		=> flagged_array_int,
			game_over 			=> game_over_int
		);
		
	U4: bomb_generator PORT MAP
		( clk 			=> CLOCK_50,
			reset			=> SW(1),
			enable		=> SW(0),
			permutation => bomb_in_int
		);
		
	U5: cursor PORT MAP
		(
		cursor_x 		=> cursor_x_int,
		cursor_y 		=> cursor_y_int,
		clk				=> CLOCK_50,						--system clock input
		reset_n			=> SW(17),							--active low asynchronous reset
		ps2_clk			=>			PS2_CLK,								--clock signal from PS2 mouse
		ps2_data			=>	PS2_DAT,
		left_click		=> left_click_int,
		right_click		=> right_click_int,
		middle_click	=> middle_click_int,
		Left_sqrt 		=> left_clicked_int,
		Right_sqrt		=> right_clicked_int
	);

END structural;

