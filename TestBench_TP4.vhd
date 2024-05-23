LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY TopLevel_tb IS
END ENTITY;

ARCHITECTURE behavior OF TopLevel_tb IS 

    -- Component Declaration for the Unit Under Test (UUT)
    COMPONENT TopLevel_TP4
    PORT(
        CLK : in STD_LOGIC;
        RST: in STD_LOGIC;
        OutPut_Data : out STD_LOGIC_VECTOR(15 downto 0)
    );
    END COMPONENT;


    -- Clock period definitions
    constant CLK_period : time := 10 ns;
    signal OutPut_Data      : std_logic_vector(15 downto 0); 
    signal CLK : std_logic := '0';
    signal RST :std_logic := '0';
    signal Done : boolean := False;
    --constant CLK_period : time := 10 ns;
BEGIN

    -- Instantiate the Unit Under Test (UUT)
    uut: TopLevel_TP4 PORT MAP (
        CLK => CLK,
        RST => RST,
        OutPut_Data => OutPut_Data
    );

    -- Clock process definitions
    --clk <= '0' when Done else not clk after CLK_period;
    clk_process : process
    begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;
    -- Stimulus process
    stim_proc: process
    begin       
        -- hold reset state for 100 ns.
        wait for CLK_period * 2;  
        RST <= '1';
        wait for CLK_period * 2;
        RST <= '0';
        wait for CLK_period * 2;
        --Done <= True;
        wait;



        -- insert stimulus here 

        
    end process;

end architecture behavior;
