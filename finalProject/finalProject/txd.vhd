library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity txd is
	generic(baudRate : integer := 5208);
	port(clk : in std_logic;
		  rst : in std_logic;
		  key : in std_logic;
		  data : in std_logic_vector(7 downto 0);
		  uart_cts : in std_logic;
		  uart_txd : out std_logic;
		  uart_rts : out std_logic;
		  led : out std_logic_vector(7 downto 0));
end txd;

architecture logic of txd is
	type stateType is (idle, handshake, startTransmit, transmit, parity, finished);
	signal currState : stateType;
	
	begin
	process(clk, rst)
	variable baudGenMax : integer := baudRate - 1;
	variable baudCounter : integer := 0;
	variable parityBit : std_logic;
	variable index : integer := 0;
	variable pressed : std_logic := '0';

	begin
		if (rst = '0') then
			baudCounter := 0;
			index := 0;
			currState <= idle;
			pressed := '0';
			led <= "11111111";
		elsif (rising_edge(clk)) then
			
			case currState is
				when idle => 
					uart_txd <= '1';
					uart_rts <= '0';
					if key = '1' and pressed = '1' then
						pressed := '0';
					end if;
					
					if key = '0' and pressed = '0' then
						uart_rts <= '1';	--initiate handshake
						currState <= handshake;
						pressed := '1';
					end if;
					led <= "00000001";
				when handshake =>
					uart_txd <= '1';

					if uart_cts = '1' then
						currState <= startTransmit;
					end if;
					led <= "00000010";
				when startTransmit =>
					led <= "00000100";	
					uart_txd <= '0';
					if (baudCounter < baudGenMax) then
						baudCounter := baudCounter + 1;
					else
						baudCounter := 0;
						currState <= transmit;
						
						parityBit := (data(7) xor (data(6) xor (data(5) xor (data(4) xor (data(3) xor (data(2) xor (data(1) xor data(0))))))));
					end if;
				when transmit =>
					led <= "00001000";
					uart_txd <= data(index);
					if (baudCounter < baudGenMax) then
						baudCounter := baudCounter + 1;
					else
						index := index + 1;
						baudCounter := 0;
						if (index = 8) then
							currState <= parity;
							index := 0;
						end if;
					end if;
				when parity =>
					led <= "00010000";	
					uart_txd <= parityBit;
					if (baudCounter < baudGenMax) then
						baudCounter := baudCounter + 1;
					else
						baudCounter := 0;
						currState <= finished;
					end if;
				when finished =>
					led <= "00100000";	
					uart_txd <= '1'; --finished transmit
					if (baudCounter < baudGenMax) then
						baudCounter := baudCounter + 1;
					else
						baudCounter := 0;
						currState <= idle;
					end if;
				when others => 
					led <= "11110000";
					currState <= idle;
			end case;
		end if;
	end process;
end architecture;	
		  