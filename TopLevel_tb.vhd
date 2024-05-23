library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TopLevel_tb is
end entity TopLevel_tb;

architecture behavior of TopLevel_tb is
    -- Component Declaration for the Unit Under Test (UUT)
    component TopLevel
        port (
            CLK : in STD_LOGIC;
            RST, WE : in STD_LOGIC;
            OP1 : in STD_LOGIC_VECTOR(2 downto 0);
            Rea, Reb, ReW : in STD_LOGIC_VECTOR(3 downto 0);
            N, Z, C, V : out STD_LOGIC;
            OutPut_Data, A, B : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    -- Inputs
    signal CLK : STD_LOGIC := '0';
    signal RST, WEE : STD_LOGIC := '0';
    signal OP1 : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal Rea1, Reb1, RW : STD_LOGIC_VECTOR(3 downto 0);

    -- Outputs
    signal N : STD_LOGIC;
    signal Z : STD_LOGIC;
    signal C : STD_LOGIC;
    signal V : STD_LOGIC;
    signal Done : boolean := False;
    signal busW : STD_LOGIC_VECTOR(31 downto 0);
    signal A_O : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal B_O : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

    -- Clock period definitions
    constant CLK_period : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: TopLevel port map (
        CLK => CLK,
        RST => RST,
        OP1 => OP1,
        N => N,
        Z => Z,
        C => C,
        V => V,
        Rea => Rea1,
        Reb => Reb1,
        WE => WEE,
        ReW => RW,
        OutPut_Data => busW,
        A => A_O,
        B => B_O
    );

    -- Clock process definitions
    clk <= '0' when Done else not clk after CLK_period;

    -- Stimulus process
    stim_proc: process
    begin
  
        RST <= '1';
        wait for CLK_period;
        RST <= '0';
        wait for CLK_period;

        -- Stimulate signals
        Rea1 <= "1111";
        Reb1 <= "0001";
        OP1 <= "011";
        WEE <= '1';
        RW <= "0001";
        wait for CLK_period * 2;

        Rea1 <= "1111";
        Reb1 <= "0001";
        OP1 <= "000";
        WEE <= '1';
        RW <= "0001";
        wait for CLK_period * 2;

        Rea1 <= "1111";
        Reb1 <= "0001";
        OP1 <= "000";
        WEE <= '1';
        RW <= "0010";
        wait for CLK_period * 2;

        Rea1 <= "0001";
        Reb1 <= "1111";
        OP1 <= "010";
        WEE <= '1';
        RW <= "0011";
        wait for CLK_period * 2;

        Rea1 <= "0111";
        Reb1 <= "1111";
        OP1 <= "010";
        WEE <= '1';
        RW <= "0101";
        wait for CLK_period * 2;
        Done <= True;
        wait;
    end process;

end architecture behavior;
