library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity SEVENSEGMENTDECODER is
Port ( 
       BCDin : in STD_LOGIC_VECTOR (3 downto 0);
       Seven_Segment : out STD_LOGIC_VECTOR (6 downto 0)
     );
end SEVENSEGMENTDECODER ;
 
architecture Behavioral of SEVENSEGMENTDECODER  is
 
begin

Seven_Segment <=  "0000001" when BCDin = "0000" else --0
                  "1001111" when BCDin = "0001" else --1
                  "0010010" when BCDin = "0010" else --2
                  "0000110" when BCDin = "0011" else --3
                  "1001100" when BCDin = "0100" else --4
                  "0100100" when BCDin = "0101" else --5
                  "0100000" when BCDin = "0110" else --6
                  "0001111" when BCDin = "0111" else --7
                  "0000000" when BCDin = "1000" else --8
                  "0000100" when BCDin = "1001" else --9
                  "0001000" when BCDin = "1010" else --a
                  "1100000" when BCDin = "1011" else --b
                  "0110001" when BCDin = "1100" else --c
                  "1000010" when BCDin = "1101" else --d
                  "0110000" when BCDin = "1110" else --e
                  "0111000" when BCDin = "1111" else --f
                  "1111111";
 
end Behavioral;
