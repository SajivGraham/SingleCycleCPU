library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity PROGRAM_COUNTER is
    Port ( 
	   LOAD               : in  STD_LOGIC;
           PC_COUNT_ENABLE    : in  STD_LOGIC;
           PC_CLOCK           : in  STD_LOGIC;
           RESET              : in  STD_LOGIC;
           PC_INPUT           : in  STD_LOGIC_VECTOR (7 downto 0);
           PC_OUTPUT          : out  STD_LOGIC_VECTOR (7 downto 0)
			  );
end PROGRAM_COUNTER;

architecture Behavioral of PROGRAM_COUNTER is

signal COUNTER          : STD_LOGIC_VECTOR(7 downto 0):= "00000000";

begin
	
process (PC_CLOCK, RESET)
 begin
 
 	if RESET = '1' then
			COUNTER <= X"00";
			
	elsif falling_edge(PC_CLOCK) then
		if LOAD = '1' then
			COUNTER  <= PC_INPUT;

		elsif PC_COUNT_ENABLE = '1' then
			COUNTER  <= (STD_LOGIC_VECTOR(unsigned(COUNTER) + 1));
		end if;		
	end if;

end process;
PC_OUTPUT <= COUNTER;
end Behavioral;
