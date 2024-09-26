library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tri_state_buffer is
    generic (gDATA_WIDTH : integer);
    Port ( 
           data_in  : in  STD_LOGIC_VECTOR (gDATA_WIDTH-1 downto 0);
           en       : in  STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (gDATA_WIDTH-1 downto 0)
        );
end tri_state_buffer;

architecture Behavioral of tri_state_buffer is

begin    
    data_out <= data_in when (en = '0') else (others=>'Z');
end Behavioral;