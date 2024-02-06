LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY fsm_tb IS
END fsm_tb;

ARCHITECTURE testBench of fsm_tb IS
		component fsm is
		  PORT(
				clk: in std_logic;
				rst: in std_logic;
				reverse: in std_logic;
				lcdRs: out std_logic;
				data: out std_logic_vector(7 downto 0);
				ledG: out std_logic_vector(7 downto 0);
						  Hex0: out std_logic_vector(6 downto 0); -- One digit of the HEX display
        Hex1: out std_logic_vector(6 downto 0));  -- The other digit of the HEX display
		end component;
		
		constant clkHz : integer := 2e8;
		constant clkPeriod : time := 1 sec / clkHz;	--5ns 
		
		signal tbClk : std_logic := '1'; --intialize to 1
		signal tbRst, tbReverse, tbLcdRs : std_logic;
		signal tbData, tbLedG : std_logic_vector(7 downto 0);
		signal tbHex0, tbHex1 : std_logic_vector(6 downto 0);
		
		begin
			DUT: fsm port map(clk => tbClk, rst => tbRst, reverse => tbReverse, lcdRs => tbLcdRs, data => tbData, ledG => tbLedG, Hex0 => tbHex0, Hex1 => tbHex1);
			
			tbClk <= NOT tbClk after clkPeriod / 2;	-- invert clock sig
		
		process
		begin
			tbRst <= '0';
			tbReverse <= '0';
			wait for 3 ns;
			tbRst <= '1';
			wait for 35 ns;
						
			tbReverse <= '1';
			wait for 35 ns;
			
			
			assert false;
			report "end simulation" severity failure;
			
		end process;
END testBench;