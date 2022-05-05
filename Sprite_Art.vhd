

signal flagged, revealed : std_logic;
signal title_status : unsigned(3 downto 0);


flagged = flagged_array(tile);

revealed = revealed_array(tile);

tile_status = tile_status_array(tile);

topleftx = cenx - conv_std_logic_vector(15,10);
toplefty = ceny - conv_std_logic_Vector(15,10);


-- first, check if it's a border
if (pixel_column - topleftx = conv_std_logic_vector(0,10) or pixel_column - topleftx = conv_std_logic_vector(15,10)
	or pixel_row - toplefty = conv_std_logic_vector(0,10) or pixel_column - toplefty = conv_std_logic_vector(15,10) then
	
	Red <= '1';
	Green <= '1';
	Blue <= '1';
	
	
elsif (revealed = '1') then
	
	if (tile_status = to_unsigned(9,4)) then -- This is a bomb
		
		if (pixel_col >= cenx) then
			distx = pixel_col - cenx;
		else
			distx = cenx - pixel_col;
		end if;
		
		if (pixel_row >= ceny) then
			disty = pixel_row - ceny;
		else
			disty = ceny - pixel_row;
		end if;
		
		if (distx * distx + disty * disty <= conv_std_logic_vector(8,10)) then -- if we're in the circle paint it black
			Red <= '1';
			Green <= '1';
			Blue <= '1';
		else -- if it's not in the circle it's white
			Red <= '0';
			Green <= '0';
			Blue <= '0';
		end if;
		
	elsif (tile_status = to_unsigned(1,4)) then -- this is a one
		if (pixel_column - topleftx >= conv_std_logic_vector(14,10) and pixel_column - topleftx <= conv_std_logic_vector(16,10)
		and pixel_row - toplefty >= conv_std_logic_vector(5,10) and pixel_row - toplefty <= conv_std_logic_vector(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		
		else
			Red <= '0';
			Green <= '0';
			Blue <= '0';
		end if;
	
	elsif (tile_status = to_unsigned(2,4)) then -- this is a two
		if (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(5,10) and pixel_row - toplefty <= conv_std_logic_vector(7,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		
		elsif (pixel_column - topleftx >= conv_std_logic_vector(23,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(5,10) and pixel_row - toplefty <= conv_std_logic_vector(16,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
			
		elsif (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(14,10) and pixel_row - toplefty <= conv_std_logic_vector(16,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		
		elsif (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(7,10)
		and pixel_row - toplefty >= conv_std_logic_vector(14,10) and pixel_row - toplefty <= conv_std_logic_vector(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		
		elsif (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(23,10) and pixel_row - toplefty <= conv_std_logic_vector(25,10) then
		
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
		if (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(5,10) and pixel_row - toplefty <= conv_std_logic_vector(7,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--right
		elsif (pixel_column - topleftx >= conv_std_logic_vector(23,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(5,10) and pixel_row - toplefty <= conv_std_logic_vector(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--mid	
		elsif (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(14,10) and pixel_row - toplefty <= conv_std_logic_vector(16,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--bot
		elsif (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(23,10) and pixel_row - toplefty <= conv_std_logic_vector(25,10) then
		
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
		if (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(7,10)
		and pixel_row - toplefty >= conv_std_logic_vector(5,10) and pixel_row - toplefty <= conv_std_logic_vector(16,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
			
		--vert
		elsif (pixel_column - topleftx >= conv_std_logic_vector(23,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(5,10) and pixel_row - toplefty <= conv_std_logic_vector(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--mid	
		elsif (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(14,10) and pixel_row - toplefty <= conv_std_logic_vector(16,10) then
		
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
		if (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(5,10) and pixel_row - toplefty <= conv_std_logic_vector(7,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--left
		elsif (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(7,10)
		and pixel_row - toplefty >= conv_std_logic_vector(5,10) and pixel_row - toplefty <= conv_std_logic_vector(16,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--mid	
		elsif (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(14,10) and pixel_row - toplefty <= conv_std_logic_vector(16,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--right
		elsif (pixel_column - topleftx >= conv_std_logic_vector(23,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(14,10) and pixel_row - toplefty <= conv_std_logic_vector(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--bot
		elsif (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(23,10) and pixel_row - toplefty <= conv_std_logic_vector(25,10) then
		
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
		if (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(5,10) and pixel_row - toplefty <= conv_std_logic_vector(7,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--left
		elsif (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(7,10)
		and pixel_row - toplefty >= conv_std_logic_vector(5,10) and pixel_row - toplefty <= conv_std_logic_vector(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--right
		elsif (pixel_column - topleftx >= conv_std_logic_vector(23,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(14,10) and pixel_row - toplefty <= conv_std_logic_vector(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--mid	
		elsif (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(14,10) and pixel_row - toplefty <= conv_std_logic_vector(16,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--bot
		elsif (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(23,10) and pixel_row - toplefty <= conv_std_logic_vector(25,10) then
		
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
		if (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(5,10) and pixel_row - toplefty <= conv_std_logic_vector(7,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--right
		elsif (pixel_column - topleftx >= conv_std_logic_vector(23,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(5,10) and pixel_row - toplefty <= conv_std_logic_vector(25,10) then
		
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
		if (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(5,10) and pixel_row - toplefty <= conv_std_logic_vector(7,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--left
		elsif (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(7,10)
		and pixel_row - toplefty >= conv_std_logic_vector(5,10) and pixel_row - toplefty <= conv_std_logic_vector(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--right
		elsif (pixel_column - topleftx >= conv_std_logic_vector(23,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(5,10) and pixel_row - toplefty <= conv_std_logic_vector(25,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--mid	
		elsif (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(14,10) and pixel_row - toplefty <= conv_std_logic_vector(16,10) then
		
			Red <= '0';
			Green <= '0';
			Blue <= '1';
		--bot
		elsif (pixel_column - topleftx >= conv_std_logic_vector(5,10) and pixel_column - topleftx <= conv_std_logic_vector(25,10)
		and pixel_row - toplefty >= conv_std_logic_vector(23,10) and pixel_row - toplefty <= conv_std_logic_vector(25,10) then
		
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
if (flagged = '1') then -- now handle the flag design
	
	-- if we're on middle three col and middle twenty rows, it's in the black bar
	if (pixel_column - topleftx >= conv_std_logic_vector(14,10) and pixel_column - topleftx <= conv_std_logic_vector(16,10)
		and pixel_row - toplefty >= conv_std_logic_vector(5,10) and pixel_row - toplefty <= conv_std_logic_vector(25,10) then
		
		Red <= '1';
		Green <= '1';
		Blue <= '1';
	
	-- this is on the red rectangle of the flag
	elsif (pixel_column - topleftx >= conv_std_logic_vector(4,10) and pixel_column - topleftx <= conv_std_logic_vector(13,10)
		and pixel_row - toplefty >= conv_std_logic_vector(5,10) and pixel_row - toplefty <= conv_std_logic_vector(14,10) then
		
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