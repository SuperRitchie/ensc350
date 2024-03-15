library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab3 is
  port(CLOCK_50            : in  std_logic;
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
  
  component pointDraw
    port (
    clk : in std_logic;
	 SW_X : in std_logic_vector(7 downto 0);
	 SW_Y : in std_logic_vector(6 downto 0);
    --SW_Color : in std_logic_vector(2 downto 0);
	 --color : out std_logic_vector(2 downto 0);
	 x : out std_logic_vector(7 downto 0);
	 y : out std_logic_vector(6 downto 0);
    draw : out std_logic
  );
  end component;
  
  component lineDraw
    port (
    clk : in std_logic;	-- clock 50
	 startX : in std_logic_vector(8 downto 0);
	 startY : in std_logic_vector(8 downto 0);
	 endX : in std_logic_vector(8 downto 0);
	 endY : in std_logic_vector(8 downto 0);
	 startDrawing : in std_logic; -- release this with a register to trigger a start
    --color : in std_logic_vector(2 downto 0);
	 --color : out std_logic_vector(2 downto 0);
	 x : out std_logic_vector(7 downto 0);
	 y : out std_logic_vector(6 downto 0);
    draw : out std_logic;
	 finished : out std_logic
  );
  end component;
  
    component moo
    port (
    clk : in std_logic;	-- clock 50
	 startX : in std_logic_vector(8 downto 0);
	 startY : in std_logic_vector(8 downto 0);
	 endX : in std_logic_vector(8 downto 0);
	 endY : in std_logic_vector(8 downto 0);
	 startDrawing : in std_logic; -- release this with a register to trigger a start
    --color : in std_logic_vector(2 downto 0);
	 --color : out std_logic_vector(2 downto 0);
	 x : out std_logic_vector(7 downto 0);
	 y : out std_logic_vector(6 downto 0);
    draw : out std_logic;
	 finished : out std_logic
  );
  end component;
  
  component triangle
	  port (
    clk : in std_logic;	-- clock 50
	 pointX : in std_logic_vector(7 downto 0);
	 pointY : in std_logic_vector(6 downto 0);
	 startTriangle : in std_logic; -- release this with a register to trigger a start
	 x : out std_logic_vector(7 downto 0);
	 y : out std_logic_vector(6 downto 0);
    sketch : out std_logic);
	 end component;
	 
	component triDraw
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
  end component;

  signal x      : std_logic_vector(7 downto 0);
  signal y      : std_logic_vector(6 downto 0);
  signal colour : std_logic_vector(2 downto 0);
  signal plot   : std_logic;
  
  signal enterBut : std_logic;
  signal finishSig : std_logic;
  signal centerX : std_logic_vector(8 downto 0) := "001010000";
  signal centerY : std_logic_vector(8 downto 0) := "000111100";
  signal placeHolder : std_logic;
  
  signal pointXout, lineXout, triXout : std_logic_vector(7 downto 0);
  signal pointYout, lineYout, triYout : std_logic_vector(6 downto 0);
  signal pointPlot, linePlot, triPlot : std_logic;
  type stateType is (pointState, lineState, triState);
  signal state : stateType;

begin

  -- includes the vga adapter, which should be in your project 

  vga_u0 : vga_adapter
    generic map(RESOLUTION => "160x120") 
    port map(resetn    => placeHolder,
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
  
  --x <= "00000001";
  --y <= "0000001";
  --colour <= "001";
  --plot <= '1';
  
  point: pointDraw port map (clk => KEY(0), SW_X => SW(17 downto 10), SW_Y => SW(9 downto 3), x => pointXout, y => pointYout, draw => pointPlot);
  
  centerLine: lineDraw port map (clk => CLOCK_50, startX => centerX, startY => centerY, endX(7 downto 0) => SW(17 downto 10), endY(6 downto 0) => SW(9 downto 3), startDrawing => KEY(1), x => lineXout, y => lineYout, draw => linePlot, finished => finishSig);
  
  --triDraw: triangle port map (clk => CLOCK_50, pointX => SW(17 downto 10), pointY => SW(9 downto 3), startTriangle => KEY(0), x => x, y => y, sketch => plot);

   --draw: triDraw port map (clk => CLOCK_50, startX(7 downto 0) => SW(17 downto 10), startY(6 downto 0) => SW(9 downto 3), startTri => KEY(0), x => x, y => y, draw => plot, finished => finishSig);

  mooo: moo port map (clk => CLOCK_50, startX => centerX, startY => centerY, endX(7 downto 0) => SW(17 downto 10), endY(6 downto 0) => SW(9 downto 3), startDrawing => KEY(2), x => triXout, y => triYout, draw => triPlot, finished => finishSig);

  
  colour <= SW(2 downto 0);
  
  process(KEY)
  begin
  if (KEY(0) ='0') then
	 state <= pointState;
	elsif KEY(1) = '0' then
		state <= lineState;
	elsif KEY(2) = '0' then
		state <= triState;
	end if;
	
	case state is 
		when pointState =>
			x <= pointXout;
			y <= pointYout;
			plot <= pointPlot;
		when lineState => 
			x <= lineXout;
			y <= lineYout;
			plot <= linePlot;
		when triState =>
			x <= triXout;
			y <= triYout;
			plot <= triPlot;
	end case;
	end process;
			


end RTL;


