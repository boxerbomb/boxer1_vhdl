library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY ring_counter IS 
generic (gRING_SIZE : integer);
PORT(
    count                : OUT STD_LOGIC_VECTOR(gRING_SIZE-1 DOWNTO 0);
    clk                  : in STD_LOGIC
);
END ring_counter;

ARCHITECTURE description OF ring_counter IS

-- Initalizes internal count with a 1 in the lowest position
signal init_count   : std_logic_vector(gRING_SIZE-1 downto 0):= std_logic_vector(to_unsigned(1,gRING_SIZE));
signal internal_count   : std_logic_vector(gRING_SIZE-1 downto 0):= std_logic_vector(to_unsigned(1,gRING_SIZE));

BEGIN
    process(clk)
    begin
        if internal_count(gRING_SIZE-1) = '1' then
            internal_count <= init_count;
        else
            internal_count <= std_logic_vector(shift_left(unsigned(internal_count),1));
        end if;
        count <= internal_count;

    end process;
END description;