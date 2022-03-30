library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CONTROL_UNIT is
port(ENTIRE_OPCODE 	         : IN  STD_LOGIC_VECTOR(10 DOWNTO 0);
	  STATUS_BITS		 : IN  STD_LOGIC_VECTOR(8 DOWNTO 0);
	  
	  ALU_MUX		 : OUT STD_LOGIC_VECTOR(1 downto 0);
	  REG_DEMUX		 : OUT STD_LOGIC_VECTOR(2 downto 0);
	  REG_MUX		 : OUT STD_LOGIC_VECTOR(2 downto 0);
	  
	  COUNT_ENABLE 		 : OUT STD_LOGIC := '1';
	  
	  REGISTER_WRITE_ENABLE  : OUT STD_LOGIC;
	  REGISTER_A_READ_ENABLE : OUT STD_LOGIC;
	  REGISTER_B_READ_ENABLE : OUT STD_LOGIC;
	  OUTPUT_REGISTER_WE     : OUT STD_LOGIC;
	  
	  MAR_R_ENABLE		 : OUT STD_LOGIC := '0';
	  
	  RAM_WE		 : OUT STD_LOGIC;
	  RAM_RE		 : OUT STD_LOGIC;
	  
	  EEPROM_WE		 : OUT STD_LOGIC;
	  EEPROM_RE              : OUT STD_LOGIC;
	  
	  STATUS_CLR		 : OUT  STD_LOGIC := '0';
	  
	  
	  ALU_OPCODE             : OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	  );
end CONTROL_UNIT;

architecture CONTROL_UNIT of CONTROL_UNIT is

signal IMMEDIATE            : 	STD_LOGIC;
signal EEPROM_FLAG 	    :   STD_LOGIC;
signal RAM_FLAG 	    :   STD_LOGIC;
signal MEMORY_ADDRESS       :  	STD_LOGIC_VECTOR(1 downto 0);
signal OUTPUT  	            : 	STD_LOGIC_VECTOR(1 downto 0);
signal OPCODE 		    : 	STD_LOGIC_VECTOR(4 DOWNTO 0);

begin
	
OPCODE  	        <= ENTIRE_OPCODE(10 downto 6); 
IMMEDIATE       	<= ENTIRE_OPCODE(5);
ALU_OPCODE 		<= OPCODE;
RAM_FLAG                <= ENTIRE_OPCODE(4);
EEPROM_FLAG             <= ENTIRE_OPCODE(3); 

ALU_MUX<= "00" when (OPCODE = "00000"  and IMMEDIATE = '0') else
	  "01" when (OPCODE = "00000"  and IMMEDIATE = '1') else
	  "00" when (OPCODE = "00001"  and IMMEDIATE = '0') else
	  "01" when (OPCODE = "00001"  and IMMEDIATE = '1') else
	  "00" when (OPCODE = "00010"  and IMMEDIATE = '0') else
	  "01" when (OPCODE = "00010"  and IMMEDIATE = '1') else
	  "00" when (OPCODE = "00011"  and IMMEDIATE = '0') else
	  "01" when (OPCODE = "00011"  and IMMEDIATE = '1') else
	  "00" when (OPCODE = "00100") else
	  "01" when (OPCODE = "00101") else
	  "01" when (OPCODE = "00110") else
	  "00" when (OPCODE = "00111") else
	  "10" when (OPCODE = "01000") else
	  "10" when (OPCODE = "01001") else
	  "00" when (OPCODE = "01010") else
	  "00" when (OPCODE = "01011") else
	  "00" when (OPCODE = "01100") else
	  "00" when (OPCODE = "01101") else
	  "00" when (OPCODE = "01110") else
	  "00" when (OPCODE = "01111") else
	  "01" when (OPCODE = "10000") else
	  "01" when (OPCODE = "10001") else
	  "00" when (OPCODE = "11011") else
	  "00" when (OPCODE = "11100") else
	  "00" when (OPCODE = "11101") else
	  "00" when (OPCODE = "11110") else
	  "11";

REG_MUX<= "000" when (OPCODE = "00000") else
	  "000" when (OPCODE = "00001") else
	  "000" when (OPCODE = "00010") else
	  "000" when (OPCODE = "00011") else
	  "000" when (OPCODE = "00100") else
	  "000" when (OPCODE = "00101") else
	  "111" when (OPCODE = "00111") else
	  "000" when (OPCODE = "01000") else
	  "000" when (OPCODE = "01001") else
	  "111" when (OPCODE = "01010") else
	  "111" when (OPCODE = "01011") else
	  "111" when (OPCODE = "01100") else
	  "000" when (OPCODE = "01101") else
	  "000" when (OPCODE = "01110") else
	  "000" when (OPCODE = "01111") else
	  "000" when (OPCODE = "10000") else
	  "000" when (OPCODE = "10001") else
	  "001" when (OPCODE = "10010") else
	  "111" when (OPCODE = "10011") else
	  "111" when (OPCODE = "10100") else
	  "011" when (OPCODE = "10101") and RAM_FLAG = '1' else
	  "100" when (OPCODE = "10101") and RAM_FLAG = '0' else
	  "111" when (OPCODE = "10110") else
	  "010" when (OPCODE = "10111") else
	  "111" when (OPCODE = "11000") else
	  "111";
			  
REG_DEMUX <= "000" when (OPCODE = "11000") else 
	     "001" when (OPCODE = "10011") else 
	     "010" when ((OPCODE = "10101") and RAM_FLAG = '1') else
	     "011" when ((OPCODE = "10101") and RAM_FLAG = '0') else
	     "111";
				 
OUTPUT_REGISTER_WE <= '1' when OPCODE = "11000" else
							 '0';
							 
COUNT_ENABLE <= '0' when (OPCODE = "11010") else '1';	
		     
REGISTER_WRITE_ENABLE <= '0' when (OPCODE = "00111") else 
			 '0' when (OPCODE = "01010") else
			 '0' when (OPCODE = "01011") else 
			 '0' when (OPCODE = "01100") else
			 '0' when (OPCODE = "10011") else 
			 '0' when (OPCODE = "10101") else
			 '0' when (OPCODE = "10110") else 
			 '0' when (OPCODE = "11000") else 
			 '0' when (OPCODE = "11001") else
			 '0' when (OPCODE = "11010") else 
			 '0' when (OPCODE = "11011") else
			 '0' when (OPCODE = "11100") else 
			 '0' when (OPCODE = "11101") else
			 '0' when (OPCODE = "11110") else 
			 '0' when (OPCODE = "11111") else
			 '1' when (OPCODE = "00100") else
			 '1';
								 
REGISTER_A_READ_ENABLE <=  '1' when (OPCODE = "00000"  and IMMEDIATE = '0') else
			   '1' when (OPCODE = "00001"  and IMMEDIATE = '0') else
			   '1' when (OPCODE = "00010"  and IMMEDIATE = '0') else
			   '1' when (OPCODE = "00011"  and IMMEDIATE = '0') else
			   '1' when (OPCODE = "00111") else
			   '1' when (OPCODE = "01010") else
			   '1' when (OPCODE = "01011") else
			   '1' when (OPCODE = "01100") else
			   '1' when (OPCODE = "01101") else
			   '1' when (OPCODE = "01110") else
			   '1' when (OPCODE = "01111") else
			   '1' when (OPCODE = "01011") else
			   '1' when (OPCODE = "01100") else
			   '1' when (OPCODE = "01101") else
			   '1' when (OPCODE = "01110") else
			   '1' when (OPCODE = "01111") else
			   '1' when (OPCODE = "10100") else
			   '1' when (OPCODE = "11011") else
			   '1' when (OPCODE = "11100") else
			   '1' when (OPCODE = "11101") else
			   '1' when (OPCODE = "11110") else
			   '0';
									
REGISTER_B_READ_ENABLE <=       '1' when (OPCODE = "00000"  and IMMEDIATE = '0') else
				'1' when (OPCODE = "00001"  and IMMEDIATE = '0') else
				'1' when (OPCODE = "00010"  and IMMEDIATE = '0') else
				'1' when (OPCODE = "00011"  and IMMEDIATE = '0') else
				'1' when (OPCODE = "00000"  and IMMEDIATE = '1') else
				'1' when (OPCODE = "00001"  and IMMEDIATE = '1') else
				'1' when (OPCODE = "00010"  and IMMEDIATE = '1') else
				'1' when (OPCODE = "00011"  and IMMEDIATE = '1') else
				'1' when (OPCODE = "00100") else
				'1' when (OPCODE = "01000") else
				'1' when (OPCODE = "01001") else
				'1' when (OPCODE = "00101") else
				'1' when (OPCODE = "00111") else
				'1' when (OPCODE = "01010") else
				'1' when (OPCODE = "01011") else
				'1' when (OPCODE = "01100") else
				'1' when (OPCODE = "01101") else
				'1' when (OPCODE = "01110") else
				'1' when (OPCODE = "01111") else
				'1' when (OPCODE = "01011") else
				'1' when (OPCODE = "01100") else
				'1' when (OPCODE = "01101") else
				'1' when (OPCODE = "01110") else
				'1' when (OPCODE = "01111") else
				'1' when (OPCODE = "10100") else
				'1' when (OPCODE = "11000") else
				'1' when (OPCODE = "11011") else
				'1' when (OPCODE = "11100") else
				'1' when (OPCODE = "11101") else
				'1' when (OPCODE = "11110") else
				'0';

MAR_R_ENABLE <=  '1' when (OPCODE = "11010") else 
		 '1' when (OPCODE = "11011" and STATUS_BITS(2) = '1') else
		 '1' when (OPCODE = "11100" and STATUS_BITS(2) = '0') else 
		 '1' when (OPCODE = "11101" and STATUS_BITS(3) = '1') else 
		 '1' when (OPCODE = "11110" and STATUS_BITS(3) = '0') else 
		 '0';
					 
RAM_WE <= '1' when OPCODE = "10011" and RAM_FLAG = '1' else '0';
			 
RAM_RE <= '1' when OPCODE = "10101" and RAM_FLAG = '1' else
	  '1' when OPCODE = "10111" and RAM_FLAG = '1' else
	  '0';
			 
EEPROM_WE <= '1' when OPCODE = "10101" else '0';
				 
EEPROM_RE <= '1' when OPCODE = "10101" and EEPROM_FLAG = '1' else
             '1' when OPCODE = "10111" and EEPROM_FLAG = '1' else
	     '0';

STATUS_CLR <= '1' when OPCODE = "11001" else'0';
	
end CONTROL_UNIT;
