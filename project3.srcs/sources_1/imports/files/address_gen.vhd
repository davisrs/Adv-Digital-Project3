----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/13/2014 06:44:42 PM
-- Design Name: 
-- Module Name: address_gen - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity address_gen is
    Port (
        step        :in std_logic;--Input from the 1 second counter.
        up_down     : in std_logic;--Input from the up/down switch (post debounce).
        addr        : out std_logic_vector (3 downto 0)--Output address.
     );
end address_gen;

architecture Behavioral of address_gen is


begin

    process(step, up_down)
    begin
    
    
    end process;

end Behavioral;
