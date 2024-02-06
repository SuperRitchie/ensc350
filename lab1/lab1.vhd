library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;

entity lab1 is
     port(
	     CLOCK_50: in std_logic;
        KEY : in std_logic_vector(3 downto 0);  -- pushbutton switches
        SW : in std_logic_vector(8 downto 0);  -- slide switches
        LEDG : out std_logic_vector(7 downto 0); -- green LED's (you might want to use
                                                 -- this to display your current state)
		  LEDR : out std_logic_vector(7 downto 0);
        LCD_RW : out std_logic;  -- R/W control signal for the LCD
        LCD_EN : out std_logic;  -- Enable control signal for the LCD
        LCD_RS : out std_logic;  -- Whether or not you are sending an instruction or character
        LCD_ON : out std_logic;  -- used to turn on the LCD
        LCD_BLON : out std_logic; -- used to turn on the backlight
        LCD_DATA : out std_logic_vector(7 downto 0);  -- used to send instructions or characters
		  HEX0 : out std_logic_vector(6 downto 0);
		  HEX1 : out std_logic_vector(6 downto 0));
end lab1 ;


architecture logic of lab1 is

		  signal clkOutSig : std_logic := '0';
		  signal dataOut : std_logic_vector(7 downto 0);
		  signal led : std_logic_vector(7 downto 0);

        -- these are constant all the time.  Don't change these.
		
		component Clock is
			PORT(clkIn : IN std_logic;
				 clkOut : OUT std_logic);
		end component;
		
		
		component fsm is
		  PORT(
				clk: in std_logic;
				rst: in std_logic;
				reverse: in std_logic;
				lcdRs: out std_logic;
				data: out std_logic_vector(7 downto 0);
				ledG: out std_logic_vector(7 downto 0);
						  Hex0: out std_logic_vector(6 downto 0); -- One digit of the HEX display
        Hex1: out std_logic_vector(6 downto 0);  -- The other digit of the HEX display
				ledCounter: out std_logic_vector(7 downto 0));
				

		end component;
		
		begin
		
		  LCD_BLON <= '1';   -- backlight is always on
        LCD_ON <= '1';     -- LCD is always on
        LCD_EN <= clkOutSig;  -- connect the clock to the LCD_en input
        LCD_RW <= '0';     -- always writing to the LCD	
		  LCD_DATA <= dataOut;
		  
		  OBJ1: Clock port map (clkIn => CLOCK_50, clkOut => clkOutSig);
		  OBJ2: fsm port map (Hex0 => HEX0, Hex1 => HEX1, clk => clkOutSig, rst => KEY(2), reverse => SW(SW'RIGHT), lcdRs => LCD_RS, data => dataOut, ledG => LEDG, ledCounter => LEDR);


		     
		
 
end logic;