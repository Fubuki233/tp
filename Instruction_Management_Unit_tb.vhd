library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Instruction_Management_Unit_tb is
end Instruction_Management_Unit_tb;

architecture Behavioral of Instruction_Management_Unit_tb is

   
    component Instruction_Management_Unit is
        Port (
            clk         : in  std_logic;
            reset       : in  std_logic;
            nPCsel      : in  std_logic;
            offset      : in  std_logic_vector(23 downto 0);
            instruction : out std_logic_vector(31 downto 0)
            --PC_out      : out std_logic_vector(31 downto 0) 
        );
    end component;

    
    signal clk         : std_logic := '0';
    signal reset       : std_logic := '0';
    signal nPCsel      : std_logic := '0';
    signal offset      : std_logic_vector(23 downto 0) := (others => '0');
    signal instruction : std_logic_vector(31 downto 0);
    signal PC_out      : std_logic_vector(31 downto 0); 
    signal Done : boolean := False;
    
    constant clk_period : time := 10 ns;

begin

    
    uut: Instruction_Management_Unit
        Port map (
            clk => clk,
            reset => reset,
            nPCsel => nPCsel,
            offset => offset,
            instruction => instruction
            --PC_out => PC_out  
        );
    clk <= '0' when Done else not clk after CLK_period;
	stim_proc: process
   
    begin
        reset <= '1';
        wait for CLK_period;
        reset <= '0';
        wait for CLK_period;
		

        -- Test case 1: nPCsel = '0', offset = 0
        nPCsel <= '0';
       offset <= x"000000";
        wait for CLK_period * 2;

        -- Test case 2: nPCsel = '1', offset = 1
        nPCsel <= '1';
        
        offset <= x"000003";
        wait for CLK_period * 2;
        

        -- Test case 3: nPCsel = '1', offset = ‘110101’
        nPCsel <= '1';
        offset <= x"000002";
        wait for CLK_period * 2;
        

        -- Additional test case: nPCsel = '1', offset = 10
        nPCsel <= '1';
        offset <= x"000001";
        wait for CLK_period * 2;

       
        Done <= True;
        
        wait;
    end process;

end Behavioral;
