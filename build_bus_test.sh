ghdl -a --ieee=synopsys tri_state_buffer.vhd bus_test_top.vhd bus_test_tb.vhd
ghdl -m --ieee=synopsys bus_test_tb
ghdl -r --ieee=synopsys bus_test_tb --stop-time=1000ns --vcd=output.vcd