library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use ieee.std_logic_unsigned.all;

entity clk_enabler is
	GENERIC (
		CONSTANT cnt_max : integer := 99999999);--The maximum number of clock cycles to wait for (forms a 1Hz output).      
	port(	
		clock		:in std_logic;
		sys_en		:in std_logic;
		clk_en		:out std_logic
	);
end clk_enabler;

----------------------------------------------------

architecture behv of clk_enabler is

signal clk_cnt	:integer range 0 to cnt_max; --Counts the number of clock cycles that have passed.
signal enable	:std_logic := '0'; --Sets whether the system is enabled or not (default 0).
	 
begin

	process(clock, sys_en)
	begin
	
	--Checks if the system enable button has been pressed and held for one second.
	if(sys_en = '0') then
		if(clk_cnt = cnt_max) then
			enable <= '1';
			clk_cnt <= 0; --Resetting the counter for the number of clock cycles.
		else
			clk_cnt <= clk_cnt + 1;
		end if;
	end if;
	
	
	--If enable is high, start counting, else do nothing.
	if(sys_en = '1')then
		if rising_edge(clock) then
		--if (clk_cnt = 49999999) then
        --If clk_cnt equals cnt_max then reset the count and send a clock pulse out.
        --Else the count is incremented and the output clock pulse is 0.
			if (clk_cnt = cnt_max) then
				clk_cnt <= 0;
				clk_en <= '1';
			else
				clk_cnt <= clk_cnt + 1;--Increment count if not at cnt_max.
				clk_en <= '0';
			end if;
		end if;
	end if;
	
	end process;

end behv;
