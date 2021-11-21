library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY memory_decoder IS 
PORT(
    address_in          : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    -- 0-252 Quick RAM
    QRAM_EN             : OUT STD_LOGIC;
    -- 253 ALUSETTINGS
    ALU_SETTING_EN      : OUT STD_LOGIC;
    -- 254 newTerminalLine
    NEW_TERM_LINE_EN    : OUT STD_LOGIC;
    -- 255 writeTerm
    WRITE_TERM_EN       : OUT STD_LOGIC;
    -- 256-16384 ROM
    ROM_EN              : OUT STD_LOGIC;
    -- 16385-65535 This will be smaller in practice
    RAM_EN              : OUT STD_LOGIC;
    -- Adjusted address out
    address_out          : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
END memory_decoder;

ARCHITECTURE description OF memory_decoder IS

-- 0000 0000 0000 0000
--           [--------] This section is used by config and QRAM 0000->00FF
--                                                         ROM  0100->0FFF
--                                                         RAM  1000->1FFF

BEGIN
    process(address_in)
    begin
        -- Decodes the first 256 bytes of memory, mostly Quick Ram with some terminal signals
        if address_in(15 downto 8) = "00000000" then
            if address_in(7 downto 0) = "11111111" then
                WRITE_TERM_EN <= '1';
                NEW_TERM_LINE_EN <= '0';
                QRAM_EN <= '0';
                ROM_EN <= '0';
                RAM_EN <= '0';
                ALU_SETTING_EN <= '0';
                address_out <= address_in;
            elsif address_in(7 downto 0) = "11111110" then
                WRITE_TERM_EN <= '0';
                NEW_TERM_LINE_EN <= '1';
                QRAM_EN <= '0';
                ROM_EN <= '0';
                RAM_EN <= '0';
                ALU_SETTING_EN <= '0';
                address_out <= address_in;
            elsif address_in(7 downto 0) = "11111101" then
                WRITE_TERM_EN <= '0';
                NEW_TERM_LINE_EN <= '0';
                QRAM_EN <= '0';
                ROM_EN <= '0';
                RAM_EN <= '0';
                ALU_SETTING_EN <= '1';
                address_out <= address_in;
            else
                WRITE_TERM_EN <= '0';
                NEW_TERM_LINE_EN <= '0';
                QRAM_EN <= '1';
                ROM_EN <= '0';
                RAM_EN <= '0';
                ALU_SETTING_EN <= '0';
                address_out <= address_in;
            end if;
        
        else
            if address_in(15 downto 12) = "0000" then
                WRITE_TERM_EN <= '0';
                NEW_TERM_LINE_EN <= '0';
                QRAM_EN <= '0';
                ROM_EN <= '1';
                RAM_EN <= '0';
                ALU_SETTING_EN <= '0';
                address_out <= std_logic_vector(unsigned(address_in)-16#0100#);
                -- This might not be done correctly, the idea is if this address is requested 0000 1000 0000 0000
                --                                                  this physical address     0000 0000 0000 0000 will be used in ROM
            else
                WRITE_TERM_EN <= '0';
                NEW_TERM_LINE_EN <= '0';
                QRAM_EN <= '0';
                ROM_EN <= '0';
                RAM_EN <= '1';
                ALU_SETTING_EN <= '0';
                address_out <= std_logic_vector(unsigned(address_in)-16#1000#);
            end if;
        end if;

    end process;
END description;