LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;

ENTITY Clock IS
PORT(    clkIn : IN std_logic;
        clkOut : OUT std_logic);
END Clock;

architecture behaviour of Clock is
signal delay: std_logic_vector(25 downto 0):= "00000000000000000000000000";

begin
    process(clkIn) is
    begin
     if (clkIn='1' AND clkIn'Event) then
         if (delay = "11111111111111111111111111") then
            delay <=  "00000000000000000000000000";
        else
            delay <= delay + "1";
        end if;
     end if;
    end process;
	 clkOut <= delay(delay'left);

    
end behaviour;