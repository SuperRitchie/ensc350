library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity  tx_tb is
end entity  tx_tb;

architecture sim of  tx_tb  is
	component txd is 
	generic(baudRate : integer := 5208);
	port(clk : in std_logic;
		  rst : in std_logic;
		  key : in std_logic;
		  data : in std_logic_vector(7 downto 0);
		  uart_cts : in std_logic;
		  uart_txd : out std_logic;
		  uart_rts : out std_logic);
	end component; 

	--Clock Params
	constant clk_hz : integer := 100e6;
	constant halfPeriod : time := 10 ns;
	constant clkPeriod : time := halfPeriod;
	
	signal clk: std_logic := '1';
	signal resetn: std_logic := '1';
	signal tx_data_in: std_logic_vector(7 downto 0) := (others => '0');
	signal tx_start : std_logic := '1';
	signal tx_data_out, tx_busy, tx_done, cts, rts: std_logic;

	begin
		-- Clock logic
		clk <= not clk after halfPeriod;
		
		DUT : txd
		port map (
			clk => clk,
			rst => resetn,
			data =>  tx_data_in,
			key => tx_start,
			uart_txd =>  tx_data_out,
			uart_rts => rts,
			uart_cts => cts
		);	
		
		
		SEQUENCER_PROC : process
			begin
			report "===========================start=================================";
			tx_start <= '0';
			cts <= '1';
		
			report "=========================== Test 1 ===============================";
			report "Test 1: data in = 01101101 parity bit = 1"; 
			tx_data_in <= "01101101"; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch" 
			severity failure;    
			wait for 104000 ns;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure;
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure;
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure;
			report "=========================== Test 1 Passed ==============================";
			
			wait for 104000 ns;
			tx_start <= '1';
			wait for 20 ns;
			tx_start <= '0';

			
			report "=========================== Test 2 ==============================";
			report "Test 2: data in = 00101101 parity bit = 0";
			tx_data_in <= "00101101"; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch" 
			severity failure;    
			wait for 104000 ns;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure;
			wait for 104000 ns;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure;
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure;			
			report "=========================== Test 2 Passed ===========================";
			
						wait for 104000 ns;
			tx_start <= '1';
			wait for 20 ns;
			tx_start <= '0';
		
			report "=========================== Test 3 ==============================";
			report "Test 3: data in = 11111111, parity bit = 0";
			tx_data_in <= "11111111"; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch" 
			severity failure;    
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure;
			wait for 104000 ns;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure;
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure;
			report "=========================== Test 3 Passed ==================================";
			
						wait for 104000 ns;
			tx_start <= '1';
			wait for 20 ns;
			tx_start <= '0';
		
	
			report "=========================== Test 4 =================================";
			report "Test 4: data in = 00000000, parity bit = 0";
			tx_data_in <= "00000000"; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ; 
			assert ( tx_data_out = '0')
			report "data mismatch" 
			severity failure;    
			wait for 104000 ns;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure;
			wait for 104000 ns;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure;
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure;
			report "=========================== Test 4 Passed ===============================";
						wait for 104000 ns;
			tx_start <= '1';
			wait for 20 ns;
			tx_start <= '0';
		
			report "=========================== Test 5 ==============================";
			report "Test 5: data in = 11001100, parity bit = 0";
			tx_data_in <= "11001100"; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ; 
			assert ( tx_data_out = '1')
			report "data mismatch" 
			severity failure;    
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure;
			wait for 104000 ns;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure;
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure;
			report "=========================== Test 5 Passed ===============================";

					wait for 104000 ns;
			tx_start <= '1';
			wait for 20 ns;
			tx_start <= '0';
			report "===========================  Test 6 ===============================";
			report "Test 6: data in = 00110011, parity bit = 1";
			tx_data_in <= "00110011"; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ; 
			assert ( tx_data_out = '0')
			report "data mismatch" 
			severity failure;    
			wait for 104000 ns;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure;
			wait for 104000 ns;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure;
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure;
			report "=========================== Test 6 Passed ================================";
		
					wait for 104000 ns;
			tx_start <= '1';
			wait for 20 ns;
			tx_start <= '0';
			report "=========================== Test 7 ===============================";
			report "Test 7: data in = 11100011, parity bit = 1";
			tx_data_in <= "11100011"; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ; 
			assert ( tx_data_out = '1')
			report "data mismatch" 
			severity failure;    
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure;
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure;
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure;
			report "=========================== Test 7 Passed ===============================";

					wait for 104000 ns;
			tx_start <= '1';
			wait for 20 ns;
			tx_start <= '0';
			report "=========================== Test 8 ==============================";
			report "Test 8: data in = 01010100, parity bit = 1";
			tx_data_in <= "01010100"; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ; 
			assert ( tx_data_out = '1')
			report "data mismatch" 
			severity failure;    
			wait for 104000 ns;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure;
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure;
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure;
			report "=========================== Test 8 Passed ==============================";
			
					wait for 104000 ns;
			tx_start <= '1';
			wait for 20 ns;
			tx_start <= '0';
			report "=========================== Test 9 ==============================";
			report "Test 9: data in = 10001110, parity bit = 0 ";
			tx_data_in <= "10001110"; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ; 
			assert ( tx_data_out = '0')
			report "data mismatch" 
			severity failure;    
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure;
			wait for 104000 ns;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure;
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure;
			report "=========================== Test 9 Passed ==============================";
			
					wait for 104000 ns;
			tx_start <= '1';
			wait for 20 ns;
			tx_start <= '0';
			report "=========================== Test 10 ==============================";
			report "Test 10: data in = 11110000, parity bit = 0";
			tx_data_in <= "11110000"; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure; 
			wait for 104000 ns ; 
			assert ( tx_data_out = '1')
			report "data mismatch" 
			severity failure;    
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure;
			wait for 104000 ns;
			assert ( tx_data_out = '0')
			report "data mismatch"
			severity failure;
			wait for 104000 ns;
			assert ( tx_data_out = '1')
			report "data mismatch"
			severity failure;
			wait for 104000 ns;
			report "=========================== Test 10 Passed ==============================";

			report "========================== All Tests Passed =============================";
			wait;

	end process;

end architecture;