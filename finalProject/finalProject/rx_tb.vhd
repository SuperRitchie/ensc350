library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

LIBRARY WORK;
USE WORK.all;

-- ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** --
-- 	Author: Samin Moradkhan																--
-- 																								--
-- 	This file contains the receiver testbench code								-- 
-- 	There are 10 test cases																--
-- 																								--
-- ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** ** --

entity  rx_tb is
end entity  rx_tb;


architecture sim of  rx_tb  is
	-- Delcaring the Receiver Component
	
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
	-- Constants for Clock Generation
	constant clk_hz : integer := 100e6;
	constant HALF_PERIOD : time := 10 ns;
	constant clk_period : time := HALF_PERIOD;
	-- Input Signals
	signal clk: std_logic := '1';
	signal resetn: std_logic := '1';
	signal  rx_data_in: std_logic := '0';
	-- Output Signals
	signal  rx_data_out: std_logic_vector(7 downto 0);
	signal rx_busy, rx_done, rx_err: std_logic;
	signal leds : std_logic_vector(7 downto 0);

	begin
		-- Generating the Clock
		clk <= not clk after HALF_PERIOD;
		-- Port Mapping the Receiver Component Under Test
		DUT : rxd
		port map (
			clk => clk,
			rst => resetn,
			uart_rxd =>  rx_data_in,
			data =>  rx_data_out,
			uart_cts => rx_busy,
			uart_rts => rx_done,
			led => leds
		);
		-- Begin Simulation
		SEQUENCER_PROC : process
			begin
			report "===========================Begin tests===========================";
		-- Test 1
			report "=========================== Begin Test 1 ===========================";
			report "Test 1: data in = 01101101 parity check = odd (bit = 0)";
			rx_data_in <= '0'; --start
			wait for 104000 ns ;--1
			rx_data_in <= '1';
			wait for 104000 ns ;--2
			rx_data_in <= '0';
			wait for 104000 ns ;--3
			rx_data_in <= '1';
			wait for 104000 ns ;--4
			rx_data_in <= '1';
			wait for 104000 ns ;--5
			rx_data_in <= '0';
			wait for 104000 ns;--6
			rx_data_in <= '1';
			wait for 104000 ns ;--7
			rx_data_in <= '1';       
			wait for 104000 ns;--8
			rx_data_in <= '0';
			wait for 104000 ns;--odd parity
			rx_data_in <= '1';
			wait for 104000 ns ; --stop 
			rx_data_in <= '1';

			wait for 104000*2 ns ;
			assert ( rx_data_out = "01101101")
				report "data does not match expected,data out = " & integer'image(to_integer(unsigned(rx_data_out)))
				severity failure; 

			report "=========================== Test 1 Passed ===========================";
		
		-- Test 2
			report "=========================== Begin Test 2 ===========================";
			report "Test 2: data in = 00111010 parity check = even (bit = 1)";

			rx_data_in <= '0'; --start
			wait for 104000 ns ;--1
			rx_data_in <= '0';
			wait for 104000 ns ;--2
			rx_data_in <= '1';
			wait for 104000 ns ;--3
			rx_data_in <= '0';
			wait for 104000 ns ;--4
			rx_data_in <= '1';
			wait for 104000 ns ;--5
			rx_data_in <= '1';
			wait for 104000 ns;--6
			rx_data_in <= '1';
			wait for 104000 ns ;--7
			rx_data_in <= '0';       
			wait for 104000 ns;--8
			rx_data_in <= '0';
			wait for 104000 ns;-- even parity
			rx_data_in <= '0';
			wait for 104000 ns ; --stop 
			rx_data_in <= '1';
			wait for 104000*2 ns ;
			assert ( rx_data_out = "00111010")
				report "data does not match expected,data out = " & integer'image(to_integer(unsigned(rx_data_out)))
			severity failure; 
			report "=========================== Test 2 Passed ===========================";
		
		-- Test 3
			report "=========================== Begin Test 3 ===========================";
			report "Test 3: data in = 11101101, parity check = even (bit = 1)";

			rx_data_in <= '0'; --start
			wait for 104000 ns ;--1
			rx_data_in <= '1';
			wait for 104000 ns ;--2
			rx_data_in <= '0';
			wait for 104000 ns ;--3
			rx_data_in <= '1';
			wait for 104000 ns ;--4
			rx_data_in <= '1';
			wait for 104000 ns ;--5
			rx_data_in <= '0';
			wait for 104000 ns;--6
			rx_data_in <= '1';
			wait for 104000 ns ;--7
			rx_data_in <= '1';       
			wait for 104000 ns;--8
			rx_data_in <= '1';
			wait for 104000 ns;--even parity
			rx_data_in <= '0';
			wait for 104000 ns ;--stop 
			rx_data_in <= '1';
			wait for 104000*2 ns ;
			assert ( rx_data_out = "11101101")
				report "data does not match expected,data out = " & integer'image(to_integer(unsigned(rx_data_out)))
			severity failure; 
			report "=========================== Test 3 Passed ===========================";
		
		-- Test 4
			report "=========================== Begin Test 4 ===========================";
			report "Test 4: data in = 00000000, parity check = even (bit = 1)";
			rx_data_in <= '0'; --start
			wait for 104000 ns ;--1
			rx_data_in <= '0';
			wait for 104000 ns ;--2
			rx_data_in <= '0';
			wait for 104000 ns ;--3
			rx_data_in <= '0';
			wait for 104000 ns ;--4
			rx_data_in <= '0';
			wait for 104000 ns ;--5
			rx_data_in <= '0';
			wait for 104000 ns;--6
			rx_data_in <= '0';
			wait for 104000 ns ;--7
			rx_data_in <= '0';       
			wait for 104000 ns;--8
			rx_data_in <= '0';
			wait for 104000 ns;--even parity
			rx_data_in <= '0';
			wait for 104000 ns ; --stop 
			rx_data_in <= '1';
			wait for 104000*2 ns ;
			assert ( rx_data_out = "00000000")
				report "data does not match expected,data out = " & integer'image(to_integer(unsigned(rx_data_out)))
			severity failure; 
			report "=========================== Test 4 Passed ===========================";
		
		-- Test 5
			report "=========================== Begin Test 5 ===========================";
			report "Test 5: data in = 11111111, parity check = even (bit = 1)";
			rx_data_in <= '0'; --start
			wait for 104000 ns ;--1
			rx_data_in <= '1';
			wait for 104000 ns ;--2
			rx_data_in <= '1';
			wait for 104000 ns ;--3
			rx_data_in <= '1';
			wait for 104000 ns ;--4
			rx_data_in <= '1';
			wait for 104000 ns ;--5
			rx_data_in <= '1';
			wait for 104000 ns;--6
			rx_data_in <= '1';
			wait for 104000 ns ;--7
			rx_data_in <= '1';       
			wait for 104000 ns;--8
			rx_data_in <= '1';
			wait for 104000 ns;--even parity
			rx_data_in <= '0';
			wait for 104000 ns ; --stop 
			rx_data_in <= '1';
			wait for 104000*2 ns ;
			assert ( rx_data_out = "11111111")
				report "data does not match expected,data out = " & integer'image(to_integer(unsigned(rx_data_out)))
			severity failure; 
			report "=========================== Test 5 Passed ===========================";

		-- Test 6
			report "=========================== Begin Test 6 ===========================";
			report "Test 6: data in = 00100110, parity check = odd (bit = 0)";
			rx_data_in <= '0'; --start
			wait for 104000 ns ;--1
			rx_data_in <= '0';
			wait for 104000 ns ;--2
			rx_data_in <= '1';
			wait for 104000 ns ;--3
			rx_data_in <= '1';
			wait for 104000 ns ;--4
			rx_data_in <= '0';
			wait for 104000 ns ;--5
			rx_data_in <= '0';
			wait for 104000 ns;--6
			rx_data_in <= '1';
			wait for 104000 ns ;--7
			rx_data_in <= '0';       
			wait for 104000 ns;--8
			rx_data_in <= '0';
			wait for 104000 ns;--odd parity
			rx_data_in <= '1';
			wait for 104000 ns ; --stop 
			rx_data_in <= '1';
			wait for 104000*2 ns ;
			assert ( rx_data_out = "00100110")
				report "data does not match expected,data out = " & integer'image(to_integer(unsigned(rx_data_out)))
			severity failure; 
			report "=========================== Test 6 Passed ===========================";
		
		-- Test 7
			report "=========================== Begin Test 7 ===========================";
			report "Test 7: data in = 00000111, parity check = odd (bit = 0)";
			rx_data_in <= '0'; --start
			wait for 104000 ns ;--1
			rx_data_in <= '1';
			wait for 104000 ns ;--2
			rx_data_in <= '1';
			wait for 104000 ns ;--3
			rx_data_in <= '1';
			wait for 104000 ns ;--4
			rx_data_in <= '0';
			wait for 104000 ns ;--5
			rx_data_in <= '0';
			wait for 104000 ns;--6
			rx_data_in <= '0';
			wait for 104000 ns ;--7
			rx_data_in <= '0';       
			wait for 104000 ns;--8
			rx_data_in <= '0';
			wait for 104000 ns;--odd parity
			rx_data_in <= '1';
			wait for 104000 ns ; --stop 
			rx_data_in <= '1';
			wait for 104000*2 ns ;
			assert ( rx_data_out = "00000111")
				report "data does not match expected,data out = " & integer'image(to_integer(unsigned(rx_data_out)))
			severity failure; 
			report "=========================== Test 7 Passed ===========================";

		-- Test 8
			report "=========================== Begin Test 8 ===========================";
			report "Test 8: data in = 10101010, parity check = even (bit = 1)";
			rx_data_in <= '0'; --start
			wait for 104000 ns ;--1
			rx_data_in <= '0';
			wait for 104000 ns ;--2
			rx_data_in <= '1';
			wait for 104000 ns ;--3
			rx_data_in <= '0';
			wait for 104000 ns ;--4
			rx_data_in <= '1';
			wait for 104000 ns ;--5
			rx_data_in <= '0';
			wait for 104000 ns;--6
			rx_data_in <= '1';
			wait for 104000 ns ;--7
			rx_data_in <= '0';       
			wait for 104000 ns;--8
			rx_data_in <= '1';
			wait for 104000 ns;--even parity
			rx_data_in <= '0';
			wait for 104000 ns ; --stop 
			rx_data_in <= '1';
			wait for 104000*2 ns ;
			assert ( rx_data_out = "10101010")
				report "data does not match expected,data out = " & integer'image(to_integer(unsigned(rx_data_out)))
			severity failure; 
			report "=========================== Test 8 Passed ===========================";
			
		-- Test 9
			report "=========================== Begin Test 9 ===========================";
			report "Test 9: data in = 11110000, parity check = even (bit = 1)";
			rx_data_in <= '0'; --start
			wait for 104000 ns ;--1
			rx_data_in <= '0';
			wait for 104000 ns ;--2
			rx_data_in <= '0';
			wait for 104000 ns ;--3
			rx_data_in <= '0';
			wait for 104000 ns ;--4
			rx_data_in <= '0';
			wait for 104000 ns ;--5
			rx_data_in <= '1';
			wait for 104000 ns;--6
			rx_data_in <= '1';
			wait for 104000 ns ;--7
			rx_data_in <= '1';       
			wait for 104000 ns;--8
			rx_data_in <= '1';
			wait for 104000 ns;--even parity
			rx_data_in <= '0';
			wait for 104000 ns ; --stop 
			rx_data_in <= '1';
			wait for 104000*2 ns ;
			assert ( rx_data_out = "11110000")
				report "data does not match expected,data out = " & integer'image(to_integer(unsigned(rx_data_out)))
			severity failure; 
			report "=========================== Test 9 Passed ===========================";
			
		-- Test 10
			report "=========================== Begin Test 10 ===========================";
			report "Test 10: data in = 01011100, parity check = odd (bit = 0)";
			rx_data_in <= '0'; --start
			wait for 104000 ns ;--1
			rx_data_in <= '0';
			wait for 104000 ns ;--2
			rx_data_in <= '0';
			wait for 104000 ns ;--3
			rx_data_in <= '1';
			wait for 104000 ns ;--4
			rx_data_in <= '1';
			wait for 104000 ns ;--5
			rx_data_in <= '1';
			wait for 104000 ns;--6
			rx_data_in <= '0';
			wait for 104000 ns ;--7
			rx_data_in <= '1';       
			wait for 104000 ns;--8
			rx_data_in <= '0';
			wait for 104000 ns;--odd parity
			rx_data_in <= '0';
			wait for 104000 ns ; --stop 
			rx_data_in <= '1';
			wait for 104000*2 ns ;
			assert ( rx_data_out = "01011100")
				report "data does not match expected,data out = " & integer'image(to_integer(unsigned(rx_data_out)))
			severity failure; 
			report "=========================== Test 10 Passed ===========================";


			report "========================== ALL TESTS PASSED ==========================";


		wait;
	end process;

end architecture;