library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

--top_level port map.

entity top_level is
		port ( 
		i_crystal_clk			: in std_logic; --The 100MHz crystal clock on the board.
		i_sys_enable			: in std_logic; --System enable, BTNR.	
		i_back_forward          : in std_logic; --Input that defines whether to step forward or backward in the sequence, BTNL.
		i_asynch_start			: in std_logic; --Input that asynchronously start the system stepping through states, BTNC.
		o_7segment_cat          : out std_logic_vector (7 downto 0); --Each of the cathodes on the 7 segment display including
		                                                            --decimal point stored as a vector.
		o_7segment_an           : out std_logic_vector (7 downto 0) --Each of the common anodes for the displays, elements of
		                                                            --the vector 4 through 7 are always 1.     
		);
end top_level;

--top_level structure and behavior.

architecture Structural of top_level is

--	--Defines the clock enabler, it creates a 1Hz signal in synchronization with the 100MHz crystal. 
--	component clk_enabler is
--            GENERIC (
--            CONSTANT cnt_max : integer     := 99999999);--Creates a 1 second counter.     	
--            port(	
--            clock						   : in std_logic;
--			sys_en					       : in std_logic;
--            clk_en					       : out std_logic
--            );
--	end component;
	
	component clk_enabler is
    	GENERIC (
    		CONSTANT cnt_max : integer := 99999999);--The maximum number of clock cycles to wait for (forms a 1Hz output).      
    	port(	
    		clock		:in std_logic;
    		sys_en		:in std_logic;
    		clk_en		:out std_logic
    	);
    end component;	
	
    
	--Defines the button debouncing circuit.
    component btn_debounce_toggle is
    GENERIC (
    CONSTANT CNTR_MAX : std_logic_vector(15 downto 0) := X"FFFF");
        Port ( BTN_I 	: in  STD_LOGIC;
               CLK 		: in  STD_LOGIC;
               BTN_O 	: out  STD_LOGIC;
               TOGGLE_O : out  STD_LOGIC);
    end component;    
	
	--Defining cycle_display, this component cycles through the right hand 7 segment displays.
	component display_cycle is
		generic(
		constant count_max 		: integer := 131072); --Defines the refresh rate of the 7-segment LED's.
		port(
		CLK						:in std_logic;
		o_7segment_an			:out std_logic_vector(3 downto 0)															   
		);
	end component;
	
	--Input/output signals.

	signal clk					    : std_logic;
	signal clk_enable			    : std_logic;
    signal i_sys_enable_deb         : std_logic;
    signal i_back_forward_deb       : std_logic;
    signal i_asynch_start_deb   	: std_logic; --Debounced button signals.
	signal anode_output_vector	    : std_logic_vector(3 downto 0);-- Output of the display_cycle is connected here.
    
    --------------------------------------
    --Begin defining top-level's behavior.
    -------------------------------------- 
     
	begin
	
	--Creating an instance of the button debouncer for the system enable.
	i_sys_enable_debounce : btn_debounce_toggle
	   generic map (CNTR_MAX => X"FFFF") -- For simulation: use CNTR_MAX => X"0009", else use X"FFFF"
	   port map(
	       BTN_I       => i_sys_enable,  --Input button linked to BTNR
	       CLK         => i_crystal_clk, --clock linked to the 100MHz clock.
	       BTN_O       => open,
	       TOGGLE_O    => i_sys_enable_deb); --Button output linked to the system enable signal after
           	                                 --it has been debounced. It uses a toggling state.
           	                                 
	--Creating an instance of the button debouncer for the asychronous system start.       
	i_asynch_start_debounce : btn_debounce_toggle
		generic map (CNTR_MAX => X"FFFF") -- For simulation: use CNTR_MAX => X"0009", else use X"FFFF"
    	   port map(
    	       BTN_I       => i_asynch_start,  --Input button linked to BTNC
    	       CLK         => i_crystal_clk, --clock linked to the 100MHz clock.
    	       BTN_O       => i_asynch_start_deb, --Button output linked to the system enable signal after
                              	                  --it has been debounced.
    	       TOGGLE_O    => open); --Toggle feature not used for this input switch.
    	       
    --Creating an instance of the button debouncer for the forward and backward step button.	       
    i_back_forward_debounce : btn_debounce_toggle
        generic map (CNTR_MAX => X"FFFF") -- For simulation: use CNTR_MAX => X"0009", else use X"FFFF"
    	   port map(
    	       BTN_I       => i_sys_enable,  --Input button linked to BTNL
    	       CLK         => i_crystal_clk, --clock linked to the 100MHz clock.
    	       BTN_O       => open,
    	       TOGGLE_O    => i_sys_enable_deb); --Button output linked to the system enable signal after
               	                                 --it has been debounced. It uses a toggling state.
               	                                 
    --Creating an instance of a clock enabler, this will give a 1Hz signal to the rest of the majority of the system.           	                                 
    Inst_clk_enabler: clk_enabler
        generic map(cnt_max => 99999999) 		-- For simulation: use cnt_max 	=> 9 else use 99999999 (for 1 Hz counters)												
        port map( 
         clock 		=> i_crystal_clk, --Output from the 100MHZ crystal. 
         clk_en 	=> clk_enable, --Enable every 99999999th 100MHz clock edge.
		 sys_en		=> i_asynch_start_deb --Takes  the output of the debouncer for the start button.
                );
	--Creating an instance of display_cycle, this will cycle through the 4 LED displays on the right.
	o_7segment_an_cycle : display_cycle
		port map(
		CLK => i_crystal_clk,
		o_7segment_an => anode_output_vector); --Writing the 4-bit vector to a signal that connects to the anodes
											   --of the LED displays.
											   
--	 Cycling through the anodes
--	process (cycle_anodes)
		
--		o_7segment_an(0) <= anode_output_vector(0);
--		o_7segment_an(1) <= anode_output_vector(1);
--		o_7segment_an(2) <= anode_output_vector(2);
--		o_7segment_an(3) <= anode_output_vector(3);
		
--	end process;
	
--	process(main)
		
--		--Cycle the anodes of the LED's regardless of the state of the system enable.
--		--cycle_anodes;
		
--		--Check if the system is enabled.
--		if(i_sys_enable_deb = '0') then
--			--Check if the start button has been held.
--			if(i_asynch_start_deb = '0') then
--				--Either cycle through the output forward, or back ward given the state of the
--				--i_back_forward_deb signal.
--				--if(i_back_forward_deb = '0') then
			
--				--else
			
--				--end if;
--			end if;
--		end if;
--	end process;
		
end Structural;
