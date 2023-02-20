library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity RAM is 
    Port ( RAM_CLOCK        : in  STD_LOGIC;
			     RAM_ADDRESS      : in  STD_LOGIC_VECTOR (7 downto 0);
           RAM_INPUT        : in  STD_LOGIC_VECTOR (15 downto 0);
           RAM_OUTPUT       : out STD_LOGIC_VECTOR (15 downto 0);
           RAM_WRITE_ENABLE : in  STD_LOGIC;
			     RAM_READ_ENABLE  : in  STD_LOGIC
			  );
end RAM;

architecture Behavioral of RAM is

type RAM_FILE_TYPE is array(0 to 255) of STD_LOGIC_VECTOR (15 downto 0);
signal RAM_ARRAY : RAM_FILE_TYPE := (others => X"0000");
signal temp :STD_LOGIC_VECTOR (15 downto 0);

begin

process (RAM_CLOCK) is
begin
	if rising_edge(RAM_CLOCK) then
		if (RAM_WRITE_ENABLE = '1') then
			RAM_ARRAY(to_integer(unsigned(RAM_ADDRESS))) <= RAM_INPUT;
	   elsif (RAM_READ_ENABLE = '1') then
			RAM_OUTPUT <= RAM_ARRAY(to_integer(unsigned(RAM_ADDRESS)));
	end if;
	end if;
	
end process;
end Behavioral;
