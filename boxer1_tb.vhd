LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY boxer1_tb IS
END boxer1_tb;
 
ARCHITECTURE behavior OF boxer1_tb IS
 
 
COMPONENT boxer1_top
generic(
    gDATA_WIDTH : integer := 8
);
PORT(
    top_clk : IN STD_LOGIC;
    top_clear : IN STD_LOGIC
);
END COMPONENT;
 
--Inputs
signal clock : std_logic := '0';
signal reset : std_logic := '0';
signal up_down : std_logic := '0';
 
--Outputs
signal counter : std_logic_vector(3 downto 0);
 
constant clock_period : time := 20 ns;
 
BEGIN
 
uut: boxer1_top PORT MAP (
top_clk => clock,
top_clear => reset
);
 

-- Clock process definitions
clock_process :process
begin
clock <= '0';
wait for clock_period/2;
clock <= '1';
wait for clock_period/2;
end process;
 
 --Stimulus process
stim_proc: process
begin
 --hold reset state for 100 ns.
wait for 20 ns;
reset <= '1';
wait for 20 ns;
reset <= '0';
up_down <= '0';
wait for 200 ns;
up_down <= '1';
wait;
end process;
 
END;