library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.minesweeper_pkg.all;

entity tile_tb is
end tile_tb;

architecture tile_tb1 of tile_tb is
	-- different signals associated with the tile
	signal clk, bomb_in, clicked : std_logic;
	signal neighbor_bombs, neighbor_revealed, neighbor_zero_status : std_logic_vector(7 downto 0);
	signal revealed, revealed_ans, zero_status, zero_status_ans : std_logic;
	signal tile_status, tile_status_ans : unsigned(3 downto 0);
	
	component tile
		port (
			clk, bomb_in, clicked : in std_logic;
			neighbor_bombs, neighbor_revealed, neighbor_zero_status : in std_logic_vector(7 downto 0);
			revealed, zero_status : out std_logic;
			tile_status : out unsigned(3 downto 0)
		);
	end component;

begin
	my_tile : tile port map (
		clk => clk,
		bomb_in => bomb_in,
		clicked => clicked,
		neighbor_bombs => neighbor_bombs,
		neighbor_revealed => neighbor_revealed,
		neighbor_zero_status => neighbor_zero_status,
		revealed => revealed,
		zero_status => zero_status,
		tile_status => tile_status
	);
	
	process
	begin
		bomb_in <= '0';
		clicked <= '0';
		neighbor_bombs <= "10011001";
		neighbor_revealed <= "00000000";
		neighbor_zero_status <= "00000100";
		
		revealed_ans <= '0';
		zero_status_ans <= '0';
		tile_status_ans <= "0100";
		
		-- two clock cycles of nothing, hold state
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		clk <= '0';
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		
		-- check if clicking reveals the tile and unclicking (which shouldn't exist in code) unreveals the tile
		clk <= '0';
		clicked <= '1';
		wait for 10 ns;
		clk <= '1';
		revealed_ans <= '1';
		wait for 10 ns;
		clk <= '0';
		clicked <= '0';
		wait for 10 ns;
		clk <= '1';
		revealed_ans <= '0';
		wait for 10 ns;
		
		clk <= '0';
		neighbor_bombs <= "00000000";
		wait for 10 ns;
		clk <= '1';
		tile_status_ans <= "0000";
		zero_status_ans <= '1';
		wait for 10 ns;
		clk <= '0';
		neighbor_bombs <= "10011001";
		wait for 10 ns;
		clk <= '1';
		tile_status_ans <= "0100";
		zero_status_ans <= '0';
		wait for 10 ns;
		
		clk <= '0';
		neighbor_revealed <= "01100000";
		wait for 10 ns;
		clk <= '1';
		wait for 10 ns;
		
		clk <= '0';
		neighbor_revealed <= "01100100";
		wait for 10 ns;
		clk <= '1';
		revealed_ans <= '1';
		wait for 10 ns;
		
		clk <= '0';
		bomb_in <= '1';
		wait for 10 ns;
		clk <= '1';
		tile_status_ans <= "1001";
		wait for 10 ns;
		
		wait;
	end process;
	
	process
	begin
		wait until rising_edge(clk);
		wait for 1 ns;
		
		assert(revealed_ans /= '0' or revealed = '0') report "revealed should be 0" severity error;
		assert(revealed_ans /= '1' or revealed = '1') report "revealed should be 1" severity error;
		assert(tile_status_ans /= "0000" or tile_status = "0000") report "tile_status should be 0" severity error;
		assert(tile_status_ans /= "0001" or tile_status = "0001") report "tile_status should be 1" severity error;
		assert(tile_status_ans /= "0010" or tile_status = "0010") report "tile_status should be 2" severity error;
		assert(tile_status_ans /= "0011" or tile_status = "0011") report "tile_status should be 3" severity error;
		assert(tile_status_ans /= "0100" or tile_status = "0100") report "tile_status should be 4" severity error;
		assert(tile_status_ans /= "0101" or tile_status = "0101") report "tile_status should be 5" severity error;
		assert(tile_status_ans /= "0110" or tile_status = "0110") report "tile_status should be 6" severity error;
		assert(tile_status_ans /= "0111" or tile_status = "0111") report "tile_status should be 7" severity error;
		assert(tile_status_ans /= "1000" or tile_status = "1000") report "tile_status should be 8" severity error;
		assert(tile_status_ans /= "1001" or tile_status = "1001") report "tile_status should be 9" severity error;
	end process;
end tile_tb1;