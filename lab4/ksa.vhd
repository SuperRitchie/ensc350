library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity part of the description.  Describes inputs and outputs

entity ksa is
  port(CLOCK_50 : in  std_logic;  -- Clock pin
       KEY : in  std_logic_vector(3 downto 0);  -- push button switches
       SW : in  std_logic_vector(17 downto 0);  -- slider switches
		 LEDG : out std_logic_vector(7 downto 0);  -- green lights
		 LEDR : out std_logic_vector(17 downto 0));  -- red lights
end ksa;

-- Architecture part of the description

architecture rtl of ksa is

   -- Declare the component for the ram.  This should match the entity description 
	-- in the entity created by the megawizard. If you followed the instructions in the 
	-- handout exactly, it should match.  If not, look at s_memory.vhd and make the
	-- changes to the component below
	
   COMPONENT s_memory IS
	   PORT (
		   address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		   clock		: IN STD_LOGIC  := '1';
		   data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		   wren		: IN STD_LOGIC ;
		   q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
   END component;
	
	component ROM is
			PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
	end component;
	
	component RAM is 
		PORT
	(
		address		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
	end component;

	-- Enumerated type for the state variable.  You will likely be adding extra
	-- state names here as you complete your design
	
	type state_type is (state_init, 
   	 					  state_done,
							  read1,
							  read2,
							  write1,
							  write2,
							  wait1,
							  wait2,
							  wait3,
							  wait4,
							  wait5,
							  wait6,
							  wait7,
							  wait8,
							  wait9,
							  wait10,
							  wait11,
							  state1,
							  state2,
							  state3,
							  state4,
							  state5,
							  state6,
							  state7);
	signal curr_state : state_type;

	
								
    -- These are signals that are used to connect to the memory													 
	 signal address : STD_LOGIC_VECTOR (7 DOWNTO 0);	 
	 signal data : STD_LOGIC_VECTOR (7 DOWNTO 0);
	 signal wren : STD_LOGIC;
	 signal q : STD_LOGIC_VECTOR (7 DOWNTO 0);	
	 
	 signal dAddress : STD_LOGIC_VECTOR (7 DOWNTO 0);	 
	 signal dData : STD_LOGIC_VECTOR (7 DOWNTO 0);
	 signal dWren : STD_LOGIC;
	 signal dQ : STD_LOGIC_VECTOR (7 DOWNTO 0);
	 
	 signal eAddress : STD_LOGIC_VECTOR (7 DOWNTO 0);	 
	 signal eQ : STD_LOGIC_VECTOR (7 DOWNTO 0);

	 begin
	    -- Include the S memory structurally
	
       u0: s_memory port map (
	        address, CLOCK_50, data, wren, q);
			  
		 r1: RAM port map (dAddress, CLOCK_50, dData, dWren, dQ);
		 
		 r2: ROM port map (eAddress, CLOCK_50, eQ);
			  
       -- write your code here.  As described in teh slide set, this 
       -- code will drive the address, data, and wren signals to
       -- fill the memory with the values 0...255
         
       -- You will be likely writing this is a state machine. Ensure
       -- that after the memory is filled, you enter a DONE state which
       -- does nothing but loop back to itself. 

	process(CLOCK_50)
			variable counter : unsigned(8 downto 0) := "000000000";
	variable i : unsigned(8 downto 0) := "000000000";
	variable secretKeyIndex : unsigned(7 downto 0);
	variable secretKeyByte : unsigned(7 downto 0);
	variable secret_key : unsigned(23 downto 0);
	variable sTempi, sTempj, j : unsigned(7 downto 0);
	variable timer : integer := 0;
	variable temp1 : unsigned(7 downto 0);
	variable temp2 : unsigned(7 downto 0);
	variable k, f, input : unsigned(7 downto 0) := "00000000";

	begin
		if (rising_edge(CLOCK_50)) then
			 case curr_state is
				when state_init =>
						address <= std_logic_vector(counter(7 downto 0));
						data <= std_logic_vector(counter(7 downto 0));
						wren <= '1';
						counter := counter + 1;
					if counter = 256 then
						curr_state <= wait1;
						i := "000000000";
						j := "00000000";
						secret_key(17 downto 0) := unsigned(SW(17 downto 0));
					end if;
				when wait1 =>
					wren <= '0';
					if (timer = 0) then
						curr_state <= read1;
						timer := 0;
					else
						timer := timer + 1;
					end if;

				when read1 =>
					curr_state <= wait2;
					
					secretKeyIndex := to_unsigned((to_integer(i(7 downto 0)) mod 3), 8);
					

					
					if secretKeyIndex = 0 then
						secretKeyByte := secret_key(23 downto 16);
					elsif secretKeyIndex = 1 then
						secretKeyByte := secret_key(15 downto 8);
					elsif secretKeyIndex = 2 then
						secretKeyByte := secret_key(7 downto 0);
					else
						secretKeyByte := "11111111";
					end if;

					temp1 := j + secretKeyByte;
					wren <= '0';
					address <= std_logic_vector(i(7 downto 0));
					LEDG(1) <= '1';
				when wait2 =>
					if (timer = 0) then
						curr_state <= read2;
						timer := 0;
					else
						timer := timer + 1;
					end if;
				when read2 =>
					curr_state <= wait3;
					LEDR(7 downto 0) <= std_logic_vector(temp1);

					sTempi := unsigned(q);
					temp2 := temp1 + sTempi;

					j := to_unsigned((to_integer(temp2) mod 256), 8);
					
					wren <= '0';
					address <= std_logic_vector(j);
					
				when wait3 =>
					if (timer = 0) then
						curr_state <= write1;
						timer := 0;
					else
						timer := timer + 1;
					end if;
				when write1 =>
					sTempj := unsigned(q);
					
					wren <= '1';
					address <= std_logic_vector(i(7 downto 0));
					data <= std_logic_vector(sTempj);
					
					curr_state <= wait4;
				when wait4 => 
					if (timer = 0) then
						curr_state <= write2;
						timer := 0;
					else
						timer := timer + 1;
					end if;
				when write2 => 
					curr_state <= read1;
					wren <= '1';
					
					address <= std_logic_vector(j);
					data <= std_logic_vector(sTempi);
					i := i + 1;
						
					if i = 256 then
						wren <= '0';
						curr_state <= wait5;
						i := "000000000";
						j := "00000000";
					end if;
				when wait5 => 
					if (timer = 0) then
						curr_state <= state1;
						timer := 0;
					else
						timer := timer + 1;
					end if;		
				when state1 => 
					i := to_unsigned((to_integer(i + 1) mod 256), 9);
					address <= std_logic_vector(i(7 downto 0));
					wren <= '0';
					curr_state <= wait6;
				when wait6 => 
					if (timer = 0) then
						curr_state <= state2;
						timer := 0;
					else
						timer := timer + 1;
					end if;
				when state2 =>
					sTempi := unsigned(q);
					j := to_unsigned((to_integer(j + sTempi) mod 256), 8);
					address <= std_logic_vector(j);
					wren <= '0';
					curr_state <= wait7;
				when wait7 => 
					if (timer = 0) then
						curr_state <= state3;
						timer := 0;
					else
						timer := timer + 1;
					end if;
				when state3 =>
					sTempj := unsigned(q);
					
					wren <= '1';
					address <= std_logic_vector(i(7 downto 0));
					data <= std_logic_vector(sTempj);
					
					curr_state <= wait8;
				when wait8 => 
					if (timer = 0) then
						curr_state <= state4;
						timer := 0;
					else
						timer := timer + 1;
					end if;
				when state4 => 
					curr_state <= wait9;
					wren <= '1';
					
					address <= std_logic_vector(j);
					data <= std_logic_vector(sTempi);						
				when wait9 => 
					if (timer = 0) then
						curr_state <= state5;
						timer := 0;
					else
						timer := timer + 1;
					end if;
				when state5 =>
					address <= std_logic_vector(to_unsigned((to_integer(sTempi + sTempj) mod 256), 8));
					wren <= '0';
					curr_state <= wait10;
					dWren <= '0';

				when wait10 => 
					if (timer = 0) then
						curr_state <= state6;
						timer := 0;
					else
						timer := timer + 1;
					end if;
				when state6 =>
					f := unsigned(q);
					eAddress <= std_logic_vector(k);
					curr_state <= wait11;
					dWren <= '0';
				when wait11 => 
					if (timer = 0) then
						curr_state <= state7;
						timer := 0;
					else
						timer := timer + 1;
					end if;	
				when state7 =>
					curr_state <= wait5;
					
					input := unsigned(eQ);
					f := f XOR input;
					dAddress <= std_logic_vector(k);
					dData <= std_logic_vector(f);
					dWren <= '1';
					k := k + 1;
					
					if (k = 32) then
						dWren <= '0';
						curr_state <= state_done;
					end if;
				when state_done =>
					
					wren <= '0';
					LEDG(0) <= '1';
			 end case;
		end if;
	end process;


end RTL;


