library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity DataMemory_tb is
end entity DataMemory_tb;

architecture testbench of DataMemory_tb is
    -- 定义测试信号
    signal CLK: std_logic := '0';
    signal RST: std_logic;
    signal Addr: std_logic_vector(5 downto 0);
    signal DataInput: std_logic_vector(31 downto 0);
    signal WrEn: std_logic;
    signal DataOutput: std_logic_vector(31 downto 0);

    -- 实例化被测试的数据存储器
    begin
        uut: entity work.Data_Memory
        port map (
            CLK => CLK,
            RST => RST,
            Addr => Addr,
            DataInput => DataInput,
            WrEn => WrEn,
            DataOutput => DataOutput
        );

    -- 时钟信号产生
    clk_process :process
    begin
        CLK <= '0';
        wait for 10 ns;
        CLK <= '1';
        wait for 10 ns;
    end process;

    -- 测试过程
    stimulus_process: process
    begin
        -- 初始化
        RST <= '1';
        wait for 20 ns;
        RST <= '0';
        Addr <= (others => '0');
        DataInput <= (others => '0');
        WrEn <= '0';

        -- 写入测试
        Addr <= "000001";
        DataInput <= x"12345678";
        WrEn <= '1';
        wait for 20 ns;
        WrEn <= '0';
        wait for 20 ns;

        -- 读取测试
        Addr <= "000001";
        wait for 20 ns;

        -- 测试完成
        wait;
    end process;
end architecture testbench;
