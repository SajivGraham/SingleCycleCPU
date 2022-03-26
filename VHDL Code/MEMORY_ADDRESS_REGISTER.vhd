library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MEMORY_ADDRESS_REGISTER is
    Port ( MAR_CLOCK          : in  STD_LOGIC;
			  MAR_INPUT 			: in  STD_LOGIC_VECTOR (7 downto 0);
			  MAR_OUTPUT 			: out STD_LOGIC_VECTOR (7 downto 0);

			  MAR_READ_ENABLE 	  : in  STD_LOGIC;
			  
			  MAR_READ_ADDRESS_IN  : in  STD_LOGIC_VECTOR (2 downto 0);
			  MAR_WRITE_ADDRESS_IN : in  STD_LOGIC_VECTOR (2 downto 0)

			  );
end MEMORY_ADDRESS_REGISTER;

architecture Behavioral of MEMORY_ADDRESS_REGISTER is
signal ADDRESS_1, ADDRESS_2, ADDRESS_3, ADDRESS_4, ADDRESS_5, ADDRESS_6, ADDRESS_7, ADDRESS_8: STD_LOGIC_VECTOR(7 downto 0);
begin


process(MAR_CLOCK) is
begin

if rising_edge(MAR_CLOCK) then

if MAR_WRITE_ADDRESS_IN = "001" then
	ADDRESS_1 <= MAR_INPUT;
	
else if MAR_WRITE_ADDRESS_IN = "010" then
	ADDRESS_2 <= MAR_INPUT;
	
else if	MAR_WRITE_ADDRESS_IN = "011" then
	ADDRESS_3 <= MAR_INPUT;

else if MAR_WRITE_ADDRESS_IN = "100" then
	ADDRESS_4 <= MAR_INPUT;
	
else if MAR_WRITE_ADDRESS_IN = "101" then
	ADDRESS_5 <= MAR_INPUT;
	
else if	MAR_WRITE_ADDRESS_IN = "110" then
	ADDRESS_6 <= MAR_INPUT;

else if MAR_WRITE_ADDRESS_IN = "111" then
	ADDRESS_7 <= MAR_INPUT;
	

else if MAR_READ_ADDRESS_IN = "001" and MAR_READ_ENABLE = '1' then
	MAR_OUTPUT <= ADDRESS_1;
	
else if MAR_READ_ADDRESS_IN = "010" and MAR_READ_ENABLE = '1' then
	MAR_OUTPUT <= ADDRESS_2;
	
else if MAR_READ_ADDRESS_IN = "011" and MAR_READ_ENABLE = '1' then
	MAR_OUTPUT <= ADDRESS_3;
	
else if MAR_READ_ADDRESS_IN = "100" and MAR_READ_ENABLE = '1' then
	MAR_OUTPUT <= ADDRESS_4;
	
else if MAR_READ_ADDRESS_IN = "101" and MAR_READ_ENABLE = '1' then
	MAR_OUTPUT <= ADDRESS_5;
	
else if MAR_READ_ADDRESS_IN = "110" and MAR_READ_ENABLE = '1' then
	MAR_OUTPUT <= ADDRESS_6;
	
else if MAR_READ_ADDRESS_IN = "111" and MAR_READ_ENABLE = '1' then
	MAR_OUTPUT <= ADDRESS_7;

end if;	
end if;
end if;
end if;	
end if;
end if;
end if;
end if;	
end if;
end if;
end if;	
end if;
end if;
end if;
end if;
end process;
end Behavioral;