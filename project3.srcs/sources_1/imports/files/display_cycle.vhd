library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
--This is a 20-bit counter, it uses the upper 3 bits to cycle through 4
--7-segment LED displays in the appropriate amount of time to prevent flicker.

--display_cycle port map.
entity display_cycle is
	generic(
		constant count_max 	: integer := 131072); --Defines the refresh rate of the 7-segment LED's.
	port(
		CLK					:in std_logic;-- The 100MHz clock on the Nexys 4.
		o_7segment_an		:out std_logic_vector(3 downto 0)-- The output of the counter that goes to the anodes
															 -- of the LED's.
		);
end display_cycle;
--End display_cycle port map.

--Start display_cycle's behaviour definition.
architecture behv of display_cycle is

--Can't use just the upper three bits, since they do not count in the correct sequence.
-- 000 001 010 011* 100 101* 110* 111
signal count	:integer range 0 to count_max;--An integer that can range from 0 to whatever count_max is defined as.
											  --count_max can be adjusted to change the rate at which the LED displays
											  --are refreshed. A higher count_max results in a longer refresh time.
begin

o_7segment_an <= "0001";-- Initially set the output bits to "0001".

	process(CLK)
	begin
		--Count on the rising edges of the 100MHz clock.
		if(rising_edge(CLK)) then
			--If the count = count_max then shift the output bits by 1 to the left and reset count to 0.
			--else increment count.
			if(count = count_max)then
				o_7segment_an <= shift_left(o_7segment_an);
				count <= 0;
				
				--If the output bits = "000" then reset them to be "001".
				if(o_7segment_an = "0000") then
					o_7segment_an <= "0001";
				end if;
			else	
				count <= count + 1;
			end if;
		end if;
	end process;
end behv;