LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY bus_test_tb IS
END bus_test_tb;
 
ARCHITECTURE behavior OF bus_test_tb IS
 
 
component bus_test_top is
    generic (gDATA_WIDTH : integer);
    Port ( 
           -- A signals
           a_in     : in STD_LOGIC_VECTOR (gDATA_WIDTH-1 downto 0);
           a_en     : in STD_LOGIC;
           -- B signals
           b_in     : in STD_LOGIC_VECTOR (gDATA_WIDTH-1 downto 0);
           b_en     : in STD_LOGIC;
           -- Outputs
           bus_out  : out STD_LOGIC_VECTOR(gDATA_WIDTH-1 downto 0)
        );
end component;
 
--Inputs
signal a_en, b_en : std_logic := '0';
 
--Outputs
signal a_data, b_data, bus_data : std_logic_vector(7 downto 0);
 
BEGIN
 
uut: bus_test_top
GENERIC MAP(gDATA_WIDTH=>8)
PORT MAP (
   a_in     => a_data,
   a_en     => a_en,
   b_in     => b_data,
   b_en     =>b_en,
   bus_out  => bus_data
);
 
 --Stimulus process
stim_proc: process
begin
    a_data <= "11110000";
    b_data <= "00001111";
    a_en <= '0';
    b_en <= '0';
wait for 20 ns;
    a_en <= '1';
wait for 20 ns;
    a_en <= '0';
wait for 20 ns;
    b_en <= '1';
wait for 20 ns;
    a_en <= '1';
wait for 20 ns;
wait;
end process;
 
END;