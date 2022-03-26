library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity INSTRUCTION_REGISTER is
    Port ( IR_CLOCK 		: in   STD_LOGIC;
           IR_INPUT 		: in   STD_LOGIC_VECTOR (30 downto 0);
           IR_OUTPUT 	: inout  STD_LOGIC_VECTOR (30 downto 0)
			  );
end INSTRUCTION_REGISTER;

architecture Behavioral of INSTRUCTION_REGISTER is

signal INSTRUCTION 	   : STD_LOGIC_VECTOR (30 downto 0);

begin
INSTRUCTION <= IR_INPUT;
IR_OUTPUT <= INSTRUCTION;
end Behavioral;