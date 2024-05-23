library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TopLevel_TP4 is
    port (
        CLK : in STD_LOGIC;
        RST : in STD_LOGIC;
        OutPut_Data : out STD_LOGIC_VECTOR(15 downto 0)
    );
end entity TopLevel_TP4;

architecture Behavioral of TopLevel_TP4 is
    signal busW : STD_LOGIC_VECTOR(31 downto 0);

    -----------
    
    signal WEE: STD_LOGIC;
    signal ALU_output : STD_LOGIC_VECTOR(31 downto 0);                       ---ALU
    signal CPSR1 : STD_LOGIC_VECTOR(3 downto 0);
    signal OPIN : STD_LOGIC_VECTOR(2 downto 0);

    -----------
    signal Rn,Rd,Rm : STD_LOGIC_VECTOR(3 downto 0);                         ---reg
    signal Bus_A, Bus_B : STD_LOGIC_VECTOR(31 downto 0);
    signal ReW: STD_LOGIC_VECTOR(3 downto 0);
    signal Imme_Num: STD_LOGIC_VECTOR(31 downto 0);
    signal Imme8: STD_LOGIC_VECTOR(7 downto 0);
    -----------
     
    signal MUX1_InA,MUX1_InB,MUX2_InA,MUX2_InB:std_logic_vector(31 downto 0);
    signal MUX1_COM,MUX2_COM:std_logic:='0';
    signal MUX1_Out,MUX2_Out:std_logic_vector(31 downto 0);
    signal MUX3_Out:std_logic_vector(3 downto 0);
    signal WE,COM1,COM2 : STD_LOGIC;
    ---mux1&2
    
    -----------
    signal Mem_WrEn: std_logic;
    signal Mem_Addr : std_logic_vector(5 downto 0); 
    signal Mem_DataInput : std_logic_vector(31 downto 0);
    signal Mem_DataOutput: std_logic_vector(31 downto 0); 
                                                                            ---Data_Memory
    -----------
    signal offset : std_logic_vector(23 downto 0);
    SIGNAL nPCSel,RegAff,PSREn : std_logic;
    signal instruction:std_logic_vector(31 downto 0);
    -----------
    signal RegSel: std_logic;

    component Instruction_Decoder is
        port (
            
            instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            PSR : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            nPCSel : OUT STD_LOGIC;
            RegWr : OUT STD_LOGIC;
            --ALUSrc : OUT STD_LOGIC;
            ALUCtr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            PSREn : OUT STD_LOGIC;
            ALUSrc : OUT STD_LOGIC;
            MemWr : OUT STD_LOGIC;
            WrSrc : OUT STD_LOGIC;
            RegSel : OUT STD_LOGIC;
            RegAff : OUT STD_LOGIC
        );
    end component;
    component ImmediateExtender is 
        port ( immediat_in  : in  std_logic_vector(7 downto 0);  -- 8-bit input
               immediat_out : out std_logic_vector(31 downto 0)  -- 32-bit output 
            );
    end component;
    component Instruction_Management_Unit is
        port (
            
            clk         : in  std_logic;
            reset       : in  std_logic;
            nPCsel      : in  std_logic;
            offset      : in  std_logic_vector(23 downto 0);
            instruction : out std_logic_vector(31 downto 0);
            Rd,Rn,Rm : out std_logic_vector(3 downto 0);
            imm8 : out std_logic_vector(7 downto 0)
        );
    end component;
    component ALU is
        port (
            
            OP : in std_logic_vector(2 downto 0);   
            A,B : in std_logic_vector(31 downto 0);
            CPSR : out std_logic_vector(3 downto 0); -- output flags
            S:out std_logic_vector(31 downto 0) -- output
        );
    end component;

    component REG is
        port (
            CLK: in std_logic;
            RST: in std_logic;
            RA,RB,RW : in std_logic_vector(3 downto 0);
            W: in std_logic_vector(31 downto 0);
            WE : in std_logic; -- input flags
            A,B: out std_logic_vector(31 downto 0) -- output
        
        );
    end component;
    component MUX is 
        port ( A,B : in std_logic_vector(31 downto 0);
            COM : in std_logic; -- Chip Select
            S : out std_logic_vector(31 downto 0) 
            );
end component;
component MUX3 is 
    port ( A,B : in std_logic_vector(3 downto 0);
        COM : in std_logic; -- Chip Select
        S : out std_logic_vector(3 downto 0) 
        );
end component;
    component Data_Memory is
        port (
            CLK: in std_logic;
            RST: in std_logic;
            Addr : in std_logic_vector(5 downto 0);--address
            DataInput: in std_logic_vector(31 downto 0);
            WrEn : in std_logic; -- write flag
            DataOutput: out std_logic_vector(31 downto 0) -- output
            );
        end component;
    begin
    ImmediateExtender_inst : ImmediateExtender port map (
        immediat_in  => imme8,
        immediat_out => Imme_Num
        );
    IMU_inst: Instruction_Management_Unit port map(
        clk => CLK,
        reset => RST,
        nPCsel => nPCsel, 
        offset => offset, 
        instruction => instruction,
        Rd => Rd,
        Rm => Rm,
        Rn => Rn,
        imm8 => imme8

    );


    reg_inst: REG port map (
        CLK => CLK,
        RST => RST,
        RA => Rn, 
        RB => MUX3_Out, 
        RW => ReW, 
        W => busW,
        WE => WEE, 
        A => Bus_A,
        B => Bus_B

    );
    ALU_inst: ALU port map (
        OP=>OPIN,
        A =>Bus_A,
        B => MUX1_Out,
        CPSR => CPSR1,
        S => ALU_output
    );
    MUX1_inst: MUX port map (
        COM => COM1,
        A => Bus_B,
        B => Imme_Num,   ---没写位数选择
        S => MUX1_Out
        
    );
    Data_Memory_inst0: Data_Memory port map(
        
        CLK => CLK,
        RST => RST,
        addr => ALU_output(5 downto 0),
        WrEn => Mem_WrEn,
        DataInput => Bus_B,
        DataOutput => MUX2_InB

    );
    I1D_inst: Instruction_Decoder port map(
        instruction => instruction,
        nPCsel => nPCsel, 
        PSR => CPSR1,
        RegWr => WEE,
        ALUCtr => OPIN,
        PSREn => PSREn,
        ALUSrc => MUX1_COM,
        MemWr => Mem_WrEn,
        WrSrc => MUX2_COM,
        RegSel => RegSel,
        RegAff => RegAff

    );
    MUX2_inst: MUX port map (
        A => ALU_output,
        B => MUX2_InB,   
        S => busW,
        COM => COM2
    );
    MUX3_inst: MUX3 port map (
        A => Rm,
        B => Rd,   
        S => MUX3_Out,
        COM => RegSel
    );
    process (CLK, RST)
    begin
    if RST = '1' then
        --OutPut_Data <= (others => '0');
    elsif rising_edge(CLK) then
        if RegAff='1' then
            --OutPut_Data <= Bus_B(15 downto 0);
        end if;
    --MUX2_Out1 <= busW;
    end if;
    end process;


end architecture Behavioral;
