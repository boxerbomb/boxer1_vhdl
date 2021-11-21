library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY bus_mux IS 
generic (gDATA_WIDTH : integer);
PORT(
    Reg_A_DATA : in std_logic_vector(gDATA_WIDTH-1 downto 0);
    Reg_B_DATA : in std_logic_vector(gDATA_WIDTH-1 downto 0);
    Reg_C_DATA : in std_logic_vector(gDATA_WIDTH-1 downto 0);
    Reg_O_DATA : in std_logic_vector(gDATA_WIDTH-1 downto 0);
    Reg_H_DATA : in std_logic_vector(gDATA_WIDTH-1 downto 0);
    Reg_L_DATA : in std_logic_vector(gDATA_WIDTH-1 downto 0);

    ALU_DATA        : in std_logic_vector(gDATA_WIDTH-1 downto 0);
    KEYBOARD_DATA   : in std_logic_vector(gDATA_WIDTH-1 downto 0);

    PC_DATA   : in std_logic_vector(16-1 downto 0);
    MAR_DATA  : in std_logic_vector(16-1 downto 0);
    IR_DATA   : in std_logic_vector(12-1 downto 0);

    MEM_DATA : in std_logic_vector(gDATA_WIDTH-1 downto 0);

    --   21       20    19   18    17   16    15   14    13    12      11   10    9    8    7        6     5       4      3     2      1    0
    -- CountEn, PCout, Ain, Aout, Bin, Bout, Cin, Cout, Oin, KeybOut, Hin, Hout, Lin, Lout MARin, MARout, MEMin, MEMout, IRin, IRout, JMP, HLT
    control_word : in std_logic_vector(21 downto 0);
    BUS_OUT      : out std_logic_vector(16-1 downto 0);

    clk          : in std_logic
);
END bus_mux;



ARCHITECTURE description OF bus_mux IS

--Define Signals

BEGIN
    process(clk)
    begin 

    if control_word(20)='1' then
    --PC out, High and low
        BUS_OUT <= PC_DATA;
    elsif control_word(18)='1' then
    --A out
        BUS_OUT(7 downto 0) <= Reg_A_DATA;
    elsif control_word(16)='1' then
    --B out
        BUS_OUT(7 downto 0) <= Reg_B_DATA;
    elsif control_word(14)='1' then
    --C out
        BUS_OUT(7 downto 0) <= Reg_C_DATA;
    elsif control_word(12)='1' then
    --Keyboard Out
        BUS_OUT(7 downto 0) <= KEYBOARD_DATA;
    elsif control_word(10)='1' then
    --H out, High
        BUS_OUT(15 downto 8) <= Reg_H_DATA;
    elsif control_word(8)='1' then
    --L out
        BUS_OUT(7 downto 0) <= REG_L_DATA;
    elsif control_word(6)='1' then
    -- Mar High and Low
        BUS_OUT <= MAR_DATA;
    elsif control_word(4)='1' then
    -- Mem out
        BUS_OUT(7 downto 0) <= MEM_DATA;
    elsif control_word(2)='1' then
    -- IR out
        BUS_OUT(11 downto 0) <= IR_DATA;
    end if;
        
        
        
        
        
        
        

    end process;
END description;