library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY generic_register IS 
generic (gDATA_WIDTH : integer);
PORT(
    data_in   : IN STD_LOGIC_VECTOR(gDATA_WIDTH-1 DOWNTO 0);
    enable  : IN STD_LOGIC; -- load/enable.
    clear : IN STD_LOGIC; -- async. clear.
    clk : IN STD_LOGIC; -- clock.
    data_out   : OUT STD_LOGIC_VECTOR(gDATA_WIDTH-1 DOWNTO 0) -- output
);
END generic_register;

ARCHITECTURE description OF generic_register IS

BEGIN
    process(clk)
    begin
        if clear = '1' then
            data_out <= (others => '0');
        elsif rising_edge(clk) then
            if enable = '1' then
                data_out <= data_in;
            end if;
        end if;
    end process;
END description;