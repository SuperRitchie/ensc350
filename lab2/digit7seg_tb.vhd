LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

LIBRARY WORK;
USE WORK.ALL;

ENTITY digit7seg_tb IS
END digit7seg_tb;

ARCHITECTURE behavior OF digit7seg_tb IS

    COMPONENT digit7seg
        PORT(
            digit : IN  UNSIGNED(3 DOWNTO 0);
            seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
        );
    END COMPONENT;

    signal test_failed : boolean := false; -- Flag to track test failures
    SIGNAL digit : UNSIGNED(3 DOWNTO 0);
    SIGNAL seg7 : STD_LOGIC_VECTOR(6 DOWNTO 0);

    TYPE test_case_record IS RECORD
        input_digit : UNSIGNED(3 DOWNTO 0);
        expected_output : STD_LOGIC_VECTOR(6 DOWNTO 0);
    END RECORD;

    TYPE test_case_array IS ARRAY (natural range <>) OF test_case_record;

    CONSTANT test_cases : test_case_array := (
        (x"0", "1000000"), -- 0
        (x"1", "1111001"), -- 1
        (x"2", "0100100"), -- 2
        (x"3", "0110000"), -- 3
        (x"4", "0011001"), -- 4
        (x"5", "0010010"), -- 5
        (x"6", "0000010"), -- 6
        (x"7", "1111000"), -- 7
        (x"8", "0000000"), -- 8
        (x"9", "0010000"), -- 9
        (x"A", "0001000"), -- A
        (x"B", "0000011"), -- b
        (x"C", "1000110"), -- C
        (x"D", "0100001"), -- d
        (x"E", "0000110"), -- E
        (x"F", "0001110")  -- F
    );


BEGIN

    DUT: digit7seg PORT MAP (
        digit => digit,
        seg7 => seg7 
    );

    TEST : PROCESS
    begin
        for i in test_cases'range loop
            digit <= test_cases(i).input_digit;
            wait for 10 ns; -- Allow for signal propagation

            -- Report expected vs. actual output for each case, even if they match
            report "Test case " & integer'image(to_integer(test_cases(i).input_digit)) & 
                   ": expected " & integer'image((to_integer(unsigned(test_cases(i).expected_output)))) & 
                   ", got " & integer'image(to_integer(unsigned(seg7))) severity note;

            if seg7 /= test_cases(i).expected_output then
                test_failed <= true; -- Indicate a test failure
            end if;

            wait for 10 ns; -- Additional wait for clarity in simulation waveform
        end loop;

        if not test_failed then
            report "All tests passed." severity note;
        else
            report "Some tests failed." severity note;
        end if;

        wait; -- Halt the process
    end process TEST;

END behavior;
