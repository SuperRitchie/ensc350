library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerGeneral is
  generic (numBits : positive := 12);
  port (
    clk : in std_logic;
	 rst: in std_logic;
	 d : in unsigned(numBits downto 0);
    q : out unsigned(numBits downto 0)
  );
end registerGeneral; 

architecture logic of registerGeneral is
begin
  process(clk)
  begin
    if (rst = '0') then
		q <= (others => '0');
	 elsif (rising_edge(clk)) then
		q <= d;
	 end if;
  end process;

end architecture;