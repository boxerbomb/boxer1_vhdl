library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY control_matrix IS 
PORT(
    control_word   : out STD_LOGIC_VECTOR(21 DOWNTO 0);
    instruction    : in STD_LOGIC_VECTOR(3 downto 0);
    ring_count     : in STD_LOGIC_VECTOR(3 downto 0);
    clk            : in STD_LOGIC
);
END control_matrix;

    --   21       20    19   18    17   16    15   14    13    12      11   10    9    8    7        6     5       4      3     2      1    0
    -- CountEn, PCout, Ain, Aout, Bin, Bout, Cin, Cout, Oin, KeybOut, Hin, Hout, Lin, Lout MARin, MARout, MEMin, MEMout, IRin, IRout, JMP, HLT

ARCHITECTURE description OF control_matrix IS

BEGIN
    process(clk)
    begin

        -- All sets to zero unless activated
        control_word <= "0000000000000000000000";

        if ring_count = "0001" then
            control_word(20) <= '1';
            control_word(7) <= '1';
        elsif ring_count = "0010" then
            control_word(21) <= '1';
            control_word(4) <= '1';
            control_word(3) <= '1';
        else
            --0000 is a NOP
            if instruction="0001" then

                --LDA
                if ring_count ="0100" then
                    control_word(10) <= '1';
                    control_word(8) <= '1';
                    control_word(7) <= '1';
                else
                    --ringcount = "1000"
                    control_word(4) <= '1';
                    control_word(19) <= '1';
                end if;

            elsif instruction="0010" then

                --LDQ
                if ring_count ="0100" then
                    control_word(2)<='1';
                    control_word(7)<='1';
                else
                    control_word(4) <= '1';
                    control_word(19) <='1';
                end if;

            elsif instruction="0011" then

                --LDB
                if ring_count ="0100" then
                    control_word(2)<='1';
                    control_word(17)<='1';
                end if;

            elsif instruction="0100" then
                --CPY --Tempoary for now, I will need to add the logic to switch betnween all registers
                if ring_count ="0100" then
                    control_word(18)<='1';
                    control_word(17)<='1';
                end if;
            elsif instruction="0101" then

                --JMP
                if ring_count = "0100" then
                    control_word(1) <= '1';
                    control_word(2) <= '1';
                end if;
            elsif instruction="0110" then

                --STO
                if ring_count ="0100" then
                    control_word(10) <= '1';
                    control_word(8) <= '1';
                    control_word(7) <= '1';
                else
                    control_word(18) <= '1';
                    control_word(5) <= '1';
                end if;

            elsif instruction="0111" then

                --STQ
                if ring_count = "0100" then
                    control_word(2) <= '1';
                    control_word(7) <= '1';
                else
                    control_word(18) <= '1';
                    control_word(5) <= '1';
                end if;

            elsif instruction="1111" then
                --halt
                control_word(0) <= '1';
            end if;
                

        end if;
            
    end process;
END description;