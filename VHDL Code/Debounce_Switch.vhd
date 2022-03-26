library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity Debounce_Switch is
  port (
    i_Clk    : in  std_logic;
    i_Switch : in  std_logic_vector(4 downto 0);
    o_Switch : out std_logic_vector(4 downto 0)  
    );
end entity Debounce_Switch;
 
architecture RTL of Debounce_Switch is
 
  -- Set for 250,000 clock ticks of 25 MHz clock (10 ms)
  constant c_DEBOUNCE_LIMIT : integer := 500000;
  signal r_Count : integer range 0 to c_DEBOUNCE_LIMIT := 0;
  signal r_Count1 : integer range 0 to c_DEBOUNCE_LIMIT := 0;
  signal r_Count2 : integer range 0 to c_DEBOUNCE_LIMIT := 0;
  signal r_Count3 : integer range 0 to c_DEBOUNCE_LIMIT := 0;
  signal r_Count4 : integer range 0 to c_DEBOUNCE_LIMIT := 0;
  signal r_State : std_logic_vector(4 downto 0) := "00000";
  
  begin
	p_Debounce : process (i_Clk) is
  begin
    if rising_edge(i_Clk) then
 
      -- Switch input is different than internal switch value, so an input is
      -- changing.  Increase counter until it is stable for c_DEBOUNCE_LIMIT.
      if (i_Switch(0) /= r_State(0) and r_Count < c_DEBOUNCE_LIMIT) then
        r_Count <= r_Count + 1;
		-- End of counter reached, switch is stable, register it, reset counter
		      elsif r_Count = c_DEBOUNCE_LIMIT then
        r_State(0) <= i_Switch(0);
        r_Count <= 0;
 
      -- Switches are the same state, reset the counter
      else
        r_Count <= 0;
 
      end if;
		---------------------------------------------------------------------
				if (i_Switch(1) /= r_State(1) and r_Count1 < c_DEBOUNCE_LIMIT) then
        r_Count1 <= r_Count1 + 1;

      elsif r_Count1 = c_DEBOUNCE_LIMIT then
        r_State(1) <= i_Switch(1);
        r_Count1 <= 0;

      else
        r_Count1 <= 0;
 
      end if;
		---------------------------------------------------------------------
				if (i_Switch(2) /= r_State(2) and r_Count2 < c_DEBOUNCE_LIMIT) then
        r_Count2 <= r_Count2 + 1;

      elsif r_Count2 = c_DEBOUNCE_LIMIT then
        r_State(2) <= i_Switch(2);
        r_Count2 <= 0;

      else
        r_Count2 <= 0;
 
      end if;
		---------------------------------------------------------------------
				if (i_Switch(3) /= r_State(3) and r_Count3 < c_DEBOUNCE_LIMIT) then
        r_Count3 <= r_Count3 + 1;

      elsif r_Count3 = c_DEBOUNCE_LIMIT then
        r_State(3) <= i_Switch(3);
        r_Count3 <= 0;

      else
        r_Count3 <= 0;
 
      end if;
		---------------------------------------------------------------------
	 		  if (i_Switch(4) /= r_State(4) and r_Count4 < c_DEBOUNCE_LIMIT) then
        r_Count4 <= r_Count4 + 1;

      elsif r_Count3 = c_DEBOUNCE_LIMIT then
        r_State(4) <= i_Switch(4);
        r_Count4 <= 0;

      else
        r_Count4 <= 0;
 
      end if;
    end if;
  end process p_Debounce;
   -- Assign internal register to output (debounced!)
  o_Switch <= r_State;
 
end architecture RTL;
		
