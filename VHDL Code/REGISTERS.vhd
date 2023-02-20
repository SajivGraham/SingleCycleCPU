library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity REGISTERS is				 
	Port(
		  REG_CLOCK, REG_A_READ_ENABLE, REG_B_READ_ENABLE, WRITE_ENABLE: IN STD_LOGIC;
		  ADDRESS_1, ADDRESS_2, WRITE_ADDRESS              	: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  OUTPUT_1, OUTPUT_2, IND_OUTPUT								    : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		  REG_INPUT 														            : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
		);
end REGISTERS;

architecture Behavioral of REGISTERS is

type REG_FILE_TYPE is array(0 to 15) of STD_LOGIC_VECTOR(15 downto 0);

signal REG_ARRAY : REG_FILE_TYPE := (others => X"0000");
begin
process(REG_CLOCK) is
 begin	
 if rising_edge(REG_CLOCK) then
		if (WRITE_ENABLE = '1') then
			REG_ARRAY(to_integer(unsigned(WRITE_ADDRESS))) <= REG_INPUT;
		end if;
		end if;
end process;

OUTPUT_1 <= REG_ARRAY(to_integer(unsigned(ADDRESS_1))) when REG_A_READ_ENABLE = '1' else X"0000";
OUTPUT_2 <= REG_ARRAY(to_integer(unsigned(ADDRESS_2))) when REG_B_READ_ENABLE = '1' else X"0000";

end Behavioral;
