library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY ALU IS 
generic (gBIT_WIDTH : integer);
PORT(
    data_A              : IN STD_LOGIC_VECTOR(gBIT_WIDTH DOWNTO 0);
    data_B              : IN STD_LOGIC_VECTOR(gBIT_WIDTH DOWNTO 0);
    config              : IN STD_LOGIC_vector(7 downto 0); -- Really only needs to be 4ish bits
    data_out            : OUT STD_LOGIC_VECTOR(gBIT_WIDTH DOWNTO 0);
    flag                : OUT STD_LOGIC -- What triggers this set by config
);
END ALU;

ARCHITECTURE description OF alu IS

function BOOL_TO_SL(X : boolean)
            return std_ulogic is
begin
  if X then
    return ('1');
  else
    return ('0');
  end if;
end BOOL_TO_SL;

BEGIN

    process(data_A, data_B) is
        begin

        case config is
            when "00000000" =>
                data_out <= std_logic_vector(unsigned(data_A) + unsigned(data_B));
                flag <= BOOL_TO_SL(data_A=data_B);
            when "00000001" =>
                data_out <= std_logic_vector(unsigned(data_A) - unsigned(data_B));
                flag <= BOOL_TO_SL(data_A=data_B);
            when "00000010" =>
                data_out <= "0000" & data_A((data_A'length/2)-1 downto 0);
                flag <= '0';
            when "00000011" =>
                data_out <= "0000" & data_A(data_A'length downto (data_A'length/2)-1);
                flag <= '0';
            when "00000100" =>
                --THis is just a placeholder, not actually add
                data_out <= std_logic_vector(unsigned(data_A) + unsigned(data_B));
                flag <= '0';
            when others => 
                data_out <= (others => '0');
                flag<='0';
        end case;

    end process;

END description;