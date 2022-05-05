library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package minesweeper_pkg is
	-- custom array definitions
	type bombs_array is array(255 downto 0) of std_logic_vector(7 downto 0);
	type revealed_array is array(255 downto 0) of std_logic_vector(7 downto 0);
	type zero_status_array is array(255 downto 0) of std_logic_vector(7 downto 0);
	type tile_status_array is array(255 downto 0) of unsigned(3 downto 0);
	
	-- function to determine whether an index + offset is out of bounds
	-- if out of bounds, the current index is returned, otherwise index + offset is returned
	function checkBounds (
		num_block : in integer;
		offset : in integer
	) return integer;
end package;

package body minesweeper_pkg is 
	function checkBounds (
		num_block : in integer;
		offset : in integer
	) return integer is
	begin
		if (num_block mod 16 = 0) then 
			if (offset = -1 or offset = -17 or offset = 15) then return num_block;
			end if;
		end if;
		
		if (num_block mod 16 = 15) then
			if (offset = 1 or offset = 17 or offset = -15) then return num_block;
			end if;
		end if;
		
		if (num_block < 16) then
			if (offset = -15 or offset = -16 or offset = -17) then return num_block;
			end if;
		end if;
		
		if (num_block > 239) then
			if (offset = 15 or offset = 16 or offset = 17) then return num_block;
			end if;
		end if;
		
		return num_block + offset;
	end;
end package body minesweeper_pkg;
	