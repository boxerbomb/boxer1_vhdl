ghdl -a --ieee=synopsys *.vhd
ghdl -m --ieee=synopsys boxer1_tb
ghdl -r --ieee=synopsys boxer1_tb --stop-time=30000ns --vcd=output.vcd
