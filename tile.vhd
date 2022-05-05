library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.minesweeper_pkg.all;

entity tile is
	port (
		-- inputs to the tile
		clk, reset, bomb_in, clicked : in std_logic;
		
		-- graph connections between other tile nodes
		neighbor_bombs, neighbor_revealed, neighbor_zero_status : in std_logic_vector(7 downto 0);
		
		-- outputs of the tile
		revealed, zero_status : out std_logic;
		tile_status : out unsigned(3 downto 0)
	);
end entity;

architecture behavioral of tile is
begin
	process (clk, reset)
		variable status : unsigned(3 downto 0) := "0000";
	begin
		if (reset = '1') then
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
			
			-- the current tile should reveal itself when it is clicked, or if any of its neighbors have neighbors with no bombs and are revealed
			if (clicked = '1' or (neighbor_revealed(7) = '1' and neighbor_zero_status(7) = '1') or (neighbor_revealed(6) = '1' and neighbor_zero_status(6) = '1') or 
				(neighbor_revealed(5) = '1' and neighbor_zero_status(5) = '1') or (neighbor_revealed(4) = '1' and neighbor_zero_status(4) = '1') or
				(neighbor_revealed(3) = '1' and neighbor_zero_status(3) = '1') or (neighbor_revealed(2) = '1' and neighbor_zero_status(2) = '1') or
				(neighbor_revealed(1) = '1' and neighbor_zero_status(1) = '1') or (neighbor_revealed(0) = '1' and neighbor_zero_status(0) = '1')) then revealed <= '1';
			else revealed <= '0';
			end if;
		end if;
	end process;
end behavioral;