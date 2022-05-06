library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.minesweeper_pkg.all;

entity bomb_generator is 
	port (
		clk, reset, enable: in std_logic;
		permutation : out std_logic_vector(255 downto 0)
	);
end entity;

architecture behavioral of bomb_generator is
begin
	process (clk, reset, enable)
		variable random_number : std_logic_vector(255 downto 0) := (others=>'0');
		variable seed : std_logic_vector(7 downto 0) := "00000001";
		variable index : std_logic_vector(7 downto 0) := "00000010";
	begin
		if (reset = '0') then 
			random_number := (others=>'0');
			seed := "00000001";
			index := "00000010";
			permutation <= random_number;
		elsif (rising_edge(clk) and enable = '1') then
			random_number := (others => '0');
			seed := seed(0) & (seed(5) xor seed(0)) & seed(6 downto 1);
			index := seed;
			for i in 0 to 39 loop
				index := index(0) & (index(7) xor index(0)) & index(6 downto 1);
				random_number(to_integer(unsigned(index))) := '1';
			end loop;
			permutation <= random_number;
		end if;
	end process;
end behavioral;