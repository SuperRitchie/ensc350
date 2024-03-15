library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pointDraw is
  port (
    clk : in std_logic;
	 SW_X : in std_logic_vector(7 downto 0);
	 SW_Y : in std_logic_vector(6 downto 0);
    --SW_Color : in std_logic_vector(2 downto 0);
	 --color : out std_logic_vector(2 downto 0);
	 x : out std_logic_vector(7 downto 0);
	 y : out std_logic_vector(6 downto 0);
    draw : out std_logic
  );
end pointDraw; 

architecture logic of pointDraw is

begin

process(clk)
begin 
	if (clk = '0') then 
		x <= SW_X;
		y <= SW_Y;
		--color <= SW_Color;
		draw <= '1';
	else
		draw <= '0';
	end if;
	
end process;
end architecture;