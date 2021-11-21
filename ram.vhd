library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity ram is
generic(
	gADDRESS_WIDTH: natural := 8;
	gDATA_WIDTH: natural := 12
);
port(
	clock: in std_logic;
	read_enable: in std_logic;
	write_enable: in std_logic;
	address: in std_logic_vector((gADDRESS_WIDTH - 1) downto 0);
	data_input: in std_logic_vector ((gDATA_WIDTH - 1) downto 0);
	data_output: out std_logic_vector ((gDATA_WIDTH - 1) downto 0)
);
end ram;

architecture arch of ram is
	type ram_type is array (0 to (2**(gADDRESS_WIDTH) -1)) of std_logic_vector((gDATA_WIDTH - 1) downto 0);
	signal ram: ram_type;
begin

process(clock) is
begin
    if rising_edge(clock)then
		if(read_enable = '1') then
			data_output <= ram(conv_integer(unsigned(address)));
	    elsif (write_enable = '1') then
		    ram(conv_integer(unsigned(address))) <= data_input;
		end if;		
	end if;
end process;

end arch;