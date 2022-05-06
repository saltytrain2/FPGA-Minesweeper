library ieee;

entity poggers
	input_a : in std_logic_vector(7 downto 0);
	input_b : in std_logic_vector(7 downto 0);
	output_a : out std_logic_vector(7 downto 0);
end entity;

architecture behavioral of poggers is
begin
	output_a <= input_a + input_b;
end behavioral;