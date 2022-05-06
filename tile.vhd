library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.minesweeper_pkg.all;

entity tile is
	port (
		-- inputs to the tile
		clk, reset, bomb_in, left_clicked, right_clicked : in std_logic;
		
		-- graph connections between other tile nodes
		neighbor_bombs, neighbor_revealed, neighbor_zero_status : in std_logic_vector(7 downto 0);
		
		-- outputs of the tile
		revealed, zero_status, flag : out std_logic;
		tile_status : out unsigned(3 downto 0)
	);
end entity;

architecture behavioral of tile is
begin
	process (clk, reset)
		variable status : unsigned(3 downto 0) := "0000";
		variable is_revealed : std_logic := '0';
		variable is_flagged : std_logic := '0';
		variable flag_clock : std_logic := '0';
	begin
		if (reset = '1') then
			is_revealed := '0';
			is_flagged := '0';
			flag_clock := '0';
			revealed <= '0';
			zero_status <= '1';
			tile_status <= "0000";
		elsif (rising_edge(clk)) then
			-- detemine the display value ot be put onto the screen
			if (bomb_in = '1') then status := "1001";
			else
				status := "0000";
				for i in neighbor_bombs'range loop
					if neighbor_bombs(i) = '1' then status := status + "1";
					end if;
				end loop;
			end if;
			tile_status <= status;
			
			if (status = "0000") then zero_status <= '1';
			else zero_status <= '0';
			end if;
			
			if ((left_clicked = '1' and is_flagged = '0') or (neighbor_revealed(7) = '1' and neighbor_zero_status(7) = '1') or (neighbor_revealed(6) = '1' and neighbor_zero_status(6) = '1') or 
				(neighbor_revealed(5) = '1' and neighbor_zero_status(5) = '1') or (neighbor_revealed(4) = '1' and neighbor_zero_status(4) = '1') or
				(neighbor_revealed(3) = '1' and neighbor_zero_status(3) = '1') or (neighbor_revealed(2) = '1' and neighbor_zero_status(2) = '1') or
				(neighbor_revealed(1) = '1' and neighbor_zero_status(1) = '1') or (neighbor_revealed(0) = '1' and neighbor_zero_status(0) = '1')) then is_revealed := '1';
			end if;
			
			if (is_revealed = '1') then
				is_flagged := '0';
			elsif (right_clicked = '1' and flag_clock = '1') then
				is_flagged := is_flagged xor '1';
			end if;
			
			if (right_clicked = '1' and flag_clock = '1') then 
				flag_clock := '0';
			elsif (right_clicked = '0' and flag_clock = '0') then
				flag_clock := '1';
			end if;

			revealed <= is_revealed;
			flag <= is_flagged;
		end if;
	end process;
end behavioral;