library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.minesweeper_pkg.all;

entity bomb_generator_tb is
end bomb_generator_tb;

architecture bomb_generator_tb1 of bomb_generator_tb is
	-- different signals associated with the tile
	signal clk, reset, enable : std_logic;
	signal permutation : std_logic_vector(255 downto 0);
	
	component bomb_generator
		port (
			clk, reset, enable : in std_logic;
			permutation : out std_logic_vector(255 downto 0)
		);
	end component;

begin
	my_random_generator : bomb_generator port map (
		clk => clk,
		reset => reset,
		enable => enable,
		permutation => permutation
	);
	
	process
	begin
		reset <= '0';
		enable <= '1';
		
		wait for 10 ns;
		reset <= '1';
		
		-- cycle through clock cycles, make sure all permutations contain 40 high bits
		for i in 0 to 1000 loop
			clk <= '0';
			wait for 10 ns;
			clk <= '1';
			wait for 10 ns;
		end loop;
		
		wait;
	end process;
	
	process
		variable num_highs : unsigned(5 downto 0) := "000000";
	begin
		wait until rising_edge(clk);
		wait for 1 ns;
		
		num_highs := "000000";
		for i in permutation'range loop
			if (permutation(i) = '1') then num_highs := num_highs + 1;
			end if;
		end loop;
		
		assert(num_highs = "101000") report "not exactly 40 high bits detected in permutation, detected " & integer'image(to_integer(num_highs)) & " high bits instead"  severity error;
	end process;
end bomb_generator_tb1;