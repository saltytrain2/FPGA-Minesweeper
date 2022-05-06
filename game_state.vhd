library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.minesweeper_pkg.all;

entity game_state is 
	port (
		clk : in std_logic;
		reset : in std_logic;
		bomb_in : in std_logic_vector(255 downto 0);
		left_clicked : in std_logic_vector(255 downto 0);
		right_clicked : in std_logic_vector(255 downto 0);
		game_status : out tile_status_array;
		game_revealed : out std_logic_vector(255 downto 0);
		game_flagged : out std_logic_vector(255 downto 0);
		game_over : out std_logic
		
	);
end entity;

architecture behavioral of game_state is
	-- constant definition used in for loop ranges
	-- refers to number of tiles used in design
	constant num_tiles : std_logic_vector(255 downto 0) := (others=>'0');
	
	-- signals for port maps that describe the connections between all components in the game
	signal neighbor_bombs : bombs_array := (others=>(others=>'0'));
	signal neighbor_revealed : revealed_array := (others=>(others=>'0'));
	signal neighbor_zero_status : zero_status_array := (others=>(others=>'0'));
	
	signal revealed, zero_status, flagged : std_logic_Vector(255 downto 0) := (others=>'0');
	signal tile_status : tile_status_array := (others=>"0000");
	
	component tile
		port (
			clk, reset, bomb_in, left_clicked, right_clicked : in std_logic;
		
			neighbor_bombs, neighbor_revealed, neighbor_zero_status : in std_logic_vector(7 downto 0);
		
			revealed, zero_status, flag : out std_logic;
			tile_status : out unsigned(3 downto 0)
		);
	end component;
begin
	-- generate the internal connections between signals
	signal_for : for i in num_tiles'range generate
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
	tile_inst : for i in num_tiles'range generate
		my_tiles : tile port map (
			clk => clk,
			reset => reset,
			neighbor_bombs => neighbor_bombs(i),
			neighbor_revealed => neighbor_revealed(i),
			neighbor_zero_status => neighbor_zero_status(i),
			bomb_in => bomb_in(i),
			left_clicked => left_clicked(i),
			right_clicked => right_clicked(i),
			tile_status => tile_status(i),
			revealed => revealed(i),
			flag => flagged(i),
			zero_status => zero_status(i)
		);	
	end generate tile_inst;
	
	process (clk, reset)
		variable isGameOver: std_logic := '0';
	begin
		if (reset = '1') then 
			isGameOver := '0';
		elsif (rising_edge(clk) and isGameOver /= '1') then
			game_status <= tile_status;
			game_revealed <= revealed;

			for i in num_tiles'range loop
				if (revealed(i) = '1' and tile_status(i) = "1001") then
					isGameOver := '1';
				end if;
			end loop;
			
			game_over <= isGameOver;
			game_status <= tile_status;
			game_revealed <= revealed;
			game_flagged <= flagged;
		end if;
	end process;
end behavioral;