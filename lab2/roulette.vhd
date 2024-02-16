LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;

----------------------------------------------------------------------
--
--  This is the top level template for Lab 02.  Use the schematic on Page 3
--  of the lab handout to guide you in creating this structural description.
--  The combinational blocks have already been designed in previous tasks,
--  and the spinwheel block is given to you.  Your task is to combine these
--  blocks, as well as add the various registers shown on the schemetic, and
--  wire them up properly.  The result will be a roulette game you can play
--  on your DE2.
--
-----------------------------------------------------------------------

ENTITY roulette IS
	PORT(   CLOCK_50 : IN STD_LOGIC; -- the fast clock for spinning wheel
		KEY : IN STD_LOGIC_VECTOR(3 downto 0);  -- includes slow_clock and reset
		SW : IN STD_LOGIC_VECTOR(17 downto 0);
		LEDG : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  -- ledg
		HEX7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 7
		HEX6 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 6
		HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 5
		HEX4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 4
		HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 3
		HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 2
		HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 1
		HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- digit 0
	);
END roulette;


ARCHITECTURE structural OF roulette IS
	signal slowClk, bet1WinSig, bet2WinSig, bet3WinSig : std_logic;
	signal spinResultSig, spinResultLatched, bet1ValueSig : unsigned(5 downto 0);
	--signal bet2ColourSig : unsigned(0 downto 0);
		signal bet2ColourSig : std_logic;

	signal bet3DozenSig : unsigned(1 downto 0);
	signal bet1AmountSig, bet2AmountSig, bet3AmountSig : unsigned(2 downto 0);
	signal newMoneySig, moneySig : unsigned(11 downto 0);
	
	-- Signals for decimal digits
   signal thousands, hundreds, tens, ones: unsigned(3 downto 0);
	signal tens_digit, ones_digit: unsigned(3 downto 0);
	
	component win is
		PORT(spin_result_latched : in unsigned(5 downto 0);  -- result of the spin (the winning number)
             bet1_value : in unsigned(5 downto 0); -- value for bet 1
             bet2_colour : in std_logic;  -- colour for bet 2
             bet3_dozen : in unsigned(1 downto 0);  -- dozen for bet 3
             bet1_wins : out std_logic;  -- whether bet 1 is a winner
             bet2_wins : out std_logic;  -- whether bet 2 is a winner
             bet3_wins : out std_logic); -- whether bet 3 is a winner
	end component;
	
	component new_balance is
	  PORT(money : in unsigned(11 downto 0);  -- Current balance before this spin
       value1 : in unsigned(2 downto 0);  -- Value of bet 1
       value2 : in unsigned(2 downto 0);  -- Value of bet 2
       value3 : in unsigned(2 downto 0);  -- Value of bet 3
       bet1_wins : in std_logic;  -- True if bet 1 is a winner
       bet2_wins : in std_logic;  -- True if bet 2 is a winner
       bet3_wins : in std_logic;  -- True if bet 3 is a winner
       new_money : out unsigned(11 downto 0));  -- balance after adding winning
                                                -- bets and subtracting losing bets
	end component;
	
	component debounce is
	  generic (
		timeout_cycles : positive := 20
		);
	  port (
		 clk : in std_logic;
		 switch : in std_logic;
		 switch_debounced : out std_logic
	  );
	end component;
	
	component registerGeneral is
	  generic (numBits : positive);
	  port (
		 clk : in std_logic;
		 d : in unsigned(numBits downto 0);
		 rst: in std_logic;
		 q : out unsigned(numBits downto 0)
	  );	
	end component;
	
	component spinwheel is 
		PORT(
		fast_clock : IN  STD_LOGIC;  -- This will be a 27 Mhz Clock
		resetb : IN  STD_LOGIC;      -- asynchronous reset
		spin_result  : OUT UNSIGNED(5 downto 0));  -- current value of the wheel
	end component;
	
	component digit7seg is 
		PORT(
          digit : IN  UNSIGNED(3 DOWNTO 0);  -- number 0 to 0xF
          seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)  -- one per segment
		);
	end component;
	
	begin
		LEDG(0) <= bet1WinSig;
		LEDG(1) <= bet2WinSig;
		LEDG(2) <= bet3WinSig;
		
		HEX5 <= "1111111";
		HEX4 <= "1111111";

		--LEDG(0) <= '1';
		--LEDG(1) <= '1';
		--LEDG(2) <= '1';
		
		--HEX4 <= "1111111";
				
		key0: debounce port map (clk => CLOCK_50, switch => NOT KEY(0), switch_debounced => slowClk);
		
		wheel: spinwheel port map (fast_clock => CLOCK_50, resetb => KEY(1), spin_result => spinResultSig);
		
		sixBitReg1: registerGeneral generic map (5) port map (clk => slowClk, rst => KEY(1), d => spinResultSig, q => spinResultLatched); 
		
		sixBitReg2: registerGeneral generic map (5) port map (clk => slowClk, rst => KEY(1), d => unsigned(SW(8 downto 3)), q => bet1ValueSig); 

		dff: registerGeneral generic map (1) port map (clk => slowClk, rst => KEY(1), d(0) => SW(12), q(0) => bet2ColourSig); 
		
		twoBitReg: registerGeneral generic map (1) port map (clk => slowClk, rst => KEY(1), d => unsigned(SW(17 downto 16)), q => bet3DozenSig);
		
		winLogic: win port map (spin_result_latched => spinResultLatched, bet1_value => bet1ValueSig, bet2_colour => bet2ColourSig, bet3_dozen => bet3DozenSig, bet1_wins => bet1WinSig, bet2_wins => bet2WinSig, bet3_wins => bet3WinSig);
		
		-- Calculate tens and ones digits for display
		-- The value of spinResultLatched will never exceed 36, so direct division and modulus can be used
		tens_digit <= to_unsigned(to_integer(spinResultLatched) / 10, 4);
		ones_digit <= to_unsigned(to_integer(spinResultLatched) mod 10, 4);

		-- Map the calculated digits to the 7-segment displays
		hex_7: digit7seg port map (digit => tens_digit, seg7 => HEX7); -- Tens place
		
		hex_6: digit7seg port map (digit => ones_digit, seg7 => HEX6); -- Ones place
		
		threeBitReg1: registerGeneral generic map (2) port map (clk => slowClk, rst => KEY(1), d => unsigned(SW(2 downto 0)), q => bet1AmountSig);
		
		threeBitReg2: registerGeneral generic map (2) port map (clk => slowClk, rst => KEY(1), d => unsigned(SW(11 downto 9)), q => bet2AmountSig);
		
		threeBitReg3: registerGeneral generic map (2) port map (clk => slowClk, rst => KEY(1), d => unsigned(SW(15 downto 13)), q => bet3AmountSig);

		twelveBitReg: register12 port map (clk => slowClk, rst => KEY(1), d => newMoneySig, q => moneySig);
		
		newBal: new_balance port map (money => moneySig, value1 => bet1AmountSig, value2 => bet2AmountSig, value3 => bet3AmountSig, bet1_wins => bet1WinSig, bet2_wins => bet2WinSig, bet3_wins => bet3WinSig, new_money => newMoneySig);

		
    -- Arithmetic operations to extract each decimal digit from newMoneySig
    thousands <= to_unsigned((to_integer(newMoneySig) / 1000), 4);
    hundreds <= to_unsigned((to_integer(newMoneySig) mod 1000) / 100, 4);
    tens <= to_unsigned((to_integer(newMoneySig) mod 100) / 10, 4);
    ones <= to_unsigned(to_integer(newMoneySig) mod 10, 4);

    -- Map these signals directly to the 7-segment display inputs
    hex_3: digit7seg port map (digit => thousands, seg7 => HEX3);
    hex_2: digit7seg port map (digit => hundreds, seg7 => HEX2);
    hex_1: digit7seg port map (digit => tens, seg7 => HEX1);
    hex_0: digit7seg port map (digit => ones, seg7 => HEX0);
		
END;
