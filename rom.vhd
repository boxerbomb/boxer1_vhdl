library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
 
entity rom is
generic(
    gADDRESS_WIDTH: natural := 12;
    gDATA_WIDTH: natural := 12
);
port(
    clock: in std_logic;
    rom_enable: in std_logic;
    address: in std_logic_vector((gADDRESS_WIDTH - 1) downto 0);
    data_output: out std_logic_vector ((gDATA_WIDTH - 1) downto 0)
);
end rom;
 
architecture arch of rom is
    --type rom_type is array (0 to (2**(gADDRESS_WIDTH) -1)) of std_logic_vector((gDATA_WIDTH - 1) downto 0);

                                --Length of Given rom
    type rom_type is array (0 to (223)) of std_logic_vector((gDATA_WIDTH - 1) downto 0);
    
    -- set the data on each adress to some value)
    constant mem: rom_type:=
    (
        "001100000000",
        "001100000001",
        "001100000010",
        "001100000011",
        "001100000011",
        "001100011111",
        "001100000011",
        "001100011111",
        "001100000011",
        "001100011111",
        "001100000011",
        "001100011111",
        "001100000011",
        "001100011111",
        "001100000011",
        "001100011111",
        "001100010000",
        "001100010001",
        "001100010010",
        "001100010011",
        "001100010100",
        "001100010101",
        "001100010110",
        "001100010111",
        "001100011000",
        "001100011001",
        "001100100000",
        "001100000000",
        "001100000000",
        "001100000001",
        "001100000010",
        "001100000011",
        "001100000100",
        "001100000101",
        "001100000110",
        "001100000111",
        "001100001000",
        "001100001001",
        "001100001010",
        "001100001011",
        "001100001100",
        "001100001101",
        "001100001110",
        "001100001111",
        "001100010000",
        "001100010001",
        "001100010010",
        "001100010011",
        "001100010100",
        "001100010101",
        "001100010110",
        "001100010111",
        "001100011000",
        "001100011001",
        "001100100000",
        "001100000000",
        "001100000000",
        "001100000001",
        "001100000010",
        "001100000011",
        "001100000100",
        "001100000101",
        "001100000110",
        "001100000111",
        "001100001000",
        "001100001001",
        "001100001010",
        "001100001011",
        "001100001100",
        "001100001101",
        "001100001110",
        "001100001111",
        "001100010000",
        "001100010001",
        "001100010010",
        "001100010011",
        "001100010100",
        "001100010101",
        "001100010110",
        "001100010111",
        "001100011000",
        "001100011001",
        "001100100000",
        "001100000000",
        "001100000000",
        "001100000001",
        "001100000010",
        "001100000011",
        "001100000100",
        "001100000101",
        "001100000110",
        "001100000111",
        "001100001000",
        "001100001001",
        "001100001010",
        "001100001011",
        "001100001100",
        "001100001101",
        "001100001110",
        "001100001111",
        "001100010000",
        "001100010001",
        "001100010010",
        "001100010011",
        "001100010100",
        "001100010101",
        "001100010110",
        "001100010111",
        "001100011000",
        "001100011001",
        "001100100000",
        "001100000000",
        "001100000000",
        "001100000001",
        "001100000010",
        "001100000011",
        "001100000100",
        "001100000101",
        "001100000110",
        "001100000111",
        "001100001000",
        "001100001001",
        "001100001010",
        "001100001011",
        "001100001100",
        "001100001101",
        "001100001110",
        "001100001111",
        "001100010000",
        "001100010001",
        "001100010010",
        "001100010011",
        "001100010100",
        "001100010101",
        "001100010110",
        "001100010111",
        "001100011000",
        "001100011001",
        "001100100000",
        "001100000000",
        "001100000000",
        "001100000001",
        "001100000010",
        "001100000011",
        "001100000100",
        "001100000101",
        "001100000110",
        "001100000111",
        "001100001000",
        "001100001001",
        "001100001010",
        "001100001011",
        "001100001100",
        "001100001101",
        "001100001110",
        "001100001111",
        "001100010000",
        "001100010001",
        "001100010010",
        "001100010011",
        "001100010100",
        "001100010101",
        "001100010110",
        "001100010111",
        "001100011000",
        "001100011001",
        "001100100000",
        "001100000000",
        "001100000000",
        "001100000001",
        "001100000010",
        "001100000011",
        "001100000100",
        "001100000101",
        "001100000110",
        "001100000111",
        "001100001000",
        "001100001001",
        "001100001010",
        "001100001011",
        "001100001100",
        "001100001101",
        "001100001110",
        "001100001111",
        "001100010000",
        "001100010001",
        "001100010010",
        "001100010011",
        "001100010100",
        "001100010101",
        "001100010110",
        "001100010111",
        "001100011000",
        "001100011001",
        "001100100000",
        "001100000000",
        "001100000000",
        "001100000001",
        "001100000010",
        "001100000011",
        "001100000100",
        "001100000101",
        "001100000110",
        "001100000111",
        "001100001000",
        "001100001001",
        "001100001010",
        "001100001011",
        "001100001100",
        "001100001101",
        "001100001110",
        "001100001111",
        "001100010000",
        "001100010001",
        "001100010010",
        "001100010011",
        "001100010100",
        "001100010101",
        "001100010110",
        "001100010111",
        "001100011000",
        "001100011001",
        "001100100000",
        "001100000000"
    );
begin
 
process(clock) is
begin
    if(rising_edge(clock) and rom_enable = '1') then
        if conv_integer(unsigned(address))>222 then
            --Return zero as this is hoe long the program is
            data_output <= (others => '0');
        else
            --Return Valid ROM data.
            data_output <= mem(conv_integer(unsigned(address)));
        end if;
    end if;
end process;
 
end arch;