library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY binary_counter IS 
generic (gCOUNTER_WIDTH : integer
);
PORT(
    data_in              : IN STD_LOGIC_VECTOR(gCOUNTER_WIDTH-1 DOWNTO 0);
    load_enable          : IN STD_LOGIC; -- load/enable.
    clear                : IN STD_LOGIC; -- async. clear.
    count_enable         : IN STD_LOGIC; -- count enable
    clk                  : IN STD_LOGIC; -- clock.
    current_count        : OUT STD_LOGIC_VECTOR(gCOUNTER_WIDTH-1 DOWNTO 0) -- output
);
END binary_counter;

ARCHITECTURE description OF binary_counter IS

signal internal_count : STD_LOGIC_VECTOR(gCOUNTER_WIDTH-1 DOWNTO 0) := x"0100";

BEGIN
    process(clk)
    begin
        if clear = '1' then
            -- Reset counter to zero. Only really used on reset
            internal_count <= x"0100";
        elsif rising_edge(clk) then
            -- Increment the counter by one
            if count_enable = '1' then
                internal_count <= std_logic_vector(unsigned(internal_count)+1);
            -- Set the count to the value input(JMP)
            elsif count_enable = '1' then
                internal_count <= data_in;
            end if;
        end if;
    end process;
    current_count <= internal_count;
END description;