library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.minesweeper_pkg.all;

entity game_state_tb is
end game_state_tb;

architecture game_state_tb1 of game_state_tb is
	constant start_pos : unsigned(39 downto 0) := x"FFFFFFFFFF";
	constant act_game_pos : unsigned(255 downto 0) := x"801200A02000200500A00801009210200021180041004085008A04A00900C006";
	constant act_game_status : tile_status_array := (x"9", x"1", x"0", x"0", x"0", x"0", x"0", x"1", x"1", x"2", x"2", x"9", x"1", x"1", x"9", x"1",
	                                                 x"1", x"2", x"1", x"1", x"0", x"0", x"0", x"1", x"9", x"2", x"9", x"2", x"1", x"1", x"1", x"1",
																	 x"0", x"2", x"9", x"2", x"0", x"0", x"0", x"1", x"1", x"2", x"1", x"1", x"1", x"1", x"2", x"1",
																	 x"0", x"2", x"9", x"2", x"0", x"0", x"0", x"1", x"1", x"2", x"1", x"1", x"1", x"9", x"2", x"9",
																	 x"0", x"1", x"1", x"2", x"1", x"1", x"0", x"1", x"9", x"2", x"9", x"1", x"1", x"1", x"3", x"2",
																	 x"0", x"0", x"0", x"1", x"9", x"1", x"0", x"2", x"2", x"3", x"2", x"2", x"1", x"1", x"2", x"9",
																	 x"0", x"0", x"1", x"2", x"2", x"1", x"0", x"1", x"9", x"2", x"2", x"9", x"1", x"1", x"9", x"2",
																	 x"0", x"0", x"1", x"9", x"1", x"0", x"0", x"1", x"1", x"3", x"9", x"3", x"1", x"1", x"2", x"2",
																	 x"0", x"0", x"2", x"3", x"3", x"1", x"0", x"0", x"0", x"2", x"9", x"2", x"0", x"0", x"1", x"9",
																	 x"1", x"1", x"2", x"9", x"9", x"1", x"1", x"1", x"1", x"1", x"1", x"1", x"0", x"0", x"1", x"1",
	                                                 x"2", x"9", x"3", x"2", x"2", x"1", x"1", x"9", x"2", x"1", x"0", x"0", x"1", x"1", x"2", x"1",
																	 x"2", x"9", x"2", x"0", x"0", x"0", x"1", x"3", x"9", x"2", x"0", x"1", x"2", x"9", x"3", x"9",
																	 x"1", x"1", x"1", x"0", x"1", x"1", x"1", x"3", x"9", x"4", x"1", x"2", x"9", x"3", x"9", x"2",
																	 x"0", x"0", x"0", x"1", x"2", x"9", x"2", x"3", x"9", x"3", x"9", x"2", x"1", x"2", x"1", x"1",
																	 x"2", x"2", x"1", x"1", x"9", x"2", x"2", x"9", x"2", x"2", x"1", x"1", x"1", x"2", x"2", x"1",
																	 x"9", x"9", x"1", x"1", x"1", x"1", x"1", x"1", x"1", x"0", x"0", x"0", x"1", x"9", x"9", x"1");

	-- different signals associated with the tile
	signal clk : std_logic;
	signal reset : std_logic;
	signal bomb_in, left_clicked, right_clicked : std_logic_vector(255 downto 0);
	signal game_status, game_status_ans : tile_status_array;
	signal game_revealed, game_revealed_ans : std_logic_vector(255 downto 0);
	signal game_flagged, game_flagged_ans : std_logic_vector(255 downto 0);
	signal game_over, game_over_ans : std_logic;
	
	component game_state
		port (
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
	end component;

begin
	my_game_state : game_state port map (
		clk => clk,
		reset => reset,
		bomb_in => bomb_in,
		left_clicked => left_clicked,
		right_clicked => right_clicked,
		game_status => game_status,
		game_revealed => game_revealed,
		game_flagged => game_flagged,
		game_over => game_over
	);
	
	process
	begin
		reset <= '0';
		bomb_in <= std_logic_vector(resize(start_pos, 256));
		left_clicked <= std_logic_vector(to_unsigned(0, 256));
		right_clicked <= std_logic_vector(to_unsigned(0, 256));
		game_over_ans <= '0';
		
		game_status_ans <= (others=>(others=>'0'));
		game_revealed_ans <= std_logic_vector(to_unsigned(0, 256));
		game_flagged_ans <= std_logic_vector(to_unsigned(0, 256));
		-- two clock cycles of nothing, hold state
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		game_status_ans(48) <= "0010";
		game_status_ans(52) <= "0011";
		game_status_ans(47) <= "0010";
		game_status_ans(240) <= "0000";
		game_status_ans(176) <= "0000";
		game_status_ans(3) <= "1001";
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 5 ns;
		assert(game_over_ans = game_over) report "game_over should be 0" severity error;
		assert(game_status_ans(48) = game_status(48)) report "tile 48 should be next to 2 bombs" severity error;
		assert(game_status_ans(52) = game_status(52)) report "tile 52 should be next to 3 bombs" severity error;
		assert(game_status_ans(63) = game_status(63)) report "tile 63 should be next to 2 bombs" severity error;
		assert(game_status_ans(240) = game_status(240)) report "tile 240 should be next to 0 bombs" severity error;
		assert(game_status_ans(176) = game_status(176)) report "tile 176 should be next to 0 bombs" severity error;
		assert(game_status_ans(3) = game_status(3)) report "tile 3 should be a bomb" severity error;
		assert(game_revealed_ans = game_revealed) report "no tiles should be revealed" severity error;
		wait for 5 ns;
		
		-- takes around 16 clock edges for the entire signal to propagate through all tiles
		clk <= '0';
		left_clicked(78) <= '1';
		wait for 10 ns;
		clk <= '1';
		game_revealed_ans(255) <= '1';
		game_revealed_ans(78) <= '1';
		game_revealed_ans(67) <= '1';
		game_revealed_ans(41) <= '1';
		game_revealed_ans(39) <= '0';
		game_revealed_ans(20) <= '0';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 5 ns;
		assert(game_revealed_ans(255) = game_revealed(255)) report "tile 255 should have been revealed" severity error;
		assert(game_revealed_ans(78) = game_revealed(78)) report "tile 78 should have been revealed" severity error;
		assert(game_revealed_ans(67) = game_revealed(67)) report "tile 67 should have been revealed" severity error;
		assert(game_revealed_ans(41) = game_revealed(41)) report "tile 41 should have been revealed" severity error;
		assert(game_revealed_ans(39) = game_revealed(39)) report "tile 39 should not have been revealed" severity error;
		assert(game_revealed_ans(20) = game_revealed(20)) report "tile 20 should not have been revealed" severity error;
		wait for 5 ns;
		
		
		-- actual game simulation
		reset <= '1';
		wait for 10 ns;
		reset <= '0';
		wait for 10 ns;
		bomb_in <= std_logic_vector(act_game_pos);
		left_clicked <= std_logic_vector(to_unsigned(0, 256));
		game_over_ans <= '0';
		game_revealed_ans <= std_logic_vector(to_unsigned(0, 256));
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		game_status_ans <= act_game_status;
		wait for 5 ns;
		for i in game_status'range loop
			assert(game_status_ans(i) = game_status(i)) report "tile " & integer'image(i) & " status is incorrect" severity error;
		end loop;
		wait for 5 ns;
		
		clk <= '0';
		right_clicked(41) <= '1';
		right_clicked(136) <= '1';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		game_flagged_ans(41) <= '1';
		game_flagged_ans(136) <= '1';
		wait for 5 ns;
		for i in game_flagged'range loop
			assert(game_flagged_ans(i) /= '0' or game_flagged(i) = '0') report "tile " & integer'image(i) & " should not be flagged" severity error;
			assert(game_flagged_ans(i) /= '1' or game_flagged(i) = '1') report "tile " & integer'image(i) & " should be flagged" severity error;
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		wait for 5 ns;
		
		clk <= '0';
		right_clicked(41) <= '0';
		right_clicked(136) <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 5 ns;
		for i in game_flagged'range loop
			assert(game_flagged_ans(i) /= '0' or game_flagged(i) = '0') report "tile " & integer'image(i) & " should not be flagged" severity error;
			assert(game_flagged_ans(i) /= '1' or game_flagged(i) = '1') report "tile " & integer'image(i) & " should be flagged" severity error;
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		wait for 5 ns;
		
		clk <= '0';
		left_clicked(136) <= '1';
		right_clicked(41) <= '1';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		game_flagged_ans(41) <= '0';
		wait for 5 ns;
		for i in game_flagged'range loop
			assert(game_flagged_ans(i) /= '0' or game_flagged(i) = '0') report "tile " & integer'image(i) & " should not be flagged" severity error;
			assert(game_flagged_ans(i) /= '1' or game_flagged(i) = '1') report "tile " & integer'image(i) & " should be flagged" severity error;
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		wait for 5 ns;
		
		left_clicked(120) <= '1';
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		game_revealed_ans(120) <= '1';
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		wait for 5 ns;
		
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		game_revealed_ans(119) <= '1';
		game_revealed_ans(121) <= '1';
		game_revealed_ans(135) <= '1';
		game_revealed_ans(136) <= '1';
		game_revealed_ans(137) <= '1';
		game_revealed_ans(105) <= '1';
		game_revealed_ans(104) <= '1';
		game_revealed_ans(103) <= '1';
		game_flagged_ans(136) <= '0';
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
			assert(game_flagged_ans(i) /= '0' or game_flagged(i) = '0') report "tile " & integer'image(i) & " should not be flagged" severity error;
			assert(game_flagged_ans(i) /= '1' or game_flagged(i) = '1') report "tile " & integer'image(i) & " should be flagged" severity error;
		end loop;
		wait for 5 ns;
		
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		game_revealed_ans(118) <= '1';
		game_revealed_ans(134) <= '1';
		game_revealed_ans(102) <= '1';
		game_revealed_ans(122) <= '1';
		game_revealed_ans(138) <= '1';
		game_revealed_ans(106) <= '1';
		game_revealed_ans(152) <= '1';
		game_revealed_ans(153) <= '1';
		game_revealed_ans(154) <= '1';
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		wait for 5 ns;
		
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		game_revealed_ans(139) <= '1';
		game_revealed_ans(155) <= '1';
		game_revealed_ans(123) <= '1';
		game_revealed_ans(168) <= '1';
		game_revealed_ans(169) <= '1';
		game_revealed_ans(170) <= '1';
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		wait for 5 ns;
		
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		game_revealed_ans(184) <= '1';
		game_revealed_ans(185) <= '1';
		game_revealed_ans(186) <= '1';
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		wait for 5 ns;
		
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		game_revealed_ans(200) <= '1';
		game_revealed_ans(201) <= '1';
		game_revealed_ans(202) <= '1';
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		wait for 5 ns;
		
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		game_revealed_ans(216) <= '1';
		game_revealed_ans(217) <= '1';
		game_revealed_ans(218) <= '1';
		game_revealed_ans(203) <= '1';
		game_revealed_ans(187) <= '1';
		game_revealed_ans(219) <= '1';
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		wait for 5 ns;
		
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		game_revealed_ans(232) <= '1';
		game_revealed_ans(233) <= '1';
		game_revealed_ans(234) <= '1';
		game_revealed_ans(235) <= '1';
		game_revealed_ans(236) <= '1';
		game_revealed_ans(220) <= '1';
		game_revealed_ans(204) <= '1';
		game_revealed_ans(188) <= '1';
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		wait for 5 ns;
		
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		game_revealed_ans(248) <= '1';
		game_revealed_ans(249) <= '1';
		game_revealed_ans(250) <= '1';
		game_revealed_ans(251) <= '1';
		game_revealed_ans(252) <= '1';
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		wait for 5 ns;
		
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		game_revealed_ans(253) <= '1';
		game_revealed_ans(237) <= '1';
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		wait for 5 ns;
		
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		game_revealed_ans(254) <= '1';
		game_revealed_ans(238) <= '1';
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		wait for 5 ns;
		
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		wait for 5 ns;
		
		clk <= '0';
		left_clicked(5) <= '1';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		game_revealed_ans(5) <= '1';
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		wait for 5 ns;
		
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		game_revealed_ans(4) <= '1';
		game_revealed_ans(6) <= '1';
		game_revealed_ans(20) <= '1';
		game_revealed_ans(21) <= '1';
		game_revealed_ans(22) <= '1';
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		assert(game_over_ans /= '0' or game_over = '0') report "game should not be over" severity error;
		assert(game_over_ans /= '1' or game_over = '1') report "game should be over" severity error;
		wait for 5 ns;
		
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		game_revealed_ans(3) <= '1';
		game_revealed_ans(7) <= '1';
		game_revealed_ans(19) <= '1';
		game_revealed_ans(23) <= '1';
		wait for 5 ns;
		
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		wait for 5 ns;
		
		clk <= '0';
		left_clicked(193) <= '1';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		game_revealed_ans(193) <= '1';
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		assert(game_over_ans /= '0' or game_over = '0') report "game should not be over" severity error;
		assert(game_over_ans /= '1' or game_over = '1') report "game should be over" severity error;
		wait for 5 ns;
		
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		wait for 5 ns;
		
		clk <= '0';
		left_clicked <= std_logic_vector(to_unsigned(0, 256));
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		wait for 5 ns;
		
		clk <= '0';
		left_clicked(193) <= '1';
		wait for 10 ns;
		clk <= '1';
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		wait for 5 ns;
		
		clk <= '0';
		
		clk <= '0';
		left_clicked(192) <= '1';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		game_revealed_ans(192) <= '1';
		game_over_ans <= '1';
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		assert(game_over_ans /= '0' or game_over = '0') report "game should not be over" severity error;
		assert(game_over_ans /= '1' or game_over = '1') report "game should be over" severity error;
		wait for 5 ns;
		
		clk <= '0';
		left_clicked(52) <= '1';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 5 ns;
		for i in game_revealed'range loop
			assert(game_revealed_ans(i) /= '0' or game_revealed(i) = '0') report "tile " & integer'image(i) & " should not be revealed" severity error;
			assert(game_revealed_ans(i) /= '1' or game_revealed(i) = '1') report "tile " & integer'image(i) & " should be revealed" severity error;
		end loop;
		wait for 5 ns;
		
		wait;
	end process;
end game_state_tb1;