library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART is
	port(CLOCK_50 : in std_logic;
		  KEY : in std_logic_vector(3 downto 0);
		  SW : in std_logic_vector(17 downto 0);
		  LEDG : out std_logic_vector(7 downto 0);
		  LEDR : out std_logic_vector(17 downto 0);
		  UART_RXD : in std_logic;
		  UART_CTS : in std_logic;
		  UART_RTS : out std_logic;
		  UART_TXD : out std_logic);
end UART;

architecture logic of UART is
component txd is
	generic(baudRate : integer := 5208);
	port(clk : in std_logic;
		  rst : in std_logic;
		  key : in std_logic;
		  data : in std_logic_vector(7 downto 0);
		  uart_cts : in std_logic;
		  uart_txd : out std_logic;
		  uart_rts : out std_logic;
		  led : out std_logic_vector(7 downto 0));
end component;

component rxd is
	generic(baudRate : integer := 5208);
	port(clk : in std_logic;
		  rst : in std_logic;
		  data : out std_logic_vector(7 downto 0);
		  uart_cts : in std_logic;
		  uart_rxd : in std_logic;
		  uart_rts : out std_logic;
		  led : out std_logic_vector(7 downto 0));
end component;

component debounce is
  generic (
    timeout_cycles : positive := 50
    );
  port (
    clk : in std_logic;
    switch : in std_logic;
    switch_debounced : out std_logic
  );
end component; 
signal debounced : std_logic;
begin
u: debounce port map (CLOCK_50, KEY(0), debounced);
transmit: txd port map (CLOCK_50, KEY(3), debounced, SW(7 downto 0), UART_CTS, UART_TXD, UART_RTS, LEDG);

end architecture;