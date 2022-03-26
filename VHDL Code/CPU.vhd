library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CPU is
	port( GLOBAL_CLOCK        		  : in   STD_LOGIC;
			INPUT                     : in   STD_LOGIC_VECTOR(15 downto 0) := X"0000";
			OUTPUT                    : out  STD_LOGIC_VECTOR(15 downto 0);
			STATUS_REG 					  : out  STD_LOGIC_VECTOR(8 DOWNTO 0);
			INSTRUCTION		           : inout   STD_LOGIC_VECTOR(30 downto 0)
			);
end CPU;

architecture Behavioral of CPU is

signal 	 IMMEDIATE 					: STD_LOGIC;
signal    OUT_REG, IN_REG        : STD_LOGIC_VECTOR(15 downto 0);
signal 	 IMMEDIATE_VAL				: STD_LOGIC_VECTOR(15 downto 0);
-----------------------------------------------------------------------------------------
-- CONTROL UNIT SIGNALS

signal    OUTPUT_REGISTER_WE	   : STD_LOGIC;
signal 	 CU_INDIRECT            : STD_LOGIC;
signal 	 ALU_MUX						: STD_LOGIC_VECTOR(1 downto 0);
signal    MAR_WRITE_ADDRESS	   : STD_LOGIC_VECTOR(1 downto 0);
signal 	 REG_DEMUX, REG_MUX 		: STD_LOGIC_VECTOR(2 downto 0);
signal	 STATUS_BITS				: STD_LOGIC_VECTOR(8 DOWNTO 0);
signal	 ENTIRE_OPCODE 			: STD_LOGIC_VECTOR(10 DOWNTO 0);
signal    ALU_OPCODE             : STD_LOGIC_VECTOR(4 DOWNTO 0);
signal    RAM_WE, 
			 RAM_RE, 
			 EEPROM_WE, 
			 EEPROM_RE,
			 STATUS_CLR,
			 COUNT_ENABLE, 
			 MAR_W_ENABLE, 
			 MAR_R_ENABLE, 
			 REGISTER_A_READ_ENABLE, 
			 REGISTER_B_READ_ENABLE, 
			 REGISTER_WRITE_ENABLE : STD_LOGIC;
------------------------------------------------------------------------------------------
-- ALU SIGNALS
signal 	 ALU_INPUT_1,ALU_INPUT_2: STD_LOGIC_VECTOR(15 downto 0);
signal    OUTPUT_ALU			      : STD_LOGIC_VECTOR(15 downto 0);
signal	 ALU_OPCODE_IN	         : STD_LOGIC_VECTOR(4 downto 0);
signal    STATUS_OUTPUT          : STD_LOGIC_VECTOR(8 downto 0);
------------------------------------------------------------------------------------------
-- REGISTER SIGNALS

signal  	 REG_CLOCK, WRITE_ENABLE, RST 	 		: STD_LOGIC;
signal 	 REG_A_READ_ENABLE, REG_B_READ_ENABLE  : STD_LOGIC;
signal    ADDRESS_1, ADDRESS_2, WRITE_ADDRESS 	: STD_LOGIC_VECTOR(3 DOWNTO 0);
signal    OUTPUT_1, OUTPUT_2 						   : STD_LOGIC_VECTOR(15 DOWNTO 0);
signal    REG_INPUT 								      : STD_LOGIC_VECTOR(15 DOWNTO 0);
------------------------------------------------------------------------------------------
-- INSTRUCTION REGISTER SIGNALS
signal    IR_CLOCK 		         :   STD_LOGIC;
signal    IR_INPUT 		         :   STD_LOGIC_VECTOR (30 downto 0);
signal    IR_OUTPUT 	            :   STD_LOGIC_VECTOR (30 downto 0);
------------------------------------------------------------------------------------------
--PROGRAM MEMORY SIGNALS
signal    ADDRESS   					:   STD_LOGIC_VECTOR (7 downto 0);
signal    PM_OUTPUT 					:   STD_LOGIC_VECTOR (30 downto 0);
------------------------------------------------------------------------------------------
-- PROGRAM COUNTER SIGNALS
signal  	 LOAD         		      :   STD_LOGIC;
signal    PC_COUNT_ENABLE        :   STD_LOGIC;
signal    PC_CLOCK               :   STD_LOGIC;
signal    RESET                  :   STD_LOGIC;
signal    PC_INPUT               :   STD_LOGIC_VECTOR (7 downto 0);
signal    PC_OUTPUT              :   STD_LOGIC_VECTOR (7 downto 0);
------------------------------------------------------------------------------------------
--MEMORY ADDRESS REGISTER SIGNALS
signal    MAR_READ_ENABLE        :   STD_LOGIC;
signal    MAR_CLOCK              :   STD_LOGIC;
signal    MAR_READ_ADDRESS_IN 	:   STD_LOGIC_VECTOR (2 downto 0);
signal    MAR_WRITE_ADDRESS_IN   :   STD_LOGIC_VECTOR (2 downto 0);
signal    MAR_INPUT 					:   STD_LOGIC_VECTOR (7 downto 0);
signal	 MAR_OUTPUT        		:   STD_LOGIC_VECTOR (7 downto 0);
------------------------------------------------------------------------------------------
--SEVEN SEGMENT DECODER SIGNALS
signal 	 BCDin         : STD_LOGIC_VECTOR (3 downto 0);
signal    Seven_Segment : STD_LOGIC_VECTOR (6 downto 0);
------------------------------------------------------------------------------------------
--INPUT REG
signal    i_Clk       : std_logic;
signal    i_Switch_1  : std_logic_vector(4 downto 0);
signal    o_LED_1     : std_logic_vector(4 downto 0);
signal    w_Switch_1  : std_logic_vector(4 downto 0);
signal    r_LED_1     : std_logic_vector(4 downto 0) := "00000";
signal    r_Switch_1  : std_logic_vector(4 downto 0) := "00000";
signal    TEMP		    : std_logic_vector(15 downto 0) := X"0000";
------------------------------------------------------------------------------------------
--EEPROM SIGNALS
signal    EEPROM_CLOCK        : STD_LOGIC;
signal    EEPROM_WRITE_ENABLE : STD_LOGIC;
signal    EEPROM_READ_ENABLE  : STD_LOGIC;
signal    EEPROM_ADDRESS      : STD_LOGIC_VECTOR(7 downto 0);
signal    EEPROM_INPUT        : STD_LOGIC_VECTOR(15 downto 0);
signal    EEPROM_OUTPUT       : STD_LOGIC_VECTOR(15 downto 0);
------------------------------------------------------------------------------------------
--RAM SIGNALS
signal    RAM_CLOCK        : STD_LOGIC;
signal    RAM_WRITE_ENABLE : STD_LOGIC;
signal    RAM_READ_ENABLE  : STD_LOGIC;
signal    RAM_ADDRESS      : STD_LOGIC_VECTOR(7 downto 0);
signal    RAM_INPUT        : STD_LOGIC_VECTOR(15 downto 0);
signal    RAM_OUTPUT       : STD_LOGIC_VECTOR(15 downto 0);
-------------------------------------------------------------------------------------------
begin
  Debounce_Inst : entity work.Debounce_Switch
    port map (
      i_Clk    => i_Clk,
      i_Switch => i_Switch_1,
      o_Switch => w_Switch_1
		);
		
CONTROL_UNIT_INSTANCE: entity work.CONTROL_UNIT
	port map( RAM_WE 						=> RAM_WE,
				 RAM_RE 						=> RAM_RE,
				 EEPROM_WE 				   => EEPROM_WE,
				 EEPROM_RE 				   => EEPROM_RE,
				 STATUS_CLR	      		=> STATUS_CLR,
				 ALU_MUX						=> ALU_MUX,
				 REG_DEMUX					=> REG_DEMUX,
				 REG_MUX					   => REG_MUX,
				 COUNT_ENABLE 			   => COUNT_ENABLE,
				 ENTIRE_OPCODE 			=> ENTIRE_OPCODE,
				 MAR_R_ENABLE 				=> MAR_R_ENABLE,
				 REGISTER_A_READ_ENABLE => REGISTER_A_READ_ENABLE,
				 REGISTER_B_READ_ENABLE => REGISTER_B_READ_ENABLE,
				 REGISTER_WRITE_ENABLE  => REGISTER_WRITE_ENABLE,
				 ALU_OPCODE             => ALU_OPCODE,
				 STATUS_BITS	         => STATUS_BITS,
				 OUTPUT_REGISTER_WE     => OUTPUT_REGISTER_WE
				 );

ALU_INSTANCE: entity work.ALU
	port map( 
				STATUS_OUTPUT => STATUS_OUTPUT,
				INPUT1         => ALU_INPUT_1,
				INPUT2         => ALU_INPUT_2,    
				OUTPUT         => OUTPUT_ALU,
				ALU_OPCODE     => ALU_OPCODE_IN	  
				);
				
INSTRUCTION_REGISTER_INSTANCE: entity work.INSTRUCTION_REGISTER
	port map(
				IR_CLOCK  => IR_CLOCK,		       
		      IR_INPUT  => IR_INPUT,		        
			   IR_OUTPUT => IR_OUTPUT
				);
				
PROGRAM_MEMORY_INSTANCE: entity work.PROGRAM_MEMORY
	port map(
				ADDRESS   => ADDRESS,
            PM_OUTPUT => PM_OUTPUT
				);
				
				
PROGRAM_COUNTER_INSTANCE: entity work.PROGRAM_COUNTER
	port map(
				LOAD             => LOAD,
				PC_COUNT_ENABLE  => PC_COUNT_ENABLE,
				PC_CLOCK         => PC_CLOCK,
				RESET            => RESET,
				PC_INPUT         => PC_INPUT,
				PC_OUTPUT        => PC_OUTPUT 
				);
				
				
REGISTER_INSTANCE: entity  work.Registers
	port map(REG_CLOCK         => REG_CLOCK,
				REG_A_READ_ENABLE	=> REG_A_READ_ENABLE,
				REG_B_READ_ENABLE	=> REG_B_READ_ENABLE,
				WRITE_ENABLE      => WRITE_ENABLE,
				WRITE_ADDRESS	   => WRITE_ADDRESS,
				ADDRESS_1         => ADDRESS_1,
				ADDRESS_2         => ADDRESS_2,				   	
				OUTPUT_1 		   => OUTPUT_1, 
				OUTPUT_2 		   => OUTPUT_2,
				REG_INPUT         => REG_INPUT
				);
				
MEMORY_ADDRESS_REGISTER_INSTANCE: entity work.MEMORY_ADDRESS_REGISTER
	port map(MAR_INPUT            => MAR_INPUT, 
			   MAR_OUTPUT           => MAR_OUTPUT,
            MAR_READ_ENABLE      => MAR_READ_ENABLE,
				MAR_READ_ADDRESS_IN  => MAR_READ_ADDRESS_IN,
			   MAR_WRITE_ADDRESS_IN => MAR_WRITE_ADDRESS_IN,
				MAR_CLOCK            => MAR_CLOCK
				);
				
				
SEVEN_SEGEMENT_DECODER_INSTANCE: entity work.SEVENSEGMENTDECODER
	port map(BCDin         => BCDin,
				Seven_Segment => Seven_Segment
				);
				
EEPROM_INSTANCE: entity work.EEPROM
	port map( EEPROM_CLOCK 					=> EEPROM_CLOCK,
				 EEPROM_INPUT 					=> EEPROM_INPUT,
				 EEPROM_OUTPUT 				=> EEPROM_OUTPUT,
				 EEPROM_ADDRESS 				=> EEPROM_ADDRESS,
				 EEPROM_READ_ENABLE 			=> EEPROM_READ_ENABLE,
				 EEPROM_WRITE_ENABLE 		=> EEPROM_WRITE_ENABLE
				 );

RAM_INSTANCE: entity work.RAM
   port map( RAM_CLOCK 					=> RAM_CLOCK,
				 RAM_INPUT 					=> RAM_INPUT,
				 RAM_OUTPUT 				=> RAM_OUTPUT,
				 RAM_ADDRESS 				=> RAM_ADDRESS,
				 RAM_READ_ENABLE 			=> RAM_READ_ENABLE,
				 RAM_WRITE_ENABLE 		=> RAM_WRITE_ENABLE
				 );
				
-----------------------------------------------------------
i_Clk				 <= GLOBAL_CLOCK;
PC_CLOCK 	    <= GLOBAL_CLOCK;
IR_CLOCK			 <= GLOBAL_CLOCK;
REG_CLOCK 		 <= GLOBAL_CLOCK;
MAR_CLOCK 		 <= GLOBAL_CLOCK;
RAM_CLOCK		 <= GLOBAL_CLOCK;
EEPROM_CLOCK    <= GLOBAL_CLOCK;

PC_COUNT_ENABLE <= COUNT_ENABLE;

ADDRESS         <= PC_OUTPUT;
MAR_INPUT 		 <= PC_OUTPUT;
INSTRUCTION     <= PM_OUTPUT;

IR_INPUT 		 	<= INSTRUCTION;
ENTIRE_OPCODE   		<= IR_OUTPUT(30 downto 20);
------------------------------------------------------------
i_Switch_1 <= INPUT(4 downto 0);

  p_Register : process (i_Clk) is
  begin
  if rising_edge(i_Clk) then
      r_Switch_1(0) <= w_Switch_1(0);         
		r_Switch_1(1) <= w_Switch_1(1);
		r_Switch_1(2) <= w_Switch_1(2);
		r_Switch_1(3) <= w_Switch_1(3);
		r_Switch_1(4) <= w_Switch_1(4);
		
		 -- This conditional expression looks for a falling edge on i_Switch_1.
      -- Here, the current value (i_Switch_1) is low, but the previous value
      -- (r_Switch_1) is high.  This means that we found a falling edge.
      if w_Switch_1(0) = '0' and r_Switch_1(0) = '1' then
        r_LED_1(0) <= not r_LED_1(0);         -- Toggle LED output
      elsif
		
		  w_Switch_1(1) = '0' and r_Switch_1(1) = '1' then
        r_LED_1(1) <= not r_LED_1(1);        
      elsif
		
		  w_Switch_1(2) = '0' and r_Switch_1(2) = '1' then
        r_LED_1(2) <= not r_LED_1(2);         
      elsif
		
		  w_Switch_1(3) = '0' and r_Switch_1(3) = '1' then
        r_LED_1(3) <= not r_LED_1(3);         
      elsif
		
		  w_Switch_1(4) = '0' and r_Switch_1(4) = '1' then
        r_LED_1(4) <= not r_LED_1(4);         
    end if;
end if;
	 
end process p_Register;

		
IN_REG(4 downto 0) <= r_LED_1;
--------------------------------------------------------------
IMMEDIATE 				<= IR_OUTPUT(25);
MAR_WRITE_ADDRESS_IN <= IR_OUTPUT(22 downto 20);
MAR_READ_ADDRESS_IN  <= IR_OUTPUT(2 downto 0);
--ENTIRE_OPCODE   		<= IR_OUTPUT(30 downto 20);

ALU_OPCODE_IN   		<= ALU_OPCODE;
IMMEDIATE_VAL	 		<= IR_OUTPUT(19 downto 4);

MAR_READ_ENABLE  		<= MAR_R_ENABLE;
LOAD 				 		<= MAR_R_ENABLE;

RAM_ADDRESS <= IR_OUTPUT(11 downto 4) when RAM_WE = '1' else
					IR_OUTPUT(19 DOWNTO 12) when RAM_RE = '1' and EEPROM_WE = '1' else
					X"00";
					
EEPROM_ADDRESS <= IR_OUTPUT(11 downto 4) when RAM_WE = '1' else
						IR_OUTPUT(19 downto 12);

RAM_READ_ENABLE <= RAM_RE;
RAM_WRITE_ENABLE <= RAM_WE;

EEPROM_READ_ENABLE <= EEPROM_RE;
EEPROM_WRITE_ENABLE <= EEPROM_WE;

REG_A_READ_ENABLE <= REGISTER_A_READ_ENABLE;
REG_B_READ_ENABLE <= REGISTER_B_READ_ENABLE;
WRITE_ENABLE 		<= REGISTER_WRITE_ENABLE;
ADDRESS_1  			<= IR_OUTPUT(19 downto 16);
ADDRESS_2  			<= IR_OUTPUT(15 downto 12);
WRITE_ADDRESS 	 	<= INSTRUCTION(3 downto 0);

ALU_INPUT_1 <= OUTPUT_1 when (ALU_MUX = "00") else
					X"0000"  when (ALU_MUX = "01") else
					X"0000"  when (ALU_MUX = "10") else
					X"0000";
					
					
ALU_INPUT_2 <= OUTPUT_2 	  when (ALU_MUX = "00") else
					IMMEDIATE_VAL when (ALU_MUX = "01") else
					OUTPUT_2      when (ALU_MUX = "10") else
					X"0000";

STATUS_BITS 			<= STATUS_OUTPUT when STATUS_CLR = '0' else
								"000000000";
								
PC_INPUT 		  		<= MAR_OUTPUT;	

REG_INPUT  <= OUTPUT_ALU 	 when (REG_MUX = "000") else 
				  IMMEDIATE_VAL when (REG_MUX = "001") else
				  IN_REG			 when (REG_MUX = "010") else 
				  RAM_OUTPUT    when (REG_MUX = "011") else
				  EEPROM_OUTPUT when (REG_MUX = "100") else
				  X"0000";	
				  
RAM_INPUT <= OUTPUT_2 when REG_DEMUX = "010" else X"0000";

EEPROM_INPUT <= OUTPUT_2  when REG_DEMUX = "011" else
					 RAM_INPUT when REG_DEMUX = "010" else
					 X"0000";
					 
				  
process (GLOBAL_CLOCK) is 
begin
	if rising_edge(GLOBAL_CLOCK) then
		if OUTPUT_REGISTER_WE = '1' then
			OUT_REG <= OUTPUT_2;
		end if;
		end if;	
end process;

BCDin 					<= OUT_REG(3 downto 0);
OUTPUT(6 downto 0) 	<= Seven_Segment;
--OUTPUT(15 downto 7) 	<= "111110100";
OUTPUT(15 downto 7) 	<= OUT_REG(15 downto 7);
--OUTPUT <= OUT_REG;
end Behavioral;