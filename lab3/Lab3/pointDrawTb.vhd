LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY pointDrawTb IS
END pointDrawTb;

ARCHITECTURE testBench of pointDrawTb IS
		component pointDraw is
  port (
    clk : in std_logic;
	 SW_X : in std_logic_vector(7 downto 0);
	 SW_Y : in std_logic_vector(6 downto 0);
    SW_Color : in std_logic_vector(2 downto 0);
	 color : out std_logic_vector(2 downto 0);
	 x : out std_logic_vector(7 downto 0);
	 y : out std_logic_vector(6 downto 0);
    draw : out std_logic
  
  );
		end component;
		
		constant clkHz : integer := 2e8;
		constant clkPeriod : time := 1 sec / clkHz;	--5ns 
		
		signal tbClk : std_logic := '1'; --intialize to 1
		signal  color, colorOut : std_logic_vector(2 downto 0);
		signal x, xOut : std_logic_vector(7 downto 0);
		signal y, yout : std_logic_vector(6 downto 0);
		signal drawOut : std_logic;
		
		
		begin
			DUT: pointDraw port map(clk => tbClk, SW_X => x, SW_Y => y, SW_Color => color, color => colorOut, x => xOut, y => yOut, draw => drawOut);
			
			tbClk <= NOT tbClk after clkPeriod / 2;	-- invert clock sig
		
		process
		begin
			color <= "000";
			x <= "00000000";
			y <= "0000000";
			
			wait for 5 ns;
			
			color <= "001";
			x <= "10011111"; --159
			y <= "1110111"; --119
			
			wait for 5 ns;
			
			color <= "010";
			x <= "00010100"; --20
			y <= "1011001"; -- 89
			
			wait for 5 ns;
			
			color <= "100";
			x <= "01101001"; -- 105
			y <= "0000101"; -- 5

			
			assert false;
			report "end simulation" severity failure;
			
		end process;
		
END testBench;