library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
	Port(
		  INPUT1,INPUT2     : in  STD_LOGIC_VECTOR(15 downto 0);
		  OUTPUT	    : out STD_LOGIC_VECTOR(15 downto 0);
		  STATUS_OUTPUT     : out STD_LOGIC_VECTOR(8 downto 0);
	  	  ALU_OPCODE	    : in  STD_LOGIC_VECTOR(4 downto 0)
		  );
end ALU;

architecture Behavioral of ALU is

signal 		 STATUS 		: STD_LOGIC_VECTOR(8 downto 0);
signal           RESULT 	   	: STD_LOGIC_VECTOR(15 downto 0);
signal 		 RESULT_MULT		: STD_LOGIC_VECTOR(31 downto 0);

signal           OVERFLOW_VAR 		: STD_LOGIC := '0';
signal           NEGATIVE_VAR		: STD_LOGIC := '0';
signal   	 COMPARE_VAR		: STD_LOGIC := '0';
signal           GREATER_THAN_VAR	: STD_LOGIC := '0';
signal           LESS_THAN_VAR		: STD_LOGIC := '0';
signal           LOGICAL_AND_VAR	: STD_LOGIC := '0';
signal           LOGICAL_OR_VAR		: STD_LOGIC := '0';
signal           LOGICAL_XOR_VAR	: STD_LOGIC := '0';

signal		TWOS                    : STD_LOGIC_VECTOR(15 downto 0);
begin

process (INPUT1, INPUT2, ALU_OPCODE) is
begin			
		case ALU_OPCODE is 
			when "00000" => -- ADD
			    RESULT <= STD_LOGIC_VECTOR(signed(INPUT1) + signed(INPUT2));
				 RESULT_MULT <= X"00000000";
		
			when "00001" => -- SUB
				 RESULT <= STD_LOGIC_VECTOR(signed(INPUT1) - signed(INPUT2));
				 RESULT_MULT <= X"00000000";

			when "00010" => -- MUL
				 RESULT_MULT <= STD_LOGIC_VECTOR(signed(INPUT1) * signed(INPUT2));
				 RESULT <= RESULT_MULT(15 downto 0);
					
			when "00011" => -- DIV
				 RESULT <= STD_LOGIC_VECTOR(signed(INPUT1) / signed(INPUT2));
				 RESULT_MULT <= X"00000000";
				 
			when "00100" => -- INC
				 RESULT <= (STD_LOGIC_VECTOR(signed(INPUT2) + 1));
				 RESULT_MULT <= X"00000000";
				 
			when "00101" => -- DEC
				 RESULT <= STD_LOGIC_VECTOR(signed(INPUT2) - 1);
				 RESULT_MULT <= X"00000000";
				 
			when "00110" => -- CLR
				 RESULT <= STD_LOGIC_VECTOR(signed(INPUT2) - signed(INPUT2));
				 RESULT_MULT <= X"00000000";
				 
			when "00111" => -- CMP
				 if INPUT1 > INPUT2 then
						GREATER_THAN_VAR <= '1';
						LESS_THAN_VAR <= '0';
						
						
				 else if INPUT1 < INPUT2 then
						GREATER_THAN_VAR <= '0';
						LESS_THAN_VAR <= '1';
		
			  	 else if INPUT1 = INPUT2 then
						COMPARE_VAR <= '1';
						
				 else if INPUT1 /= INPUT2 then
						COMPARE_VAR <= '0';
				end if;
				end if;
				end if;
				end if;
				RESULT <= X"0000";
				RESULT_MULT <= X"00000000";
						
			when "01000" => -- LSL
				 RESULT <= STD_LOGIC_VECTOR(shift_left(signed(INPUT2),1));
				 RESULT_MULT <= X"00000000";
				
			when "01001" => -- LSR
				 RESULT <= STD_LOGIC_VECTOR(shift_right(signed(INPUT2),1));
				 RESULT_MULT <= X"00000000";
				 
			when "01010" => -- LOGAND	
				if signed(INPUT1) > X"0000" and signed(INPUT2) > X"0000" then
					LOGICAL_AND_VAR <= '1';
				else 
					LOGICAL_AND_VAR <= '0';
				end if;
				RESULT <= X"0000";
				RESULT_MULT <= X"00000000";
				
			when "01011" => -- LOGOR
				if signed(INPUT1) > X"0000" or signed(INPUT2) > X"0000" then
					LOGICAL_OR_VAR <= '1';
				else 
					LOGICAL_OR_VAR <= '0';
				end if;
				RESULT <= X"0000";
				RESULT_MULT <= X"00000000";
				
			when "01100" => -- LOGXOR
				if signed(INPUT1) > X"0000" and signed(INPUT2) > X"0000" then
					LOGICAL_AND_VAR <= '0';
				else if signed(INPUT1) = X"0000" and signed(INPUT2) = X"0000" then
					LOGICAL_AND_VAR <= '0';
				else 
					LOGICAL_AND_VAR <= '1';
				end if;
				end if;
				RESULT <= X"0000";
				RESULT_MULT <= X"00000000";
				
			when "01101" => -- BITAND
				RESULT(15) <= INPUT1(15) and INPUT2(15);
				RESULT(14) <= INPUT1(14) and INPUT2(14);
				RESULT(13) <= INPUT1(13) and INPUT2(13);
				RESULT(12) <= INPUT1(12) and INPUT2(12);
				RESULT(11) <= INPUT1(11) and INPUT2(11);
				RESULT(10) <= INPUT1(10) and INPUT2(10);
				RESULT(9)  <= INPUT1(9) and INPUT2(9);
				RESULT(8)  <= INPUT1(8) and INPUT2(8);
				RESULT(7)  <= INPUT1(7) and INPUT2(7);
				RESULT(6)  <= INPUT1(6) and INPUT2(6);
				RESULT(5)  <= INPUT1(5) and INPUT2(5);
				RESULT(4)  <= INPUT1(4) and INPUT2(4);
				RESULT(3)  <= INPUT1(3) and INPUT2(3);
				RESULT(2)  <= INPUT1(2) and INPUT2(2);
				RESULT(1)  <= INPUT1(1) and INPUT2(1);
				RESULT(0)  <= INPUT1(0) and INPUT2(0);
				RESULT_MULT <= X"00000000";
				
			when "01110" => -- BITOR
				RESULT(15) <= INPUT1(15) or INPUT2(15);
				RESULT(14) <= INPUT1(14) or INPUT2(14);
				RESULT(13) <= INPUT1(13) or INPUT2(13);
				RESULT(12) <= INPUT1(12) or INPUT2(12);
				RESULT(11) <= INPUT1(11) or INPUT2(11);
				RESULT(10) <= INPUT1(10) or INPUT2(10);
				RESULT(9)  <= INPUT1(9) or INPUT2(9);
				RESULT(8)  <= INPUT1(8) or INPUT2(8);
				RESULT(7)  <= INPUT1(7) or INPUT2(7);
				RESULT(6)  <= INPUT1(6) or INPUT2(6);
				RESULT(5)  <= INPUT1(5) or INPUT2(5);
				RESULT(4)  <= INPUT1(4) or INPUT2(4);
				RESULT(3)  <= INPUT1(3) or INPUT2(3);
				RESULT(2)  <= INPUT1(2) or INPUT2(2);
				RESULT(1)  <= INPUT1(1) or INPUT2(1);
				RESULT(0)  <= INPUT1(0) or INPUT2(0);
				RESULT_MULT <= X"00000000";
				
			when "01111" => -- BITXOR
				RESULT(15) <= INPUT1(15) xor INPUT2(15);
				RESULT(14) <= INPUT1(14) xor INPUT2(14);
				RESULT(13) <= INPUT1(13) xor INPUT2(13);
				RESULT(12) <= INPUT1(12) xor INPUT2(12);
				RESULT(11) <= INPUT1(11) xor INPUT2(11);
				RESULT(10) <= INPUT1(10) xor INPUT2(10);
				RESULT(9)  <= INPUT1(9) xor INPUT2(9);
				RESULT(8)  <= INPUT1(8) xor INPUT2(8);
				RESULT(7)  <= INPUT1(7) xor INPUT2(7);
				RESULT(6)  <= INPUT1(6) xor INPUT2(6);
				RESULT(5)  <= INPUT1(5) xor INPUT2(5);
				RESULT(4)  <= INPUT1(4) xor INPUT2(4);
				RESULT(3)  <= INPUT1(3) xor INPUT2(3);
				RESULT(2)  <= INPUT1(2) xor INPUT2(2);
				RESULT(1)  <= INPUT1(1) xor INPUT2(1);
				RESULT(0)  <= INPUT1(0) xor INPUT2(0);
				RESULT_MULT <= X"00000000";
				
			when "10000" => -- ONE'S COMPLEMENT
				RESULT(0) <= not INPUT2(0);
				RESULT(1) <= not INPUT2(1);
				RESULT(2) <= not INPUT2(2);
				RESULT(3) <= not INPUT2(3);
				RESULT(4) <= not INPUT2(4);
				RESULT(5) <= not INPUT2(5);
				RESULT(6) <= not INPUT2(6);
				RESULT(7) <= not INPUT2(7);
				RESULT(8) <= not INPUT2(8);
				RESULT(9) <= not INPUT2(9);
				RESULT(10) <= not INPUT2(10);
				RESULT(11) <= not INPUT2(11);
				RESULT(12) <= not INPUT2(12);
				RESULT(13) <= not INPUT2(13);
				RESULT(14) <= not INPUT2(14);
				RESULT(15) <= not INPUT2(15);
				RESULT_MULT <= X"00000000";
				
			when "10001" => -- TWO'S COMPLEMENT
				RESULT(0) <= not INPUT2(0);
				RESULT(1) <= not INPUT2(1);
				RESULT(2) <= not INPUT2(2);
				RESULT(3) <= not INPUT2(3);
				RESULT(4) <= not INPUT2(4);
				RESULT(5) <= not INPUT2(5);
				RESULT(6) <= not INPUT2(6);
				RESULT(7) <= not INPUT2(7);
				RESULT(8) <= not INPUT2(8);
				RESULT(9) <= not INPUT2(9);
				RESULT(10) <= not INPUT2(10);
				RESULT(11) <= not INPUT2(11);
				RESULT(12) <= not INPUT2(12);
				RESULT(13) <= not INPUT2(13);
				RESULT(14) <= not INPUT2(14);
				RESULT(15) <= not INPUT2(15);
				RESULT <= STD_LOGIC_VECTOR(1 + unsigned(RESULT));
				RESULT_MULT <= X"00000000";

			when "11011" => -- BRANCH IF EQUAL
				if INPUT1 = INPUT2 then
					COMPARE_VAR <= '1';
				end if;
				RESULT <= X"0000";
				RESULT_MULT <= X"00000000";
				
			when "11100" => -- BRANCH IF NOT EQUAL
				if (INPUT1) /= (INPUT2) then 
					COMPARE_VAR <= '0';
				end if;
				RESULT <= X"0000";
				RESULT_MULT <= X"00000000";
					
			when "11101" => -- BRANCH IF GREATER
				if INPUT1 > INPUT2 then
					GREATER_THAN_VAR <= '1';
					LESS_THAN_VAR    <= '0';
				end if;
				RESULT <= X"0000";
				RESULT_MULT <= X"00000000";
			
			when "11110" => -- BRANCH IF LESS
				if INPUT1 < INPUT2 then
					GREATER_THAN_VAR <= '0';
					LESS_THAN_VAR    <= '1';
				end if;
				RESULT <= X"0000";
				RESULT_MULT <= X"00000000";
				
			when others  => RESULT      <= X"0000";
				        RESULT_MULT <= X"00000000";
			end case;

end process;

STATUS_OUTPUT(0) <= OVERFLOW_VAR;
STATUS_OUTPUT(1) <= NEGATIVE_VAR;
STATUS_OUTPUT(2) <= '1' when (ALU_OPCODE = "11011")and INPUT1 = INPUT2  else 
		    '0' when (ALU_OPCODE = "11011")and INPUT1 /= INPUT2 else
		    '1' when (ALU_OPCODE = "11100")and INPUT1 = INPUT2  else
		    '0' when (ALU_OPCODE = "11100")and INPUT1 /= INPUT2 else 
		    '0';
STATUS_OUTPUT(3) <= GREATER_THAN_VAR;
STATUS_OUTPUT(4) <= LESS_THAN_VAR;
STATUS_OUTPUT(5) <= LOGICAL_AND_VAR;
STATUS_OUTPUT(6) <= LOGICAL_OR_VAR;
STATUS_OUTPUT(7) <= LOGICAL_XOR_VAR;	

OUTPUT <= RESULT;
end Behavioral;
