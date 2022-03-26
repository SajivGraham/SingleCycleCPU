library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity EEPROM is
    Port ( EEPROM_CLOCK : in  STD_LOGIC;
			  EEPROM_ADDRESS      : in  STD_LOGIC_VECTOR (7 downto 0);
           EEPROM_INPUT        : in  STD_LOGIC_VECTOR (15 downto 0);
           EEPROM_OUTPUT       : out STD_LOGIC_VECTOR (15 downto 0);
           EEPROM_WRITE_ENABLE : in  STD_LOGIC;
			  EEPROM_READ_ENABLE  : in  STD_LOGIC
			  );
end EEPROM;

architecture Behavioral of EEPROM is

type EEPROM_FILE_TYPE is array(0 to 255) of STD_LOGIC_VECTOR (15 downto 0);
signal EEPROM_ARRAY : EEPROM_FILE_TYPE := (others => X"0000");
signal temp :STD_LOGIC_VECTOR (15 downto 0);

begin

process (EEPROM_CLOCK) is
begin
	if rising_edge(EEPROM_CLOCK) then
		if (EEPROM_WRITE_ENABLE = '1') then
			EEPROM_ARRAY(to_integer(unsigned(EEPROM_ADDRESS))) <= EEPROM_INPUT;
	   elsif (EEPROM_READ_ENABLE = '1') then
			EEPROM_OUTPUT <= EEPROM_ARRAY(to_integer(unsigned(EEPROM_ADDRESS)));
	end if;
	end if;
	
end process;
end Behavioral;