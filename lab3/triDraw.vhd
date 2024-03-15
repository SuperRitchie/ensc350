library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity triDraw is
  port (
    clk : in std_logic;	-- clock 50
	 startX : in std_logic_vector(8 downto 0);
	 startY : in std_logic_vector(8 downto 0);
	 startTri : in std_logic; -- release this with a register to trigger a start
	 x : out std_logic_vector(7 downto 0);
	 y : out std_logic_vector(6 downto 0);
    draw : out std_logic;
	 finished : out std_logic
  );
end triDraw ; 

architecture logic of triDraw is
	signal dx, dy, d, absdx, absdy : signed(8 downto 0);
	signal xInt, yInt, xEnd, yEnd : unsigned(8 downto 0);
	type stateType is (idle, start);
	signal state : stateType;
   signal centerX : std_logic_vector(8 downto 0) := "001010000";
   signal centerY : std_logic_vector(8 downto 0) := "000111100";
	signal endX, beginX : std_logic_vector(8 downto 0);
	signal endY, beginY : std_logic_vector(8 downto 0);
	signal stage : integer := -1;
begin

process(clk, endX, startX, endY, startY, dx, dy, stage)
begin 

		
	if rising_edge(clk) then
		
		case state is 
			when idle => 
				if (startTri = '0') then
					state <= start;
					stage <= 0;
				end if;
				
				if (stage = 0) then
					endX <= startX;
					endY <= startY;
					beginX <= centerX;	
					beginY <= centerY;
					state <= start;
				elsif (stage = 1) then
					endX <= startX;
					endY <= startY;
					beginX <= startX;	
					beginY <= centerY;
					state <= start;
				elsif (stage = 2) then
					endX <= startX;
					endY <= centerY;
					beginX <= centerX;	
					beginY <= centerY;
					state <= start;
				elsif (stage = 3) then
					stage <= -1;
				end if;
--				
--				endX <= startX;
--				endY <= startY;
--				beginX <= centerX;	
--				beginY <= centerY;
--					
				xEnd <= unsigned(endX);
				yEnd <= unsigned(endY);
				
				--bressenham init
				dx <= abs(signed(xEnd)) - abs(signed(beginX));
				dy <= abs(signed(yEnd)) - abs(signed(beginY));
				absdx <= (ABS(dx));
				absdy <= (ABS(dy));
				
				xInt <= unsigned(beginX);
				yInt <= unsigned(beginY);
				
				if absdx > absdy then
					d <= (absdy sll 1) - absdx;
				else
					d <= (absdx sll 1) - absdy;
				end if;
				draw <= '0';
				finished <= '0';				
			when start =>
				if (xInt = xEnd and yInt = yEnd) then
					state <= idle;
					finished <= '1';
					stage <= stage + 1;
				else
					--bressenham alg
					if absdx > absdy then
						if dx < "00000000" then
							xInt <= xInt - 1;
						else
							xInt <= xInt + 1;
						end if;
						--xInt <= xInt - 1 when dx < "0000000" else xInt + 1;
						if d < "0000000" then
							d <= d + (absdy sll 1);
						else
							if dy < "00000000" then
								yInt <= yInt - 1;
							else
								yInt <= yInt + 1;
							end if;
							--yInt <= yInt - 1 when dy < "0000000" else yInt + 1;
							d <= d + (absdy sll 1) - (absdx sll 1);
						end if;
					else 

						if dy < "00000000" then
							yInt <= yInt - 1;
						else
							yInt <= yInt + 1;
						end if;
						--yInt <= yInt - 1 when dy < "0000000" else yInt + 1;
						if d < "0000000" then
							d <= d + (absdx sll 1);
						else
							if dx < "00000000" then
								xInt <= xInt - 1;
							else
								xInt <= xInt + 1;
							end if;
							--xInt <= xInt - 1 when dx < "0000000" else xInt + 1;
							d <= d + (absdx sll 1) - (absdy sll 1);
						end if;
					end if;
					x <= std_logic_vector(xInt(7 downto 0));
					y <= std_logic_vector(yInt(6 downto 0));
					draw <= '1';
					finished <= '0';
				end if;

		end case;
	end if;
	
end process;
end architecture;