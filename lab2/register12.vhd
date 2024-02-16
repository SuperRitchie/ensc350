library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity register12 is
  port (
    clk : in std_logic;
	 rst: in std_logic;
	 d : in unsigned(11 downto 0);
    q : out unsigned(11 downto 0)
  );
end register12; 

architecture logic of register12 is
begin
  process(clk)
  begin
    if (rst = '0') then
		q <= x"020";
	 elsif (rising_edge(clk)) then
		q <= d;
	 end if;
  end process;

end architecture;