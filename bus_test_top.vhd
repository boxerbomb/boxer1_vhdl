library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bus_test_top is
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
end bus_test_top;

architecture Behavioral of bus_test_top is

component tri_state_buffer is
    generic (gDATA_WIDTH : integer);
    Port ( 
           data_in  : in  STD_LOGIC_VECTOR (gDATA_WIDTH-1 downto 0);
           en       : in  STD_LOGIC;
           data_out : out STD_LOGIC_VECTOR (gDATA_WIDTH-1 downto 0)
        );
end component;

    signal bus_output : std_logic_vector(gDATA_WIDTH-1 downto 0);

begin    

    a_buffer : tri_state_buffer
    generic map(
        gDATA_WIDTH => gDATA_WIDTH
    )
    Port map( 
        data_in  => a_in,
        en       => a_en,
        data_out => bus_output
    );

    b_buffer : tri_state_buffer
    generic map(
        gDATA_WIDTH => gDATA_WIDTH
    )
    Port map( 
        data_in  => b_in,
        en       => b_en,
        data_out => bus_output
    );


    bus_out <= bus_output;
end Behavioral;