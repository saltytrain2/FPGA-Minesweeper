LIBRARY ieee;
USE ieee.std_logic_1164.all;

--mouse_logic will use ports from ps2_mouse.vhd as well as custom outputs for testing
entity mouse_logic is
	port (
		clk				:	IN			STD_LOGIC;								--system clock input
		reset_n			:	IN			STD_LOGIC;								--active low asynchronous reset
		ps2_clk			:	INOUT		STD_LOGIC;								--clock signal from PS2 mouse
		ps2_data			:	INOUT		STD_LOGIC;
		mouse_data_new : OUT STD_LOGIC;
		left_click	: OUT STD_LOGIC;
		right_click	: OUT STD_LOGIC;
		middle_click : OUT STD_LOGIC;
		x_move : out STD_LOGIC_VECTOR (8 downto 0);
		y_move : out STD_LOGIC_VECTOR (8 downto 0)
		);	
end mouse_logic;

architecture mouse_logic_arc of mouse_logic is

	--include other signal for internal manipulation
	signal mouse_data : STD_LOGIC_VECTOR (23 downto 0);

	--import ps2_mouse component
	component ps2_mouse
		GENERIC(
			clk_freq	:	INTEGER := 50_000_000;	--system clock frequency in Hz
			ps2_debounce_counter_size	:	INTEGER := 8);				--set such that 2^size/clk_freq = 5us (size = 8 for 50MHz)
		
		PORT(
			clk				:	IN			STD_LOGIC;								--system clock input
			reset_n			:	IN			STD_LOGIC;								--active low asynchronous reset
			ps2_clk			:	INOUT		STD_LOGIC;								--clock signal from PS2 mouse
			ps2_data			:	INOUT		STD_LOGIC;								--data signal from PS2 mouse
			mouse_data		:	OUT		STD_LOGIC_VECTOR (23 DOWNTO 0);	--data received from mouse
			mouse_data_new	:	OUT		STD_LOGIC);		
	end component;

begin

--map ps2 mouse component
mouse1: ps2_mouse port map (
		clk => clk,
		reset_n => reset_n,		
		ps2_clk => ps2_clk,
		ps2_data => ps2_data,
		mouse_data => mouse_data,
		mouse_data_new => mouse_data_new
	);

--map mouse data to mouse_logic outputs. will be used by drawer/tester
left_click <= mouse_data(16);
right_click <= mouse_data(17);
middle_click <= mouse_data(18);
x_move(7 downto 0) <= mouse_data(15 downto 8);
x_move(8) <= mouse_data(20);
y_move(7 downto 0) <= mouse_data(7 downto 0);
y_move(8) <= mouse_data(21);





end mouse_logic_arc;