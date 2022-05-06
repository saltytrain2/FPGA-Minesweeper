LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
--USE  IEEE.STD_LOGIC_ARITH.all;
--USE  IEEE.STD_LOGIC_UNSIGNED.all;
use ieee.numeric_std.all;

entity cursor is
	port (
		cursor_x : out std_logic_vector(10 downto 0);
		cursor_y : out std_logic_vector(10 downto 0);
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
end cursor;

architecture cursor_arc of cursor is

	component mouse_logic
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
	end component;

	signal x_move : std_logic_vector(8 downto 0);
	signal y_move : std_logic_vector(8 downto 0);
	signal cursor_x_int : unsigned(10 downto 0);
	signal cursor_y_int : unsigned(10 downto 0);
	signal mouse_data_new : std_logic;
	signal l_click: std_logic;
	signal r_click: std_logic;

begin

	mouse1: mouse_logic port map (
		clk => clk,
		reset_n => reset_n,
		ps2_clk => ps2_clk,
		ps2_data => ps2_data,
		mouse_data_new => mouse_data_new,
		left_click => l_click,
		right_click => r_click,
		middle_click => middle_click,
		x_move => x_move,
		y_move => y_move
		);

	left_click <= l_click;
	right_click <= r_click;
	cursor_x <= std_logic_vector(cursor_x_int);
	cursor_y <= std_logic_vector(cursor_y_int);

	process (mouse_data_new,cursor_x_int,cursor_y_int,l_click,r_click)
	begin
		if (rising_edge(mouse_data_new) and mouse_data_new = '1') then
			if (x_move(8) = '0' and unsigned(x_move(7 downto 0)) > to_unsigned(0, 10)) then
				if (cursor_x_int < to_unsigned(640, 10)) then
					--cursor_x_int <= cursor_x_int + (unsigned(x_move) / to_unsigned(32, 10));
					cursor_x_int <= cursor_x_int + to_unsigned(1, 10);
				end if;
			elsif (x_move(8) = '1' and unsigned(x_move(7 downto 0)) > to_unsigned(0, 10)) then
				if (unsigned(cursor_x_int)> to_unsigned(0, 10)) then
					--cursor_x_int <= cursor_x_int - (unsigned(x_move) / to_unsigned(32, 10));
					cursor_x_int <= cursor_x_int - to_unsigned(1, 10);
				end if;
			end if;

			if (y_move(8) = '1' and unsigned(y_move(7 downto 0)) > to_unsigned(0, 10)) then
				if (unsigned(cursor_y_int) < to_unsigned(480, 10)) then
					--cursor_y_int <= cursor_y_int + (unsigned(y_move) / to_unsigned(32, 10));
					cursor_y_int <= cursor_y_int + to_unsigned(1, 10);
				end if;
			elsif (y_move(8) = '0' and unsigned(y_move(7 downto 0)) > to_unsigned(0, 10)) then
				if (unsigned(cursor_y_int) > to_unsigned(0, 10)) then
					--cursor_y_int <= cursor_y_int - (unsigned(y_move) / to_unsigned(32, 10));
					cursor_y_int <= cursor_y_int - to_unsigned(1, 10);
				end if;
			end if;
		end if;
		
		
		For i in 0 to 15 loop
		 for j in 15 downto 0 loop 
				if (((cursor_x_int < 80 + 30 * (i + 1))  And (cursor_x_int > 80 + 30 * i)) 
					And ((cursor_y_int < (j + 1) * 30) And (cursor_y_int > j * 30)) and l_click = '1') then
					
					left_sqrt (i + (j * 16)) <= '1';
					
				else	
				
					left_sqrt (i + (j * 16)) <= '0';
					
				end if;
			end loop;
	end loop;			
	
	
		For i in 0 to 15 loop
		 for j in 15 downto 0 loop
			 
				if (((cursor_x_int < 80 + 30 * (i + 1))  And (cursor_x_int > 80 + 30 * i)) 
					And ((cursor_y_int < (j + 1) * 30) And (cursor_y_int > j * 30)) and r_click = '1') then
					
					right_sqrt (i + (j * 16)) <= '1';
					
				else	
				
					right_sqrt (i + (j * 16)) <= '0';
					
				end if; 
			end loop;
	end loop;
		
end process;	
			
 
end cursor_arc;