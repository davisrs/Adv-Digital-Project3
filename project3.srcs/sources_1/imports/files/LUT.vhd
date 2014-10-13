--Based on an excellent example code posted at:
--http://stackoverflow.com/questions/21976749/design-of-a-vhdl-lut-module

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LUT is
    port (
        --- mapped 3=a, 2=b, 1=c, 0=d
        abcd : in std_logic_vector(3 downto 0);
        -- mapped x=2, y=1, z=0
        o_7segment_cat  : out std_logic_vector(7 downto 0)
    );
end LUT;

architecture any of LUT is
begin

    process (abcd) is
    begin
        case abcd is
        --ABCD|o_7segment_cat
        when x"0" => o_7segment_cat <= "00010001"; -- 0
        when x"1" => o_7segment_cat <= "10011111"; -- 1
        when x"2" => o_7segment_cat <= "00100101"; -- 2
        when x"3" => o_7segment_cat <= "00001101"; -- 3
        when x"4" => o_7segment_cat <= "10011001"; -- 4
        when x"5" => o_7segment_cat <= "01001001"; -- 5
        when x"6" => o_7segment_cat <= "01000001"; -- 6
        when x"7" => o_7segment_cat <= "00011111"; -- 7
        when x"8" => o_7segment_cat <= "00000001"; -- 8
        when x"9" => o_7segment_cat <= "00011001"; -- 9
        when x"A" => o_7segment_cat <= "00010001"; -- A
        when x"B" => o_7segment_cat <= "11000001"; -- B
        when x"C" => o_7segment_cat <= "01100011"; -- C
        when x"D" => o_7segment_cat <= "10000101"; -- D
        when x"E" => o_7segment_cat <= "01100001"; -- E
        when x"F" => o_7segment_cat <= "01110001"; -- F
        when others => o_7segment_cat <= "00010001"; -- 0
        end case;
        
    end process;
end architecture; 