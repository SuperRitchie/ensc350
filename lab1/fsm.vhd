library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity fsm is
     port(
	     clk: in std_logic;
		  rst: in std_logic;
		  reverse: in std_logic;
		  lcdRs: out std_logic;
		  data: out std_logic_vector(7 downto 0);
		  ledG: out std_logic_vector(7 downto 0);
		  ledCounter: out std_logic_vector(7 downto 0);
		  Hex0: out std_logic_vector(6 downto 0); -- One digit of the HEX display
        Hex1: out std_logic_vector(6 downto 0));  -- The other digit of the HEX display
end fsm;


architecture behavioural of fsm is
			
		  type stateType is (rst1, rst2, rst3, rst4, rst5, rst6, R, I, T, C, H);
		  signal currState : stateType;
		  signal counter : integer := 0;
		  signal pressed : std_logic;
		  
		   type hex_array is array(0 to 9) of std_logic_vector(6 downto 0);
    constant HEX_CODES: hex_array := (
        "1000000", -- 0
        "1111001", -- 1
        "0100100", -- 2
        "0110000", -- 3
        "0011001", -- 4
        "0010010", -- 5
        "0000010", -- 6
        "1111000", -- 7
        "0000000", -- 8
        "0010000" -- 9
		  );
		begin
	

		       -- Your state machine goes here
		process(currState, reverse, clk)
		begin
		
				
			--KEY 3 broken
			if ((rst = '0') and (pressed = '0')) then    ---change 21 to desired number for one or two lines of lcd
					currState <= rst1;
					counter <= 0; 
					pressed <= '1';
			elsif (counter > 16) then
				currState <= rst1;
				counter <= 0;
				
			elsif(rising_edge(clk)) then
							
			

			  case currState is
					when rst1 =>
						data <= "00111000";
						currState <= rst2;
								  lcdRs <= '0';
								  ledG <= "00000000";

					when rst2 =>
						data <= "00111000";
						currState <= rst3;
								  lcdRs <= '0';
								  ledG <= "00000000";

					when rst3 => 
						data <= "00001100";
						currState <= rst4;
								lcdRs <= '0'; 
								ledG <= "00000000";

					when rst4 =>
						data <= "00000001";
						currState <= rst5;
						lcdRs <= '0'; 
						ledG <= "00000000";

					when rst5 =>
						data <= "00000110";
						currState <= rst6;
						lcdRs <= '0'; 
						ledG <= "00000000";

					when rst6 =>
						data <= "10000000";
						currState <= R;
						lcdRs <= '0'; 
						if (pressed = '1') then
							pressed <= '0';
						end if;
						ledG <= "00000000";
						counter <= counter + 1;

					when R =>
					counter <= counter + 1;
						data <= "01010010";
						lcdRs <= '1'; 
						ledG <= "00000001";
						if (reverse = '0') then
							currState <= I;
						else
							currState <= H;
						end if;
											--ledCounter <= std_logic_vector(to_unsigned(counter, 8));

					when I =>
					counter <= counter + 1;
						data <= "01001001";
						lcdRs <= '1'; 
						ledG <= "00000010";

						if (reverse = '0') then
							currState <= T;
						else
							currState <= R;
						end if;
											--ledCounter <= std_logic_vector(to_unsigned(counter, 8));

					when T => 
					counter <= counter + 1;
						data <= X"54";
																		  lcdRs <= '1'; 
																							ledG <= "00000100";


						if (reverse = '0') then
							currState <= C;
						else
							currState <= I;
						end if;
											--ledCounter <= std_logic_vector(to_unsigned(counter, 8));

					when C =>
					counter <= counter + 1;
						data <= X"43";
																		  lcdRs <= '1'; 
																							ledG <= "00001000";


						if (reverse = '0') then
							currState <= H;
						else
							currState <= T;
						end if;
											--ledCounter <= std_logic_vector(to_unsigned(counter, 8));

					when H =>
					counter <= counter + 1;
						data <= X"48";
																		  lcdRs <= '1'; 
																							ledG <= "00010000";


						if (reverse = '0') then
							currState <= R;
						else
							currState <= C;
						end if;
											--ledCounter <= std_logic_vector(to_unsigned(counter, 8));

					end case;
					ledCounter <= std_logic_vector(to_unsigned(counter, 8));

					Hex0 <= HEX_CODES(counter mod 10); -- Ones digit
					Hex1 <= HEX_CODES((counter / 10) mod 10);  -- Tens digit
			end if;
		
		
		
		  
		end process;



		  

 
end behavioural;