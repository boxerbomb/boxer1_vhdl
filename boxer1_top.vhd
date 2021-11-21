library IEEE;
use IEEE.std_logic_1164.all;

ENTITY boxer1_top IS 
generic (
    gDATA_WIDTH : integer := 8
);
PORT(
    top_clk : IN STD_LOGIC;
    top_clear : IN STD_LOGIC
);
END boxer1_top;

ARCHITECTURE description OF boxer1_top IS

    --Need to create a bus mux entity and get it all hooked up together
    component bus_mux IS 
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

        control_word : in std_logic_vector(21 downto 0);
        BUS_OUT      : out std_logic_vector(16-1 downto 0);

        clk          : in std_logic
    );
    END component;

    component control_matrix IS 
    PORT(
        control_word   : out STD_LOGIC_VECTOR(21 DOWNTO 0);
        instruction    : in STD_LOGIC_VECTOR(3 downto 0);
        ring_count     : in STD_LOGIC_VECTOR(3 downto 0);
        clk            : in STD_LOGIC
    );
    END component;

    component rom is
        generic(
            gADDRESS_WIDTH: natural;
            gDATA_WIDTH: natural
        );
        port(
            clock: in std_logic;
            rom_enable: in std_logic;
            address: in std_logic_vector((gADDRESS_WIDTH - 1) downto 0);
            data_output: out std_logic_vector ((gDATA_WIDTH - 1) downto 0)
        );
    end component;

    component ram is
        generic(
            gADDRESS_WIDTH: natural := 8;
            gDATA_WIDTH: natural := 8
        );
        port(
            clock: in std_logic;
            read_enable: in std_logic;
            write_enable: in std_logic;
            address: in std_logic_vector((gADDRESS_WIDTH - 1) downto 0);
            data_input: in std_logic_vector ((gDATA_WIDTH - 1) downto 0);
            data_output: out std_logic_vector ((gDATA_WIDTH - 1) downto 0)
        );
    end component;

    component memory_decoder IS 
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
            address_out          : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END component;

    component generic_register IS 
        generic (gDATA_WIDTH : integer);
        PORT(
            data_in   : IN STD_LOGIC_VECTOR(gDATA_WIDTH DOWNTO 0);
            enable  : IN STD_LOGIC; -- load/enable.
            clear : IN STD_LOGIC; -- async. clear.
            clk : IN STD_LOGIC; -- clock.
            data_out   : OUT STD_LOGIC_VECTOR(gDATA_WIDTH DOWNTO 0) -- output
        );
    END component;

    component ALU IS 
        generic (gDATA_WIDTH : integer);
        PORT(
            data_A              : IN STD_LOGIC_VECTOR(gDATA_WIDTH DOWNTO 0);
            data_B              : IN STD_LOGIC_VECTOR(gDATA_WIDTH DOWNTO 0);
            config              : IN STD_LOGIC_vector(7 downto 0); -- Really only needs to be 4ish bits
            data_out            : OUT STD_LOGIC_VECTOR(gDATA_WIDTH DOWNTO 0);
            flag                : OUT STD_LOGIC -- What triggers this set by config
        );
    end component;

    component binary_counter IS 
        generic (gCOUNTER_WIDTH : integer
        );
        PORT(
            data_in              : IN STD_LOGIC_VECTOR(gCOUNTER_WIDTH-1 DOWNTO 0);
            load_enable          : IN STD_LOGIC; -- load/enable.
            clear                : IN STD_LOGIC; -- async. clear.
            count_enable         : IN STD_LOGIC; -- count enable
            clk                  : IN STD_LOGIC; -- clock.
            current_count        : OUT STD_LOGIC_VECTOR(gCOUNTER_WIDTH-1 DOWNTO 0) -- output
        );
    END component;

    component ring_counter IS 
        generic (gRING_SIZE : integer);
        PORT(
            count                : OUT STD_LOGIC_VECTOR(gRING_SIZE-1 DOWNTO 0);
            clk                  : in STD_LOGIC
        );
    END component;

    signal mainBus : std_logic_vector(15 downto 0);

    signal Reg_A_Out : std_logic_vector(gDATA_WIDTH-1 downto 0);
    signal Reg_B_Out : std_logic_vector(gDATA_WIDTH-1 downto 0);
    signal Reg_C_Out : std_logic_vector(gDATA_WIDTH-1 downto 0);
    signal Reg_O_Out : std_logic_vector(gDATA_WIDTH-1 downto 0);
    signal Reg_H_Out : std_logic_vector(gDATA_WIDTH-1 downto 0);
    signal Reg_L_Out : std_logic_vector(gDATA_WIDTH-1 downto 0);

    signal ALU_Out        : std_logic_vector(gDATA_WIDTH-1 downto 0);
    signal KEYBOARD_Out   : std_logic_vector(gDATA_WIDTH-1 downto 0);

    signal PC_Out   : std_logic_vector(16-1 downto 0);
    signal MAR_Out  : std_logic_vector(16-1 downto 0);
    signal IR_Out   : std_logic_vector(12-1 downto 0);

    signal QRAM_OUT : std_logic_vector(gDATA_WIDTH-1 downto 0);
    signal RAM_OUT : std_logic_vector(12-1 downto 0);
    signal ROM_OUT : std_logic_vector(12-1 downto 0);

    --   21       20    19   18    17   16    15   14    13    12      11   10    9    8    7        6     5       4      3     2      1    0
    -- CountEn, PCout, Ain, Aout, Bin, Bout, Cin, Cout, Oin, KeybOut, Hin, Hout, Lin, Lout MARin, MARout, MEMin, MEMout, IRin, IRout, JMP, HLT
    signal control_word : std_logic_vector(21 downto 0) := (others => '0');

    signal decoder_address : std_logic_vector(15 downto 0);



    -- Decoder signals
    signal ram_en          : std_logic := '0';
    signal rom_en          : std_logic := '0';
    signal qram_en         : std_logic := '0';
    
    signal ram_wr_en          : std_logic := '0';
    signal qram_wr_en         : std_logic := '0';     

    signal alu_setting_en   :std_logic := '0';
    signal new_term_line_en :std_logic := '0';
    signal write_term_en    :std_logic := '0';

    signal ring_counter_out :std_logic_vector(3 downto 0);


BEGIN

    control_matrix0 : control_matrix
    port map(
        control_word   => control_word,
        instruction    => IR_Out(11 downto 8),
        ring_count   => ring_counter_out,
        clk => top_clk
    );
  
    ring_counter0 : ring_counter
    generic map(
        gRING_SIZE => 4
    )
    port map(
        count => ring_counter_out,
        clk => top_clk
    );


    -- Starts and resets to start of ROM 0x0100
    program_counter0 : binary_counter
    generic map(
        gCOUNTER_WIDTH => 16
    )
    port map(
        data_in => "0000000000000000",
        load_enable => '0',
        clear => '0',
        count_enable => control_word(21),
        clk => top_clk,
        current_count => PC_Out
    );

    rom0 : rom
    generic map(
        gADDRESS_WIDTH => 12,
        gDATA_WIDTH => 12
    )
    port map(
        clock => top_clk,
        rom_enable => '1',
        address => decoder_address(11 downto 0),
        data_output => ROM_OUT
    );

    quick_ram:ram
        generic map(
            gADDRESS_WIDTH => 8,
            gDATA_WIDTH => 8
        )
        port map(
            clock => top_clk,
            read_enable => '1',
            --Memory decoder signal specifying qram as well as the memeory write signal
            write_enable => qram_wr_en,
            address => decoder_address(7 downto 0),
            data_input => mainBus(7 downto 0),
            data_output => QRAM_OUT
        );

    ram0:ram
        generic map(
            gADDRESS_WIDTH => 12,
            gDATA_WIDTH => 12
        )
        port map(
            clock => top_clk,
            read_enable => '1',
            --Memory decoder signal specifying ram as well as the memeory write signal
            write_enable => ram_wr_en,
            address => decoder_address(11 downto 0),
            data_input => mainBus(11 downto 0),
            data_output => RAM_OUT
        );

    

    memory_decoder0 : memory_decoder 
    PORT MAP(
        address_in  => MAR_OUT,
        -- 0-252 Quick RAM
        QRAM_EN     => qram_en,
        -- 253 ALUSETTINGS
        ALU_SETTING_EN    => alu_setting_en,
        -- 254 newTerminalLine
        NEW_TERM_LINE_EN  => new_term_line_en,
        -- 255 writeTerm
        WRITE_TERM_EN     => write_term_en,
        -- 256-16384 ROM
        ROM_EN            => rom_en,
        -- 16385-65535 This will be smaller in practice
        RAM_EN            => ram_en,
        address_out  => decoder_address
    );


    Reg_A : generic_register
        generic map (gDATA_WIDTH => gDATA_WIDTH)
        PORT map(
            data_in   => mainBus(7 downto 0),
            --Enable in
            enable    => control_word(19),
            clear     => top_clear,
            clk       => top_clk,
            data_out  => Reg_A_Out
    );

    Reg_B : generic_register
    generic map (gDATA_WIDTH => gDATA_WIDTH)
    PORT map(
        data_in   => mainBus(7 downto 0),
        enable    => control_word(17),
        clear     => top_clear,
        clk       => top_clk,
        data_out  => Reg_B_Out
    );

    Reg_C : generic_register
    generic map (gDATA_WIDTH => gDATA_WIDTH)
    PORT map(
        data_in   => mainBus(7 downto 0),
        enable    => control_word(15),
        clear     => top_clear,
        clk       => top_clk,
        data_out  => Reg_C_Out
    );

    Reg_O : generic_register
    generic map (gDATA_WIDTH => gDATA_WIDTH)
    PORT map(
        data_in   => mainBus(7 downto 0),
        enable    => control_word(13),
        clear     => top_clear,
        clk       => top_clk,
        data_out  => Reg_O_Out
    );

    Reg_H : generic_register
    generic map (gDATA_WIDTH => gDATA_WIDTH)
    PORT map(
        data_in   => mainBus(7 downto 0),
        enable    => control_word(11),
        clear     => top_clear,
        clk       => top_clk,
        data_out  => Reg_H_Out
    );

    Reg_L : generic_register
    generic map (gDATA_WIDTH => gDATA_WIDTH)
    PORT map(
        data_in   => mainBus(7 downto 0),
        enable    => control_word(9),
        clear     => top_clear,
        clk       => top_clk,
        data_out  => Reg_L_Out
    );

    MAR : generic_register
    generic map (gDATA_WIDTH => 16)
    PORT map(
        -- THis will be used for real, next line is for testing
        --data_in   => mainBus,
        data_in => PC_Out,
        enable    => '1', --Always enabled as it goes directly to MEMORY DECODER
        clear     => top_clear,
        clk       => top_clk,
        data_out  => MAR_OUT
    );

    IR : generic_register
    generic map (gDATA_WIDTH => 12)
    PORT map(
        data_in   => mainBus(11 downto 0),
        enable    => control_word(3),
        clear     => top_clear,
        clk       => top_clk,
        data_out  => IR_Out
    );



    --process(top_clk)
    --begin
    --    if rising_edge(top_clk) then
    --        if ring_counter_out = "0001" then
    --            control_word(21) <= '1';
    --        else
    --            control_word(21) <= '0';
    --        end if;
    --    end if;
 
    --end process;

END description;