library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.minesweeper_pkg.all;
--USE  IEEE.STD_LOGIC_ARITH.all;


ENTITY artdesign IS


   PORT(pixel_row, pixel_col		: IN std_logic_vector(9 DOWNTO 0);
        Red,Green,Blue 				: OUT std_logic;
		  flagged_array				: IN STD_LOGIC_VECTOR(255 downto 0);
		  revealed_array				: IN STD_LOGIC_VECTOR(255 downto 0);
		  game_status 					: in tile_status_array;
		  Vert_sync	: IN std_logic);
   
		
END artdesign;

architecture smite_images of artdesign is
	signal colNum, rowNum : integer;
	signal cenx, ceny : std_logic_vector(9 downto 0);
	--signal center  : std_logic_vector(19 downto 0);
	constant increment: unsigned(9 downto 0) := to_unsigned(80,10);
	
	signal flagged, revealed : std_logic;
	signal tile_status : unsigned(3 downto 0);
	signal topleftx, toplefty : std_logic_vector(9 downto 0);
	signal distx, disty : unsigned(9 downto 0);

	begin

	process(vert_sync, pixel_col, pixel_row)
	begin
		if rising_edge(vert_sync) then
			for tile in 0 to 255 loop
		flagged <= flagged_array(tile);

		revealed <= revealed_array(tile);

		tile_status <= game_status(tile);

		topleftx <= std_logic_vector(unsigned(cenx) - to_unsigned(15,10));
		toplefty <= std_logic_Vector(unsigned(ceny) - to_unsigned(15,10));

		-- col must be incremented
	   --	row can stay the same
		
		--rows tile discription
		if(unsigned(pixel_row) >= to_unsigned(0, 10) and (unsigned(pixel_row) <= to_unsigned(29, 10))) then
			rowNum <= 0;
			cenx <= std_logic_vector(to_unsigned(15, 10));
		elsif(unsigned(pixel_row) >= to_unsigned(30, 10) and unsigned(pixel_row) <= to_unsigned(59, 10)) then
			rowNum <= 1;
			cenx <= std_logic_vector(to_unsigned(45, 10));
		elsif(unsigned(pixel_row) >= to_unsigned(60, 10) and unsigned(pixel_row) <= to_unsigned(89, 10)) then
			rowNum <= 2;
			cenx <= std_logic_vector(to_unsigned(75, 10));
		elsif(unsigned(pixel_row) >= to_unsigned(120, 10) and unsigned(pixel_row) <= to_unsigned(119, 10)) then
			rowNum <= 3;
			cenx <= std_logic_vector(to_unsigned(105, 10));
		elsif(unsigned(pixel_row) >= to_unsigned(150, 10) and unsigned(pixel_row) <= to_unsigned(149, 10)) then
			rowNum <= 4;
			cenx <= std_logic_vector(to_unsigned(135, 10));
		elsif(unsigned(pixel_row) >= to_unsigned(180, 10) and unsigned(pixel_row) <= to_unsigned(179, 10)) then
			rowNum <= 5;
			cenx <= std_logic_vector(to_unsigned(165, 10));
		elsif(unsigned(pixel_row) >= to_unsigned(210, 10) and unsigned(pixel_row) <= to_unsigned(209, 10)) then
			rowNum <= 6;
			cenx <= std_logic_vector(to_unsigned(195, 10));
		elsif(unsigned(pixel_row) >= to_unsigned(240, 10) and unsigned(pixel_row) <= to_unsigned(239, 10)) then
			rowNum <= 7;
			cenx <= std_logic_vector(to_unsigned(225, 10));
		elsif(unsigned(pixel_row) >= to_unsigned(270, 10) and unsigned(pixel_row) <= to_unsigned(269, 10)) then
			rowNum <= 8;
			cenx <= std_logic_vector(to_unsigned(255, 10));
		elsif(unsigned(pixel_row) >= to_unsigned(300, 10) and unsigned(pixel_row) <= to_unsigned(299, 10)) then
			rowNum <= 9;
			cenx <= std_logic_vector(to_unsigned(285, 10));
		elsif(unsigned(pixel_row) >= to_unsigned(330, 10) and unsigned(pixel_row) <= to_unsigned(329, 10)) then
			rowNum <= 10;
			cenx <= std_logic_vector(to_unsigned(315, 10));
		elsif(unsigned(pixel_row) >= to_unsigned(360, 10) and unsigned(pixel_row) <= to_unsigned(359, 10)) then
			rowNum <= 11;
			cenx <= std_logic_vector(to_unsigned(345, 10));
		elsif(unsigned(pixel_row) >= to_unsigned(390, 10) and unsigned(pixel_row) <= to_unsigned(389, 10)) then
			rowNum <= 12;
			cenx <= std_logic_vector(to_unsigned(375, 10));
		elsif(unsigned(pixel_row) >= to_unsigned(390, 10) and unsigned(pixel_row) <= to_unsigned(419, 10)) then
			rowNum <= 13;
			cenx <= std_logic_vector(to_unsigned(405, 10));
		elsif(unsigned(pixel_row) >= to_unsigned(390, 10) and unsigned(pixel_row) <= to_unsigned(449, 10)) then
			rowNum <= 14;
			cenx <= std_logic_vector(to_unsigned(435, 10));
		elsif(unsigned(pixel_row) >= to_unsigned(390, 10) and unsigned(pixel_row) <= to_unsigned(479, 10)) then
			rowNum <= 15;
			cenx <= std_logic_vector(to_unsigned(465, 10));
			
		end if;
		
		--columns tile discription
		if unsigned(pixel_col) >= increment and (unsigned(pixel_col)	<= increment + to_unsigned(29, 10)) then
			colNum <= 0;
			ceny <= std_logic_vector(increment + to_unsigned(15, 10));
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(30, 10) and unsigned(pixel_col) <= increment + to_unsigned(59, 10)) then
			colNum <= 1;
			ceny <= std_logic_vector(increment + to_unsigned(45, 10));
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(60, 10) and unsigned(pixel_col) <= increment + to_unsigned(89, 10)) then
			colNum <= 2;
			ceny <= std_logic_vector(increment + to_unsigned(75, 10));
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(90, 10) and unsigned(pixel_col) <= increment + to_unsigned(119, 10)) then
			colNum <= 3;
			ceny <= std_logic_vector(increment + to_unsigned(105, 10));
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(120, 10) and unsigned(pixel_col) <= increment + to_unsigned(149, 10)) then
			colNum <= 4;
			ceny <= std_logic_vector(increment + to_unsigned(135, 10));
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(150, 10) and unsigned(pixel_col) <= increment + to_unsigned(179, 10)) then
			colNum <= 5;
			ceny <= std_logic_vector(increment + to_unsigned(165, 10));
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(180, 10) and unsigned(pixel_col) <= increment + to_unsigned(209, 10)) then
			colNum <= 6;
			ceny <= std_logic_vector(increment + to_unsigned(195, 10));
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(210, 10) and unsigned(pixel_col) <= increment + to_unsigned(239, 10)) then
			colNum <= 7;
			ceny <= std_logic_vector(increment + to_unsigned(225, 10));
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(240, 10) and unsigned(pixel_col) <= increment + to_unsigned(269, 10)) then
			colNum <= 8;
			ceny <= std_logic_vector(increment + to_unsigned(255, 10));
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(270, 10) and unsigned(pixel_col) <= increment + to_unsigned(299, 10)) then
			colNum <= 9;
			ceny <= std_logic_vector(increment + to_unsigned(285, 10));
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(300, 10) and unsigned(pixel_col) <= increment + to_unsigned(329, 10)) then
			colNum <= 10;
			ceny <= std_logic_vector(increment + to_unsigned(315, 10));
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(330, 10) and unsigned(pixel_col) <= increment + to_unsigned(359, 10)) then
			colNum <= 11;
			ceny <= std_logic_vector(increment + to_unsigned(345, 10));
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(360, 10) and unsigned(pixel_col) <= increment + to_unsigned(389, 10)) then
			colNum <= 12;
			ceny <= std_logic_vector(increment + to_unsigned(375, 10));
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(390, 10) and unsigned(pixel_col) <= increment + to_unsigned(419, 10)) then
			colNum <= 13;
			ceny <= std_logic_vector(increment + to_unsigned(405, 10));
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(420, 10) and unsigned(pixel_col) <= increment + to_unsigned(449, 10)) then
			colNum <= 14;
			ceny <= std_logic_vector(increment + to_unsigned(435, 10));
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(450, 10) and unsigned(pixel_col) <= increment + to_unsigned(479, 10)) then
			colNum <= 15;
			ceny <= std_logic_vector(increment + to_unsigned(465, 10));
		end if;
		
			-- first, check if it's a border
if unsigned(pixel_col) - unsigned(topleftx) = to_unsigned(0,10) or unsigned(pixel_col) - unsigned(topleftx) = to_unsigned(15,10)
	or unsigned(pixel_row) - unsigned(toplefty) = to_unsigned(0,10) or unsigned(pixel_row) - unsigned(toplefty) = to_unsigned(15,10) then
	
	Red <= '1';
	Green <= '1';
	Blue <= '1';
	
	
elsif (revealed = '1') then
	
	if (tile_status = to_unsigned(9,4)) then -- This is a bomb
		
		if (pixel_col >= cenx) then
			distx <= unsigned(pixel_col) - unsigned(cenx);
		else
			distx <= unsigned(cenx) - unsigned(pixel_col);
		end if;
		
		if (pixel_row >= ceny) then
			disty <= unsigned(pixel_row) - unsigned(ceny);
		else
			disty <= unsigned(ceny) - unsigned(pixel_row);
		end if;
		
		if (distx * distx + disty * disty <= to_unsigned(8,10)) then -- if we're in the circle paint it black
			Red <= '1';
			Green <= '1';
			Blue <= '1';
		else -- if it's not in the circle it's white
			Red <= '0';
			Green <= '0';
			Blue <= '0';
		end if;
		
	elsif (tile_status = to_unsigned(1,4)) then -- this is a one
		if unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(14,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(16,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(5,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		
		else
			Red <= '0';
			Green <= '0';
			Blue <= '0';
		end if;
	
	elsif (tile_status = to_unsigned(2,4)) then -- this is a two
		if unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(5,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(7,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(23,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(5,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(16,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
			
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(14,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(16,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(7,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(14,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(23,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		
		else
			Red <= '0';
			Green <= '0';
			Blue <= '0';
		end if;
			
	elsif (tile_status = to_unsigned(3,4)) then -- this is a three
		--top
		if unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(5,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(7,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--right
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(23,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(5,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--mid	
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(14,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(16,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--bot
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(23,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		
		else
			Red <= '0';
			Green <= '0';
			Blue <= '0';
		end if;
		
	elsif (tile_status = to_unsigned(4,4)) then -- this is a four
		-- top
		if unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(7,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(5,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(16,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
			
		--vert
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(23,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(5,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--mid	
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(14,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(16,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		
		else
			Red <= '0';
			Green <= '0';
			Blue <= '0';
		end if;
		
	elsif (tile_status = to_unsigned(5,4)) then -- this is a five
		--top
		if unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(5,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(7,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--left
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(7,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(5,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(16,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--mid	
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(14,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(16,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--right
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(23,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(14,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--bot
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(23,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		
		else
			Red <= '0';
			Green <= '0';
			Blue <= '0';
		end if;
		
	elsif (tile_status = to_unsigned(6,4)) then -- this is a six
		--top
		if unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(5,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(7,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--left
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(7,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(5,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--right
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(23,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(14,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--mid	
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(14,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(16,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--bot
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(23,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		
		else
			Red <= '0';
			Green <= '0';
			Blue <= '0';
		end if;
		
	elsif (tile_status = to_unsigned(7,4)) then -- this is a seven
		--top
		if unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(5,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(7,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--right
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(23,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(5,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		
		else
			Red <= '0';
			Green <= '0';
			Blue <= '0';
		end if;
		
	elsif (tile_status = to_unsigned(8,4)) then -- this is an eight
		--top
		if unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(5,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(7,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--left
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(7,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(5,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--right
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(23,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(5,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--mid	
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(14,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(16,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--bot
		elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(5,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(25,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(23,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		
		else
			Red <= '0';
			Green <= '0';
			Blue <= '0';
		end if;	
		
	else --this is a zero
		Red <= '0';
		Green <= '0';
		Blue <= '0';
	end if;

elsif (flagged = '1') then -- now handle the flag design
	
	-- if we're on middle three col and middle twenty rows, it's in the black bar
	if unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(14,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(16,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(5,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(25,10) then
		
		Red <= '1';
		Green <= '1';
		Blue <= '1';
	
	-- this is on the red rectangle of the flag
	elsif unsigned(pixel_col) - unsigned(topleftx) >= to_unsigned(4,10) and unsigned(pixel_col) - unsigned(topleftx) <= to_unsigned(13,10)
		and unsigned(pixel_row) - unsigned(toplefty) >= to_unsigned(5,10) and unsigned(pixel_row) - unsigned(toplefty) <= to_unsigned(14,10) then
		
		Red <= '1';
		Green <= '0';
		Blue <= '0';
		
	else  --anywhere else should be green
		Red <= '0';
		Green <= '1';
		Blue <= '0';
	end if;
		
else -- This is for when something is unrevealed and unflagged, the tile is all white
	Red <= '0';
	Green <= '1';
	Blue <= '0';
end if;	
		
		end loop;
	end if;
	end process;
end architecture;	