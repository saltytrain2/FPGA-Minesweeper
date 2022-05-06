library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE  IEEE.STD_LOGIC_ARITH.all;


ENTITY images IS


   PORT(pixel_row, pixel_col		: IN std_logic_vector(9 DOWNTO 0);
        Red,Green,Blue 				: OUT std_logic;
		  Vert_sync	: IN std_logic);
       
		
		
END images;

architecture smite_images of images is
	signal colNum, rowNum : integer;
	signal cenx, ceny : std_logic_vector(9 downto 0);
	--signal center  : std_logic_vector(19 downto 0);
	constant increment: unsigned(9 downto 0) := to_unsigned(80,10);
	begin
	
	process(pixel_col, pixel_row)
	begin		
		-- col must be incremented
	   --	row can stay the same
		
		--rows tile discription
		if(unsigned(pixel_row) >= to_unsigned(0, 10) and (unsigned(pixel_row) <= to_unsigned(29, 10))) then
			rowNum <= 0;
			cenx <= to_unsigned(15, 10);
		elsif(unsigned(pixel_row) >= to_unsigned(30, 10) and unsigned(pixel_row) <= to_unsigned(59, 10)) then
			rowNum <= 1;
			cenx <= to_unsigned(45, 10);
		elsif(unsigned(pixel_row) >= to_unsigned(60, 10) and unsigned(pixel_row) <= to_unsigned(89, 10)) then
			rowNum <= 2;
			cenx <= to_unsigned(75, 10);
		elsif(unsigned(pixel_row) >= to_unsigned(120, 10) and unsigned(pixel_row) <= to_unsigned(119, 10)) then
			rowNum <= 3;
			cenx <= to_unsigned(105, 10);
		elsif(unsigned(pixel_row) >= to_unsigned(150, 10) and unsigned(pixel_row) <= to_unsigned(149, 10)) then
			rowNum <= 4;
			cenx <= to_unsigned(135, 10);
		elsif(unsigned(pixel_row) >= to_unsigned(180, 10) and unsigned(pixel_row) <= to_unsigned(179, 10)) then
			rowNum <= 5;
			cenx <= to_unsigned(165, 10);
		elsif(unsigned(pixel_row) >= to_unsigned(210, 10) and unsigned(pixel_row) <= to_unsigned(209, 10)) then
			rowNum <= 6;
			cenx <= to_unsigned(1955, 10);
		elsif(unsigned(pixel_row) >= to_unsigned(240, 10) and unsigned(pixel_row) <= to_unsigned(239, 10)) then
			rowNum <= 7;
			cenx <= to_unsigned(225, 10);
		elsif(unsigned(pixel_row) >= to_unsigned(270, 10) and unsigned(pixel_row) <= to_unsigned(269, 10)) then
			rowNum <= 8;
			cenx <= to_unsigned(255, 10);
		elsif(unsigned(pixel_row) >= to_unsigned(300, 10) and unsigned(pixel_row) <= to_unsigned(299, 10)) then
			rowNum <= 9;
			cenx <= to_unsigned(285, 10);
		elsif(unsigned(pixel_row) >= to_unsigned(330, 10) and unsigned(pixel_row) <= to_unsigned(329, 10)) then
			rowNum <= 10;
			cenx <= to_unsigned(315, 10);
		elsif(unsigned(pixel_row) >= to_unsigned(360, 10) and unsigned(pixel_row) <= to_unsigned(359, 10)) then
			rowNum <= 11;
			cenx <= to_unsigned(345, 10);
		elsif(unsigned(pixel_row) >= to_unsigned(390, 10) and unsigned(pixel_row) <= to_unsigned(389, 10)) then
			rowNum <= 12;
			cenx <= to_unsigned(375, 10);
		elsif(unsigned(pixel_row) >= to_unsigned(390, 10) and unsigned(pixel_row) <= to_unsigned(419, 10)) then
			rowNum <= 13;
			cenx <= to_unsigned(405, 10);
		elsif(unsigned(pixel_row) >= to_unsigned(390, 10) and unsigned(pixel_row) <= to_unsigned(449, 10)) then
			rowNum <= 14;
			cenx <= to_unsigned(435, 10);
		elsif(unsigned(pixel_row) >= to_unsigned(390, 10) and unsigned(pixel_row) <= to_unsigned(479, 10)) then
			rowNum <= 15;
			cenx <= to_unsigned(465, 10);
			
		end if;
		
		--columns tile discription
		if (unsigned(pixel_col) >= increment and ((pixel_col) <= increment + to_unsigned(29, 10))) then
			colNum <= 0;
			ceny <= increment + to_unsigned(15, 10);
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(30, 10) and unsigned(pixel_col) <= increment + to_unsigned(59, 10)) then
			colNum <= 1;
			ceny <= increment + to_unsigned(45, 10);
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(60, 10) and unsigned(pixel_col) <= increment + to_unsigned(89, 10)) then
			colNum <= 2;
			ceny <= increment + to_unsigned(75, 10);
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(90, 10) and unsigned(pixel_col) <= increment + to_unsigned(119, 10)) then
			colNum <= 3;
			ceny <= increment + to_unsigned(105, 10);
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(120, 10) and unsigned(pixel_col) <= increment + to_unsigned(149, 10)) then
			colNum <= 4;
			ceny <= increment + to_unsigned(135, 10);
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(150, 10) and unsigned(pixel_col) <= increment + to_unsigned(179, 10)) then
			colNum <= 5;
			ceny <= increment + to_unsigned(165, 10);
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(180, 10) and unsigned(pixel_col) <= increment + to_unsigned(209, 10)) then
			colNum <= 6;
			ceny <= increment + to_unsigned(195, 10);
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(210, 10) and unsigned(pixel_col) <= increment + to_unsigned(239, 10)) then
			colNum <= 7;
			ceny <= increment + to_unsigned(225, 10);
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(240, 10) and unsigned(pixel_col) <= increment + to_unsigned(269, 10)) then
			colNum <= 8;
			ceny <= increment + to_unsigned(255, 10);
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(270, 10) and unsigned(pixel_col) <= increment + to_unsigned(299, 10)) then
			colNum <= 9;
			ceny <= increment + to_unsigned(285, 10);
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(300, 10) and unsigned(pixel_col) <= increment + to_unsigned(329, 10)) then
			colNum <= 10;
			ceny <= increment + to_unsigned(315, 10);
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(330, 10) and unsigned(pixel_col) <= increment + to_unsigned(359, 10)) then
			colNum <= 11;
			ceny <= increment + to_unsigned(345, 10);
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(360, 10) and unsigned(pixel_col) <= increment + to_unsigned(389, 10)) then
			colNum <= 12;
			ceny <= increment + to_unsigned(375, 10);
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(390, 10) and unsigned(pixel_col) <= increment + to_unsigned(419, 10)) then
			colNum <= 13;
			ceny <= increment + to_unsigned(405, 10);
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(420, 10) and unsigned(pixel_col) <= increment + to_unsigned(449, 10)) then
			colNum <= 14;
			ceny <= increment + to_unsigned(435, 10);
			
		elsif(unsigned(pixel_col) >= increment + to_unsigned(450, 10) and unsigned(pixel_col) <= increment + to_unsigned(479, 10)) then
			colNum <= 15;
			ceny <= increment + to_unsigned(465, 10);
			
		end if;
	end process;
end architecture;	