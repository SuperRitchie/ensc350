library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab3Reference is
  port(CLOCK_50            : in  std_logic;
       KEY                 : in  std_logic_vector(3 downto 0);
       SW                  : in  std_logic_vector(17 downto 0);
       VGA_R, VGA_G, VGA_B : out std_logic_vector(9 downto 0);  -- The outs go to VGA controller
       VGA_HS              : out std_logic;
       VGA_VS              : out std_logic;
       VGA_BLANK           : out std_logic;
       VGA_SYNC            : out std_logic;
       VGA_CLK             : out std_logic);
end lab3Reference;

architecture rtl of lab3Reference is

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
  
    component draw
    port (
    clk : in std_logic;	-- clock 50
	 startX : in std_logic_vector(8 downto 0);
	 startY : in std_logic_vector(8 downto 0);
	 endX : in std_logic_vector(8 downto 0);
	 endY : in std_logic_vector(8 downto 0);
	 startDrawing : in std_logic_vector(3 downto 0); -- release this with a register to trigger a start
        colorIn : in std_logic_vector(2 downto 0);
        colorOut : out std_logic_vector(2 downto 0);
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
  signal placeHolder : std_logic := '1';
  
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
  
  program: draw port map (clk => CLOCK_50, startX => centerX, startY => centerY, endX(7 downto 0) => SW(17 downto 10), endY(6 downto 0) => SW(9 downto 3), startDrawing => KEY, x => x, y => y, draw => plot, finished => finishSig, colorIn => SW(2 downto 0), colorOut => colour);

   
			
end RTL;


