library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab3 is
  port(CLOCK_50            : in  std_logic;
			LEDG					: out std_logic_vector(7 downto 0);
       KEY                 : in  std_logic_vector(3 downto 0);
       SW                  : in  std_logic_vector(17 downto 0);
       VGA_R, VGA_G, VGA_B : out std_logic_vector(9 downto 0);  -- The outs go to VGA controller
       VGA_HS              : out std_logic;
       VGA_VS              : out std_logic;
       VGA_BLANK           : out std_logic;
       VGA_SYNC            : out std_logic;
       VGA_CLK             : out std_logic);
end lab3;

architecture rtl of lab3 is

 --Component from the Verilog file: vga_adapter.v

  component vga_adapter
    generic(RESOLUTION : string);
    port (resetn                                       : in  std_logic;
          clock                                        : in  std_logic;
          colour                                       : in  std_logic_vector(2 downto 0);
          x                                            : in  std_logic_vector(7 downto 0);
          y                                            : in  std_logic_vector(6 downto 0);
          plot                                         : in  std_logic;
          VGA_R, VGA_G, VGA_B                          : out std_logic_vector(9 downto 0);
          VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC, VGA_CLK : out std_logic);
  end component;
  
    component debounce 
  generic (
    timeout_cycles : positive := 20
    );
  port (
    clk : in std_logic;
    switch : in std_logic;
    switch_debounced : out std_logic
  );
  end component;

  signal x      : std_logic_vector(7 downto 0);
  signal y      : std_logic_vector(6 downto 0);
  signal colour : std_logic_vector(2 downto 0);
  signal plot   : std_logic;
  
  signal enterBut : std_logic;
  signal finishSig : std_logic := '1';
  signal centerX : std_logic_vector(8 downto 0) := "001010000";
  signal centerY : std_logic_vector(8 downto 0) := "000111100";
  signal placeHolder : std_logic;
  
  signal pointXout, lineXout, triXout : std_logic_vector(7 downto 0);
  signal pointYout, lineYout, triYout : std_logic_vector(6 downto 0);
  signal pointPlot, linePlot, triPlot : std_logic;
  type stateType is (idle, lineStateRun);
  --type stateType is (idle, pointState, lineState);
  signal state : stateType := idle;
  type lineDrawingStates is (start);
    --type lineDrawingStates is (idle, start);

  signal currLineDrawState : lineDrawingStates;
	signal dx, dy, d, absdx, absdy : signed(8 downto 0);
	signal xInt, yInt, xEnd, yEnd : unsigned(8 downto 0);
	signal tri : std_logic;
	type triDrawingStates is (vertical, horizontal);
	signal currTriDrawState : triDrawingStates;
	    signal inputX : unsigned(8 downto 0);
    signal inputY : unsigned(8 downto 0);
	 signal copyStartY : unsigned(8 downto 0 );

begin

  -- includes the vga adapter, which should be in your project 

  vga_u0 : vga_adapter
    generic map(RESOLUTION => "160x120") 
    port map(resetn    => KEY(3),
             clock     => CLOCK_50,
             colour    => colour,
             x         => x,
             y         => y,
             plot      => plot,
             VGA_R     => VGA_R,
             VGA_G     => VGA_G,
             VGA_B     => VGA_B,
             VGA_HS    => VGA_HS,
             VGA_VS    => VGA_VS,
             VGA_BLANK => VGA_BLANK,
             VGA_SYNC  => VGA_SYNC,
             VGA_CLK   => VGA_CLK);


  -- rest of your code goes here, as well as possibly additional files
    enter: debounce port map (clk => CLOCK_50, switch => KEY(0), switch_debounced => enterBut);

  process(CLOCK_50)
  begin
  
  if rising_edge(CLOCK_50) then
		case state is 
			when idle => 
				if (KEY(0) = '0') then
					state <= lineStateRun;
				end if;
					xEnd(7 downto 0) <= unsigned(SW(17 downto 10));
					yEnd(6 downto 0) <= unsigned(SW(9 downto 3));
				
				--bressenham init
				dx <= abs(signed(xEnd)) - abs(signed(centerX));
				dy <= abs(signed(yEnd)) - abs(signed(centerY));
				absdx <= (ABS(dx));
				absdy <= (ABS(dy));
				
				xInt <= unsigned(centerX);
				yInt <= unsigned(centerY);
				
				if absdx > absdy then
					d <= (absdy sll 1) - absdx;
				else
					d <= (absdx sll 1) - absdy;
				end if;
				plot <= '0';
				LEDG(0) <= '0';
			when lineStateRun =>
				LEDG(0) <= '1';
				if (xInt = xEnd and yInt = yEnd) then
					state <= idle;
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
					plot <= '1';
				end if;

		end case;
--			when idle =>
--				if (KEY(1) = '0') then
--					--state <= lineStateIdle;
--					
--					xEnd(7 downto 0) <= unsigned(SW(17 downto 10));
--					yEnd(6 downto 0) <= unsigned(SW(9 downto 3));
--					
--					--bressenham init
--					dx <= abs(signed(xEnd)) - abs(signed(centerX));
--					dy <= abs(signed(yEnd)) - abs(signed(centerY));
--					absdx <= (ABS(dx));
--					absdy <= (ABS(dy));
--					
--					xInt <= unsigned(centerX);
--					yInt <= unsigned(centerY);
--					
--					if absdx > absdy then
--						d <= (absdy sll 1) - absdx;
--					else
--						d <= (absdx sll 1) - absdy;
--					end if;
--					plot <= '0';
--					--draw <= '0';
--					--finished <= '0';
--					state <= lineStartRun;
--				end if;
--				
----				if (KEY(0) = '0') then
----					state <= pointState;
----					--plot <= '1';
----					--LEDG(0) <= '1';
----				elsif (KEY(1) = '0') then
----					state <= lineStateIdle;
----					--currLineDrawState <= idle;
----					--plot <= '1';
----					tri <= '0';
----					
------						xEnd(7 downto 0) <= unsigned(SW(17 downto 10));
------						yEnd(6 downto 0) <= unsigned(SW(9 downto 3));
------						
------						--bressenham init
------						dx <= abs(signed(xEnd)) - abs(signed(centerX));
------						dy <= abs(signed(yEnd)) - abs(signed(centerY));
------						absdx <= (ABS(dx));
------						absdy <= (ABS(dy));
------						
------						xInt <= unsigned(centerX);
------						yInt <= unsigned(centerY);
------						
------						if absdx > absdy then
------							d <= (absdy sll 1) - absdx;
------						else
------							d <= (absdx sll 1) - absdy;
------						end if;
------						--draw <= '0';
------						finishSig <= '0';
------						currLineDrawState <= start;
----										--LEDG(1) <= '1';
------				elsif KEY(2) = '0' then
------					state <= lineState;
------					currLineDrawState <= start;
------					currTriDrawState <= vertical;
------					inputX(7 downto 0) <= unsigned(SW(17 downto 10));
------					inputY(6 downto 0) <= unsigned(SW(9 downto 3));
------					copyStartY <= unsigned(centerY);
------					--plot <= '1';
------					tri <= '1';
------										LEDG(2) <= '1';
----				
----				end if;
--				plot <= '0';
----			when pointState => -----------------------------------------------------------
----				x <= SW(17 downto 10);
----				y <= SW(9 downto 3);
----				colour <= SW(2 downto 0);
----				state <= idle;
----				plot <= '1';
--			when lineStateIdle => ---------------------------------------------------------------
--				--case currLineDrawState is 
----					when idle => 
--				xEnd(7 downto 0) <= unsigned(SW(17 downto 10));
--				yEnd(6 downto 0) <= unsigned(SW(9 downto 3));
--				
--				--bressenham init
--				dx <= abs(signed(xEnd)) - abs(signed(centerX));
--				dy <= abs(signed(yEnd)) - abs(signed(centerY));
--				absdx <= (ABS(dx));
--				absdy <= (ABS(dy));
--				
--				xInt <= unsigned(centerX);
--				yInt <= unsigned(centerY);
--				
--				if absdx > absdy then
--					d <= (absdy sll 1) - absdx;
--				else
--					d <= (absdx sll 1) - absdy;
--				end if;
--				plot <= '0';
--				--draw <= '0';
--				--finished <= '0';
--				state <= lineStartRun;
--			when lineStartRun =>
--					if (xInt = xEnd and yInt = yEnd) then
----							if (tri = '1') then
----								state <= triState;
----							else 
----								state <= idle;
----								--currLineDrawState <= idle;
----								LEDG(0) <= '1';
----								plot <= '0';
----							end if;
--						state <= idle;
--						--finishSig <= '1';
--					else
--						finishSig <= '0';
--						--bressenham alg
--						if absdx > absdy then
--							if dx < "00000000" then
--								xInt <= xInt - 1;
--							else
--								xInt <= xInt + 1;
--							end if;
--							if d < "0000000" then
--								d <= d + (absdy sll 1);
--							else
--								if dy < "00000000" then
--									yInt <= yInt - 1;
--								else
--									yInt <= yInt + 1;
--								end if;
--								d <= d + (absdy sll 1) - (absdx sll 1);
--							end if;
--						else 
--
--							if dy < "00000000" then
--								yInt <= yInt - 1;
--							else
--								yInt <= yInt + 1;
--							end if;
--							if d < "0000000" then
--								d <= d + (absdx sll 1);
--							else
--								if dx < "00000000" then
--									xInt <= xInt - 1;
--								else
--									xInt <= xInt + 1;
--								end if;
--								d <= d + (absdx sll 1) - (absdy sll 1);
--							end if;
--						end if;
--						x <= std_logic_vector(xInt(7 downto 0));
--						y <= std_logic_vector(yInt(6 downto 0));
--						colour <= SW(2 downto 0);
--						plot <= '1';
--
--						--draw <= '1';
--						--finished <= '0';
--					end if;
--
--			when triState => ------------------------------------------------------------------------
--				case currTriDrawState is
--					when vertical =>
--						 if (inputY = unsigned(centerY)) then
--							  currTriDrawState <= horizontal;
--						 else
--							  -- draw vertical line, determine if we need to go up or down
--							  if (inputY < unsigned(centerY)) then
--									inputY <= inputY + 1;
--							  else
--									inputY <= inputY - 1;
--							  end if;
--							  x <= std_logic_vector(inputX(7 downto 0));
--							  y <= std_logic_vector(inputY(6 downto 0));
--							    colour <= SW(2 downto 0);
--				plot <= '1';
--
--							  --draw <= '1';
--							  --finished <= '0';
--						 end if;
--					when horizontal =>
--						 if (inputX = unsigned(centerX)) then
--							  state <= idle;
--							  --finished <= '1';
--						 else
--							  -- draw vertical line, determine if we need to go up or down
--							  if (inputX < unsigned(centerX)) then
--									inputX <= inputX + 1;
--							  else
--									inputX <= inputX - 1;
--							  end if;
--							  x <= std_logic_vector(inputX(7 downto 0));
--							  y <= std_logic_vector(copyStartY(6 downto 0));
--							    colour <= SW(2 downto 0);
--								plot <= '1';
--
--							  --draw <= '1';
--							  --finished <= '0';
--						 end if;
--					end case;
--									LEDG(5) <= '1';

		--end case;
  end if;
  end process;
			


end RTL;


