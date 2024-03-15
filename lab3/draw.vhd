library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity draw is
    port (
        clk : in std_logic; -- clock 50
        startX : in std_logic_vector(8 downto 0);
        startY : in std_logic_vector(8 downto 0);
        endX : in std_logic_vector(8 downto 0);
        endY : in std_logic_vector(8 downto 0);
        startDrawing : in std_logic_vector(3 downto 0); 
        colorIn : in std_logic_vector(2 downto 0);
        colorOut : out std_logic_vector(2 downto 0);
        x : out std_logic_vector(7 downto 0);
        y : out std_logic_vector(6 downto 0);
        draw : out std_logic;
        finished : out std_logic
    );
end draw;

architecture logic of draw is
    signal dx, dy, d, absdx, absdy : signed(8 downto 0);
    signal xInt, yInt, xEnd, yEnd : unsigned(8 downto 0);
    type stateType is (idle, start, verticalLine, horizontalLine, pointState, reset);
    signal state : stateType;
	 
    signal inputX : unsigned(8 downto 0);
    signal inputY : unsigned(8 downto 0);
	 signal copyStartY : unsigned(8 downto 0 );
	 signal tri : std_logic;
	 
	 signal xMax : unsigned(7 downto 0) := "10100000";
	 signal yMax : unsigned(6 downto 0) := "1111000"; 
	 signal xCord : unsigned(7 downto 0) := "00000000";
	 signal yCord : unsigned(6 downto 0) := "0000000";
	 	 
begin

process(clk, endX, startX, endY, startY, dx, dy)
begin
    if rising_edge(clk) then
        inputX <= unsigned(endX);
        inputY <= unsigned(endY);
		  copyStartY <= unsigned(startY);
        case state is
            when idle =>
					 tri <= '0';
                if (startDrawing(2) = '0') then
                    state <= start;
						  	tri <= '1';
                end if;
					 if (startDrawing(0) = '0') then
						  state <= pointState;
					 end if;
					 if (startDrawing(1) = '0') then
						  state <= start;
					 end if;
					 if (startDrawing(3) = '0') then
						  state <= reset;
					 end if;
					 
					 xCord <= "00000000";
					 yCord <= "0000000";


                xEnd <= unsigned(endX);
                yEnd <= unsigned(endY);
					 
					
                --bressenham init
                dx <= abs(signed(xEnd)) - abs(signed(startX));
                dy <= abs(signed(yEnd)) - abs(signed(startY));
                absdx <= (ABS(dx));
                absdy <= (ABS(dy));
                xInt <= unsigned(startX);
                yInt <= unsigned(startY);
                if absdx > absdy then
                    d <= (absdy sll 1) - absdx;
                else
                    d <= (absdx sll 1) - absdy;
                end if;
                draw <= '0';
                finished <= '0';
				when reset =>	
					if(xCord < xMax) then
						if(yCord < yMax) then
							x <= std_logic_vector(xCord);
							y <= std_logic_vector(yCord);
							colorOut <= "000";
							draw <= '1';
							yCord <= yCord + 1;
						else
							yCord <= "0000000";
							xCord <= xCord + 1;
						end if;
					else 
						state <= idle;
					end if;
					
				when pointState => -----------------------------------------------------------
					x <= endX(7 downto 0);
					y <= endY(6 downto 0);
					colorOut <= colorIn;
					state <= idle;
					draw <= '1';
            when start =>
                if (xInt = xEnd and yInt = yEnd) then
						  if tri = '1' then
							  state <= verticalLine; -- after the Bresselham algorithm is done, draw a vertical line from (xEnd, yEnd) to the center (80, 60)
						  else
							  state <= idle;
						  end if;
                else
                    --bressenham alg
                    if absdx > absdy then
                        if dx < "00000000" then
                            xInt <= xInt - 1;
                        else
                            xInt <= xInt + 1;
                        end if;
                        if d < "00000000" then
                            d <= d + (absdy sll 1);
                        else
                            if dy < "00000000" then
                                yInt <= yInt - 1;
                            else
                                yInt <= yInt + 1;
                            end if;
                            d <= d + (absdy sll 1) - (absdx sll 1);
                        end if;
                    else
                        if dy < "00000000" then
                            yInt <= yInt - 1;
                        else
                            yInt <= yInt + 1;
                        end if;
                        if d < "00000000" then
                            d <= d + (absdx sll 1);
                        else
                            if dx < "00000000" then
                                xInt <= xInt - 1;
                            else
                                xInt <= xInt + 1;
                            end if;
                            d <= d + (absdx sll 1) - (absdy sll 1);
                        end if;
                    end if;
                    x <= std_logic_vector(xInt(7 downto 0));
                    y <= std_logic_vector(yInt(6 downto 0));
						  	colorOut <= colorIn;
                    draw <= '1';
                    finished <= '0';
                end if;
            when verticalLine =>
                if (inputY = unsigned(startY)) then
                    state <= horizontalLine;
                else
                    -- draw vertical line, determine if we need to go up or down
                    if (inputY < unsigned(startY)) then
                        inputY <= inputY + 1;
                    else
                        inputY <= inputY - 1;
                    end if;
                    x <= std_logic_vector(inputX(7 downto 0));
                    y <= std_logic_vector(inputY(6 downto 0));
						  	colorOut <= colorIn;
                    draw <= '1';
                    finished <= '0';
                end if;
				when horizontalLine =>
					 if (inputX = unsigned(startX)) then
                    state <= idle;
                    finished <= '1';
                else
                    -- draw vertical line, determine if we need to go up or down
                    if (inputX < unsigned(startX)) then
                        inputX <= inputX + 1;
                    else
                        inputX <= inputX - 1;
                    end if;
                    x <= std_logic_vector(inputX(7 downto 0));
                    y <= std_logic_vector(copyStartY(6 downto 0));
						  colorOut <= colorIn;
                    draw <= '1';
                    finished <= '0';
                end if;
        end case;
    end if;
end process;
end architecture;