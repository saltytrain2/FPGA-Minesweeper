library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.minesweeper_pkg.all;

entity game_state is 
	port (
		clk : in std_logic;
		reset : in std_logic;
		bomb_in : in std_logic_vector(255 downto 0);
		clicked : in std_logic_vector(255 downto 0);
		
		game_status : out tile_status_array;
		game_revealed : out std_logic_vector(255 downto 0);
		game_over : out std_logic
		
	);
end entity;

architecture behavioral of game_state is
	-- signals for port maps that describe the connections between all components in the game
	signal neighbor_bombs : bombs_array := (others=>(others=>'0'));
	signal neighbor_revealed : revealed_array := (others=>(others=>'0'));
	signal neighbor_zero_status : zero_status_array := (others=>(others=>'0'));
	
	signal revealed, zero_status : std_logic_Vector(255 downto 0) := (others=>'0');
	signal tile_status : tile_status_array := (others=>"0000");
	
	component tile
		port (
			clk, reset, bomb_in, clicked : in std_logic;
		
			neighbor_bombs, neighbor_revealed, neighbor_zero_status : in std_logic_vector(7 downto 0);
		
			revealed, zero_status : out std_logic;
			tile_status : out unsigned(3 downto 0)
		);
	end component;
begin
	-- generate the internal connections between signals
	signal_for : for i in 0 to 255 generate
		neighbor_bombs(i) <= bomb_in(checkBounds(i, 1)) & bomb_in(checkBounds(i, -1)) & bomb_in(checkBounds(i, 16)) &
		                     bomb_in(checkBounds(i, -16)) & bomb_in(checkBounds(i, 15)) & bomb_in(checkBounds(i, -15)) &
									bomb_in(checkBounds(i, 17)) & bomb_in(checkBounds(i, -17));
		neighbor_revealed(i) <= revealed(checkBounds(i, 1)) & revealed(checkBounds(i, -1)) & revealed(checkBounds(i, 16)) &
										revealed(checkBounds(i, -16)) & revealed(checkBounds(i, 15)) & revealed(checkBounds(i, -15)) &
										revealed(checkBounds(i, 17)) & revealed(checkBounds(i, -17));
		neighbor_zero_status(i) <= (zero_status(checkBounds(i, 1)), zero_status(checkBounds(i, -1)), zero_status(checkBounds(i, 16)),
											 zero_status(checkBounds(i, -16)), zero_status(checkBounds(i, 15)), zero_status(checkBounds(i, -15)),
											 zero_status(checkBounds(i, 17)), zero_status(checkBounds(i, -17)));
	end generate signal_for;
	
	-- generate the 256 game tiles and their connections
	tile_inst : for i in 0 to 255 generate
		my_tiles : tile port map (
			clk => clk,
			reset => reset,
			neighbor_bombs => neighbor_bombs(i),
			neighbor_revealed => neighbor_revealed(i),
			neighbor_zero_status => neighbor_zero_status(i),
			bomb_in => bomb_in(i),
			clicked => clicked(i),
			tile_status => tile_status(i),
			revealed => revealed(i),
			zero_status => zero_status(i)
		);	
	end generate tile_inst;
	
	process (clk, reset)
	begin
		if (rising_edge(clk)) then
			game_status <= tile_status;
			game_revealed <= revealed;
			game_over <= '0';
			
			for i in clicked'range loop
				if (clicked(i) = '1' and bomb_in(i) = '1') then
					game_over <= '1';
				end if;
			end loop;
		end if;
	end process;
end behavioral;