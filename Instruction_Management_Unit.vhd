library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Instruction_Management_Unit is
    Port (
        clk         : in  std_logic;
        reset       : in  std_logic;
        nPCsel      : in  std_logic;
        offset      : in  std_logic_vector(23 downto 0);
        instruction : out std_logic_vector(31 downto 0);
        Rd,Rn,Rm : out std_logic_vector(3 downto 0);
        imm8 : out std_logic_vector(7 downto 0)
		--PC_out      : out std_logic_vector(31 downto 0) 
    );
end Instruction_Management_Unit;

architecture Behavioral of Instruction_Management_Unit is
    type RAM64x32 is array (0 to 63) of std_logic_vector (31 downto 0);
       function init_mem return RAM64x32 is  
        variable result : RAM64x32; 
        begin 
        for i in 63 downto 0 loop 
        result (i):=(others=>'0'); 
        end loop;           -- PC        -- INSTRUCTION  -- COMMENTAIRE 
        result (0):=x"E3A01010";-- 0x0 _main -- MOV R1,#0x10 -- R1 = 0x10 
        result (1):=x"E3A02000";-- 0x1       -- MOV R2,#0x00 -- R2 = 0 
        result (2):=x"E4110000";-- 0x2 _loop -- LDR R0,0(R1) -- R0 = DATAMEM[R1]  
        result (3):=x"E0822000";-- 0x3       -- ADD R2,R2,R0 -- R2 = R2 + R0 
        result (4):=x"E2811001";-- 0x4       
        result (5):=x"E351001A";-- 0x5      
        result (6):=x"BAFFFFFB";-- 0x6       
        result (7):=x"E4012000";-- 0x7       
        result (8):=x"EAFFFFF7";-- 0x8       
        return result; 
        end init_mem;  
        signal instruction_memory: RAM64x32 := init_mem; 
    signal PC : std_logic_vector(31 downto 0) := (others => '0');
    signal next_PC : std_logic_vector(31 downto 0) := (others => '0');
    signal sign_ext_offset,temp_offset : std_logic_vector(31 downto 0);

begin
    process(clk, reset)
    begin
        if reset = '1' then
            PC <= (others => '0');
        elsif rising_edge(clk) then
            PC <= next_PC;
        end if;
    end process;

    -- Sign extension unit
    process(offset)
        variable temp_offset : std_logic_vector(31 downto 0);
    begin
        --temp_offset := (others => offset(23));  -- 初始化高位部分为符号位
        for i in 0 to 23 loop
            temp_offset(i) := offset(i);  -- 复制 offset 的各位
        end loop;
		for j in 24 to 31 loop
            temp_offset(j) := offset(23);
		end loop;
        sign_ext_offset <= temp_offset;
    end process;

    -- PC update logic
    process(PC, nPCsel, sign_ext_offset)
    begin
        if nPCsel = '0' then
            next_PC <= PC + 1;
        else
            next_PC <= PC + 1 + sign_ext_offset;
        end if;
        Rn <= instruction(19 downto 16);
        Rd <= instruction(15 downto 12);
        if instruction(25)='1' AND instruction(27 downto 26)="01" then
            Rm <= instruction(3 downto 0);
        else
            Rm <= "0000";
        end if;
        if instruction(25)='1' AND instruction(27 downto 26)="00" then
                imm8 <= instruction(7 downto 0);
        else
            imm8 <= "00000000";
        end if;
    end process;

   
    instruction <= instruction_memory(conv_integer(PC));  -- Using PC(7 downto 2) to access the 64-word memory
    
   

    
    --PC_out <= PC;

end Behavioral;
